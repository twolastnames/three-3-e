import { render } from 'ejs'

// !json template.show.<%= showName %>

const sendHtml = (data) => {
  send(render(template.show.<%= showName %>, data));
  //send(Object.keys(ejs))
}

<%- include(codeFilename) %>
