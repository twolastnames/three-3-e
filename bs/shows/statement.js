function(doc, req) {
  provides('html', function() {
    var uuid = require('uuid').uuid.v4;
    send('<h1>' + doc.statement + '</h1><p>' +
       uuid() + '</p>');
  });
  provides('json', function() {
    send(JSON.stringify(doc));
  });
}
