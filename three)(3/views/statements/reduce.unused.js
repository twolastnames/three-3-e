function(keys, values, rereduce) {
  return values[0];
  var returnables = values.slice();
  returnables.sort(function(a, b) {
    if(a.statement < b.statement) return -1;
    if(a.statement > b.statement) return  1;
    return 0;
  });
  return returnables;
}
