res.data.title = 'SilkJS - demo1';

var fs = require('fs'),
    markdown = require('github-flavored-markdown').parse;

include('Header.sjs');

res.write(markdown(fs.readFile('templates/demo1.md')));

function show_source(fn) {
    res.write('<h2>' + fn + '</h2>');
    res.write('<pre style="border: 1px solid black; padding: 5px;">' + fs.readFile('docroot/demos/demo1/' + fn) + '</pre>');
}

show_source('image1.sjs');
show_source('image2.sjs');
show_source('image3.sjs');

include('disqus.sjs');
include('Footer.sjs');
