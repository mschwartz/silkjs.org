res.data.title = 'SilkJS - Docs'

include 'lib/phpjs.js'
srcPath = '/Users/mschwartz/src/SilkJs/src/' # '/usr/share/silkjs/src/'
fs = require 'builtin/fs'
parse = require 'docgen'

pathInfo = req.path_info or '';
srcFiles = fs.readDir srcPath

docs = {}
srcFiles.each (fn) ->
  return unless fn.endsWith '.cpp'
  docs[fn] = parse srcPath + fn

renderNav = ->
  res.writeln '<div class="span2">'
  res.writeln '<div class="well"  style="padding: 8px 0;"><ul class="nav nav-list">'

  if empty pathInfo
    res.write '<li class="active"><a href="#top">Documentation</a></li>'
  else
    res.write '<li><a href="/Docs/">Documentation</a><li>'

  res.writeln '<li class="nav-header">Builtin Modules</li>'
  docs.each (o, filename) ->
    return if empty(o)  or (o[0].tag is 'ignore')
    tag = o[0].tag
    unless tag is 'module' or tag is 'namespace' or tag is 'class' or tag is 'singleton'
      o[0].tag = 'Undocumented'
#    return if o[0].tag is 'ignore'
    name = o[0].name or filename.replace /\.cpp/, ''
    cls = if name is pathInfo then ' class="active"'else ''
    res.writeln "<li#{cls}><a href=\"/Docs/#{name}\">#{name}</a></li>"

  res.writeln '<li class="nav-header">Undocumented</li>'
  docs.each (o, name) ->
    return unless empty o
    name = name.replace '.cpp', ''
    res.writeln "<li>#{name}</li>"

  res.writeln '</ul>'
  res.writeln '</div><!-- well -->'
  res.writeln '</div><!-- span2 -->'

renderIndex = (doc) ->
  res.writeln '<div class="span2">'
  res.writeln '<div class="well"  style="padding: 8px 0;"><ul class="nav nav-list">'

  res.writeln "<li class=\"nav-header\">Methods Index</li>"
  doc.each (o) ->
      if o.tag is 'function'
        res.writeln "<li>#{o.name}</li>"

  res.writeln '</ul>'
  res.writeln '</div><!-- well -->'
  res.writeln '</div><!-- span2 -->'

renderDoc = (doc) ->
  doc.each (o) ->
    o.content = "<div style=\"padding-left: 15px;\">#{o.content}</div>";
    switch o.tag
      when 'module'
        res.writeln "<h1>Module: #{o.name}</h1>"
        res.writeln o.content
        hr()
      when 'namespace'
        res.writeln "<h1>Namespace: #{o.name}</h1>"
        res.writeln o.content
        hr()
      when 'function'
        res.writeln "<h2>Function: #{o.name}</h2>"
        res.writeln o.content
        hr()
      when 'constant'
        res.writeln "<h2>Constants</h2>"
        res.writeln o.content

include 'Header.coffee'

res.writeln '<div class="row">'

renderNav()

if pathInfo.length
  res.writeln '<div class="span8">'
else
  res.writeln '<div class="span10">'

res.writeln "<div class=\"page-header\"><h1>Documentation<small>#{pathInfo}</small></h1></div>"

if pathInfo.length
  docs.each (doc) ->
    return unless doc[0] and (doc[0].tag is 'module' or doc[0].tag is 'namespace')
    return unless doc[0].name is pathInfo
    renderDoc doc
    res.writeln '</div><!-- span8 -->'
    renderIndex doc
    return false
else
  docs.each (doc) ->
    return unless doc[0] and (doc[0].tag is 'module')
    res.writeln "<h2>Module: #{doc[0].name}</h2>"
    res.writeln doc[0].content
    hr()
  res.write '</div><!-- span10 -->'

res.write '</div><!-- row -->'

include "Footer.coffee"