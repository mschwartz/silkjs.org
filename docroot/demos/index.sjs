res.data.title = 'SilkJS - Demos';

var fs = require('fs'),
    markdown = require('github-flavored-markdown').parse;

include('Header.sjs');

res.write(markdown(fs.readFile('templates/demos.md')));

include('disqus.sjs');
include('Footer.sjs');
