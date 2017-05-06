import 'babel-polyfill';
import { render } from 'ejs';
import { map } from 'lodash';

// !json template.list.<%= listName %>

provides('html', function() {
  const data = {
    request: req,
    getRow: getRow,
  }

  send(render(template.list.<%= listName %>, data));
});

provides('json', function() {
  const values = [];
  let row;
  while(row = getRow()) {
    values.push(row.value);
  }
  send(JSON.stringify(values));
});

<%- include(codeFilename) %>
