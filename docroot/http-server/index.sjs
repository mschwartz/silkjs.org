res.data.title = 'SilkJS - HTTP Server';

var fs = require('fs'),
    markdown = require('github-flavored-markdown').parse;

function code(s) {
    return '<p>$ <code>' + s + '</code></p>';
}

include('Header.sjs');

res.write(markdown(fs.readFile('templates/http-server.md')));


include('disqus.sjs');
include('Footer.sjs');


