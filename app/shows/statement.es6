provides('html', function() {
  sendHtml(doc)
//  send('<h1>' + doc.statement + '</h1><p>' +
//    Number(number()).toString() + '</p>');
});

provides('json', function() {
  send(JSON.stringify(doc));
});
