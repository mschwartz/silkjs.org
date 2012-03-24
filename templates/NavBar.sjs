function nav(url, prompt) {
    var cls = req.script_path === url ? 'active' : '';
    return [
'          <li class="'+cls+'">',
'            <a href="'+url+'">' + prompt + '</a>',
'          </li>'
    ].join('\n');
}
println([
'<!-- Navbar',
'================================================== -->',
'<div class="navbar navbar-fixed-top">',
'  <div class="navbar-inner">',
'    <div class="container">',
'      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">',
'        <span class="icon-bar"></span>',
'        <span class="icon-bar"></span>',
'        <span class="icon-bar"></span>',
'      </a>',
'      <a class="brand" href="/">SilkJS.org</a>',
'      <div class="nav-collapse">',
'        <ul class="nav">',
    nav('/', 'Overview'),
    nav('/Installing/', 'Installing SilkJS'),
    nav('/GettingStarted/', 'Getting Started'),
    nav('/HttpServer/', 'HTTP Server'),
    nav('/Docs/', 'Documentation'),
//'          <li class="#{active('/')}">',
//'            <a href="/">Overview</a>',
//'          </li>',
//'          <li class="#{active('/Installing/')}">',
//'            <a href="/Installing/">Installing SilkJS</a>',
//'          </li>',
//'          <li class="#{active('/GettingStarted/')}">',
//'            <a href="/GettingStarted/">Getting Started</a>',
//'          </li>',
//'          <li class="#{active('/HttpServer/')}">',
//'            <a href="/HttpServer/">HTTP Server</a>',
//'          </li>',
//'          <li class="#{active('/Docs/')}">',
//'            <a href="/Docs/">Documentation</a>',
//'          </li>',
'        </ul>',
'      </div>',
'    </div>',
'  </div>',
'</div>'
].join('\n'));
