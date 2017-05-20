#!/usr/bin/env node

const async = require('async');
const uuid = require('uuid/v4');
const format = require('util').format;
//const Client = require('node-rest-client').Client;
//const client = new Client();
const promisify = require('bluebird').promisify;
const coroutine = require('bluebird').coroutine;
const _ = require('lodash');
const createInterface = require('readline').createInterface;
const lineReader = require('line-reader');

const database = process.argv[2];
const location = "http://127.0.0.1:5984";

const nano = require('nano')(format('%s/%s', location, database))

let feature;
let scenario;
let lastStatement;

let scenarioStatements = [];

const putDocument = promisify(nano.insert);
const getDocument = promisify(nano.get);

function insertStatement(operation, description) {
  let step = '';
  let datas = [];
  const parts = description.split('"');
  for(let i = 0 ; i < parts.length ; i += 2) {
    const text = parts[i];
    const data = parts[i + 1];
    step += text;
    if(!data) continue;
    step += '~';
    datas.push(data);
  }
  const id = 'stm_' + uuid();
  const forScenario = new Promise((resolve) => {
    getDocument(scenario).then((document) => {
      document.executables.push({
        statetment: id,
	data: datas,
      });
      putDocument(document).then(resolve).catch((err) => {
        console.error('problem rewriting scenario', err);
      });
    });
  });
  const inserter = putDocument({
    operation: operation,
    step: step,
  }, id);
  return Promise.all([inserter, forScenario]);
}

function insertScenario(rawDescription) {
  const description = rawDescription.match(/[\s:]*(.*)$/)[1]
  scenario = 'scn_' + uuid();
  return putDocument({
    feature: feature,
    description: description,
    executables: [],
  }, scenario);
}

function insertFeature(rawDescription) {
  const description = rawDescription.match(/[\s:]*(.*)$/)[1];
  feature = 'ftr_' + uuid();
  return putDocument({description: description}, feature);
}

function doScenario(description) {
  lastStatement = null;
  return insertScenario(description.trim());
}

function doStatement(operation, description) {
  const useOperation = operation === 'and' ? lastStatement : operation;
  lastStatement = useOperation;
  return insertStatement(useOperation, description.trim());
}

function doFeature(description) {
  return insertFeature(description.trim());
}

lineHandlers = {
  feature: doFeature,
  scenario: doScenario,
  given: _.partial(doStatement, 'given'),
  when: _.partial(doStatement, 'when'),
  then: _.partial(doStatement, 'then'),
  and: _.partial(doStatement, 'and'),
}

lineReader.open(process.stdin, coroutine(function*(err, reader) {
  if(err) {
    console.error(err);
    return;
  };
  while(reader.hasNextLine()) {
    yield new Promise((resolve, reject) => {
      reader.nextLine((err, rawLine) => {
        let line = rawLine.trim();
        if(line.length === 0) {return resolve();}
        const firstWordExpression = /^(\w+)(.*)$/;
        const match = line.match(firstWordExpression);
        const word = match[1].toLowerCase()
        const description = match[2];
        lineHandlers[word](description).then(resolve).catch(reject);
      });
    });
  }
}));
