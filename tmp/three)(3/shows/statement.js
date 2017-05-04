function(doc, req) {
'use strict';

var _ejs = require('ejs');

// !json template.show.statement

var sendHtml = function sendHtml(data) {
  send((0, _ejs.render)(template.show.statement, data));
};

provides('html', function () {
  sendHtml(doc);
});

provides('json', function () {
  send(JSON.stringify(doc));
});

}
