exports.statementsByOperation = function(operation, doc) {
  if(!(doc.statement && doc.operation)) return;
  if(doc.operation === operation) {
    emit(operation, doc);
  }
};
