function(doc, req) {
  provides('html', function() {
    send('<h1>' + doc.statement + '</h1>');
  });
  provides('json', function() {
    send(JSON.stringify(doc));
  });
}

