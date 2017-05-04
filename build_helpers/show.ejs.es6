import { render } from 'ejs';

// !json template.show.<%= showName %>

const sendHtml = (data) => {
  send(render(template.show.<%= showName %>, data));
}

provides('html', function() {
  sendHtml(doc);
});

provides('json', function() {
  send(JSON.stringify(doc));
});

<%- include(codeFilename) %>
