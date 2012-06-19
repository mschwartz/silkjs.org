/**
 * Created by JetBrains WebStorm.
 * User: mschwartz
 * Date: 3/23/12
 * Time: 3:50 PM
 */

/*global req, res, include, hr, println */

"use strict";

/*global require, req, res */

res.data.title = 'SilkJS - Documentation';

var fs = require('fs');
var parse = require('docgen');
var empty = require('phpjs').empty;

var pathInfo = req.path_info || '';

//var docBase = '/Users/mschwartz/src/SilkJS'; // '/usr/share/silkjs';
var docBase = '/usr/local/silkjs';
var srcPath = docBase + '/src/';
var jsPath = docBase + '/modules/';

function sort(docs) {
    var ndocs = [];
    docs.each(function (o, filename) {
        if (empty(o) || o[0].tag === 'ignore') {
            return;
        }
        var tag = o[0].tag;
        if (tag !== 'module' && tag !== 'namespace' && tag !== 'class' && tag !== 'singleton') {
            o[0].tag = 'undocumented';
            return;
        }
        var name = o[0].name || filename.replace(/\.cpp/, '');
        ndocs.push({ key: name, value: o });
    });
    ndocs.sort(function(a, b) {
        return a.key.toLowerCase().localeCompare(b.key.toLowerCase());
    });
    docs = {};
    ndocs.each(function(value, key) {
        docs[value.key] = value.value;
    });
    return docs;
}

var cppDocs = {};
fs.readDir(srcPath).each(function(fn) {
    if (fn.endsWith('.cpp')) {
        cppDocs[fn] = parse(srcPath + fn);
    }
});
cppDocs = sort(cppDocs);

var jsDocs = {};
fs.listRecursive(jsPath).each(function(fn) {
    if (fn.endsWith('.js')) {
        jsDocs[fn] = parse(fn);
    }
});
jsDocs = sort(jsDocs);

function renderNav() {
    println('<div class="span2">');
    println('<div class="well"  style="padding: 8px 0;"><ul class="nav nav-list">');

    if (!pathInfo.length) {
      println('<li class="active"><a href="#top">Documentation</a></li>');
    }
    else {
      println('<li><a href="/documentation/">Documentation</a><li>');
    }

    println('<li class="nav-header">Builtin Modules</li>');
    
    cppDocs.each(function(o, name) {
        var cls = name === pathInfo ? ' class="active"' : '';
        println('<li'+cls+'><a href="/documentation/'+name+'">'+name+'</a></li>');
    });

    println('<li class="nav-header">JavaScript Modules</li>');
    jsDocs.each(function(o, name) {
        var cls = name === pathInfo ? ' class="active"' : '';
        println('<li'+cls+'><a href="/documentation/'+name+'">'+name+'</a></li>');
    });

    println('</ul>');
    println('</div><!-- well -->');
    println('</div><!-- span2 -->');
}

function renderIndex(doc) {
    println('<div class="span3">');
    println('<div class="well"  style="padding: 8px 0;"><ul class="nav nav-list">');

    println("<li class=\"nav-header\">Methods Index</li>");
    doc.each(function(o) {
        if (o.tag === 'function' || o.tag === 'constructor') {
            println('<li><a href="#'+o.name.replace(/[\.\/]/igm, '-') + '">' + o.name + '</a></li>');
        }
    });
    println('</ul>');
    println('</div><!-- well -->');
    println('</div><!-- span2 -->');

}

function renderDoc(doc) {
    doc.each(function(o) {
        o.content = '<div style="padding-left: 15px;">' + o.content + '</div>';
        switch (o.tag) {
            case 'module':
                println('<header class="hero-unit">');
                println('<h1>' + o.name + '<small>Module</small></h1>');
                println(o.content);
                println('</header>');
//                hr();
                break;
            case 'namespace':
                println('<header class="hero-unit">');
                println('<h1>' + o.name + '<small>namespace</small></h1>');
                println(o.content);
                println('</header>');
//                hr();
                break;
            case 'class':
                println('<header class="hero-unit">');
                println('<h1>' + o.name + '<small>class</small></h1>');
                println(o.content);
                println('</header>');
//                hr();
                break;
            case 'function':
                println('<a name="'+o.name.replace(/[\.\/]/igm, '-')+'"></a>');
                println('<h2>Function: ' + o.name + '</h2>');
                println(o.content);
                println('<p class="pull-right"><a href="#">Back to top</a></p>');
                hr();
                break;
            case 'constructor':
                println('<a name="'+o.name.replace(/[\.\/]/igm, '-')+'"></a>');
                println('<h2>Constructor: ' + o.name + '</h2>');
                println(o.content);
                println('<p class="pull-right"><a href="#">Back to top</a></p>');
                hr();
                break;
            case 'constant':
                println('<h2>Constants</h2>');
                println(o.content);
                break;
        }
    });
}

include('Header.sjs');

println('<div class="row">');

renderNav();

println('<div class="' + (pathInfo.length ? 'span7': 'span10') + '">');
//println('<div class="page-header"><h1>Documentation<small>'+pathInfo+'</small></h1></div>');

if (pathInfo.length) {
    var rendered = false;
    cppDocs.each(function(doc) {
        if (!doc[0]) {
            return;
        }

        if (doc[0].tag !== 'module' && doc[0].tag !== 'namespace' && doc[0].tag !== 'class') {
            return;
        }
        if (doc[0].name !== pathInfo) {
            return;
        }
        renderDoc(doc);
        rendered = true;
        println('</div><!-- /span8 -->');
        renderIndex(doc);
        return false;
    });
    jsDocs.each(function(doc) {
        if (!doc[0]) {
            return;
        }

        if (doc[0].tag !== 'module' && doc[0].tag !== 'namespace' && doc[0].tag !== 'class') {
            return;
        }
        if (doc[0].name !== pathInfo) {
            return;
        }
        renderDoc(doc);
        rendered = true;
        println('</div><!-- /span8 -->');
        renderIndex(doc);
        return false;
    });
}
else {
    cppDocs.each(function(doc) {
        if (!doc[0] || doc[0].tag !== 'module') {
            return;
        }
        println('<h2>Module: ' + doc[0].name + '</h2>');
        println(doc[0].content);
        hr();
    });
    res.write('</div><!-- /span10 -->');
}

println('</div><!-- /row -->');

include('disqus.sjs');
include('Footer.sjs');
