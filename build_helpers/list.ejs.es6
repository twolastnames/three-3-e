import 'babel-polyfill';
import { render } from 'ejs';
import { map } from 'lodash';

// !json template.list.<%= showName %>

provides('html', function() {
  const data = { rows: function *() {
    let row;
    while(row = getRow()) {
      yield row.value;
    }
  }
  send(render(template.list.<%= showName %>, data));
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
