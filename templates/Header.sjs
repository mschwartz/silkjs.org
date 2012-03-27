res.data.contact = '<a href="mailto:mykesx@gmail.com">mykesx@gmail.com</a>';
res.data.github = '<a href="http://github.com/mschwartz/SilkJS">GitHub</a>';
res.data.googleGroup = '<a target="_new" href="http://groups.google.com/group/SilkJS">SilkJS Google Group</a>';

print([
    '<!DOCTYPE html>',
    '<html lang="en">',
      '<head>',
      '  <meta charset="utf-8">',
      '  <title>' + res.data.title + '</title>',
      '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
      '  <meta name="description" content="">',
      '  <meta name="author" content="">',
      '',
      '  <!-- Le styles -->',
      '  <link href="/css/bootstrap.min.css" rel="stylesheet">',
      '  <link href="/css/bootstrap-responsive.min.css" rel="stylesheet">',
      '  <link href="/css/silkjs.org.css" rel="stylesheet">',
      '',
      '  <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->',
      '  <!--[if lt IE 9]>',
      '    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>',
      '  <![endif]-->',
      '  ',
      '  <!-- Le fav and touch icons -->',
    '<!--    <link rel="shortcut icon" href="/ico/favicon.ico">',
    '    <link rel="apple-touch-icon" href="/ico/apple-touch-icon.png">',
    '    <link rel="apple-touch-icon" sizes="72x72" href="/ico/apple-touch-icon-72x72.png">',
    '    <link rel="apple-touch-icon" sizes="114x114" href="/ico/apple-touch-icon-114x114.png"> -->',
    '  </head>',
    '    ',
    '  <body data-spy="scroll" data-target=".subnav" data-offset="50">',
    '  '
    ].join('\n'));

include('NavBar.sjs');

print('<div class="container">');

