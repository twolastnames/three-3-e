
function(head, req) {

  provides("html", function() {
    html = '<ul class="statements">';
    while(row = getRow()) {
      html += '<li>';
      html += row.value.statement;
      html += '</li>';
      //return template(template.statements.row, {row: row});

/*      statement = row.value.statement;
      operation = row.value.operation;
      html += '<li>';
      html +=   '<span class="operation">' + operation + '</span> ';
      html +=   '<span class="statement">' + statement + '</span>';
      html += '</li>';*/
    }
    html += '</ul>';
    return html;
  });
}
