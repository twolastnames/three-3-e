function(doc) {
  if(!(doc.step && doc.operation)) return;
  var key = doc.operation + ' ' + doc.step.toLowerCase();
  emit(key, doc);
}
