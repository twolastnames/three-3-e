exports.stepsByOperation = function(operation, doc) {
  if(!(doc.step && doc.operation)) return;
  if(doc.operation === operation) {
    emit(operation, doc);
  }
};
