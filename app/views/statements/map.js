function(doc) {
  if(!(doc.statement && doc.operation)) return;
  var key = doc.operation + ' ' + doc.statement.toLowerCase();
  emit(key, doc); 
}
