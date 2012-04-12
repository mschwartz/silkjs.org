res.data.title = 'SilkJS - Getting Started';

var fs = require('fs'),
    markdown = require('github-flavored-markdown').parse;

include('Header.sjs');

function code(s) {
    return '<p>$ <code>' + s + '</code></p>';
}

res.write(markdown(fs.readFile('templates/sync-vs-async.md')));

include('disqus.sjs');
include('Footer.sjs');
