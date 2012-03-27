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
        nav('/installing-silkjs/', 'Installing SilkJS'),
        nav('/getting-started/', 'Getting Started'),
        nav('/http-server/', 'HTTP Server'),
        nav('/documentation/', 'Documentation'),
        nav('/contact-us/', 'Contact Us'),
'        </ul>',
'      </div>',
'    </div>',
'  </div>',
'</div>'
].join('\n'));
