res.data.title = 'SilkJS - Man Pages'

process = require 'builtin/process'

include 'Header.coffee'

res.writeln '<pre>'

res.write process.exec 'gzcat /usr/share/man/man1/ls.1.gz | groff -man -T ascii | col -b'

res.writeln '</pre>'

include 'Footer.coffee'