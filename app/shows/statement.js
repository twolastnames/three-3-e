function(doc, req) {
  var number = require('lib/some_number').number;
  provides('html', function() {
    send('<h1>' + doc.statement + '</h1><p>' +
      Number(number()).toString() + '</p>');
  });
  provides('json', function() {
    send(JSON.stringify(doc));
  });
}
