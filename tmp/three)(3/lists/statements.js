function(doc, req) {
'use strict';

require('babel-polyfill');

var _ejs = require('ejs');

var _lodash = require('lodash');

// !json template.list.statements

provides('html', function () {
  var data = {
    request: req,
    getRow: getRow
  };

  send((0, _ejs.render)(template.list.statements, data));
});

provides('json', function () {
  var values = [];
  var row = void 0;
  while (row = getRow()) {
    values.push(row.value);
  }
  send(JSON.stringify(values));
});

}
