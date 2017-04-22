function statementsByOperation(operation, doc) {
  if(!(doc.statement && doc.operation)) return;
  if(doc.operation === operation) {
    emit(operation, doc);
  }
}

exports.statementsByOperation = {
  statementsByOperation : statementsByOperation,
}
