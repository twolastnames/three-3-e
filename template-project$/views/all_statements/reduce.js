function(keys, values, rereduce) {
  values.sort(function(a, b) {
    if(a < b) return -1;
    if(a > b) return  1;
    return 0;
  });
  return values;
}
