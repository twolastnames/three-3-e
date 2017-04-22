const fs = require('fs');
const _ = require('lodash');

const package = fs.readFileSync(__dirname + '/../package.json').toString()
const dependencies = JSON.parse(package).dependencies;
const names = Object.keys(dependencies);

const blacklisteds = [
  'async', 'bluebird', 'line-reader', 'nano', 'node-rest-client',
].sort();

let name;
while(name = names.shift()) {
  if(_.sortedIndexOf(blacklisteds, name) >= 0) {
    continue;
  }
  console.log(name);
}
