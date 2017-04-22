var fs = require('fs')
var ejs = require('ejs')

var templateData = "function hello(doc) {" +
"  var uuid = require('uuid');" +
"  console.log('hello');" +
"};" +
"hello();"


//var templateData = "var uuid = require('uuid');";

/*
var pwd = process.argv[2];
var file = process.argv[3];
var writtenData = fs.readFileSync(file);
*/

var result = ejs.render(templateData, {})

console.log(result)
