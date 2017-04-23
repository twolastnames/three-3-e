function(doc) {
  if(!(doc.statement && doc.operation)) return;
  emit(doc.operation, doc); 
}
