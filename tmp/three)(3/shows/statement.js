function(doc, req) {
'use strict';

var _ejs = require('ejs');

// !json template.show.statement

var sendHtml = function sendHtml(data) {
  send((0, _ejs.render)(template.show.statement, data));
  //send(Object.keys(ejs))
};

provides('html', function () {
  sendHtml(doc);
  //  send('<h1>' + doc.statement + '</h1><p>' +
  //    Number(number()).toString() + '</p>');
});

provides('json', function () {
  send(JSON.stringify(doc));
});

}
