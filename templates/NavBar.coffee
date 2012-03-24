active = (uri) ->
  if req.script_path == uri then 'active' else ''

res.write """

<!-- Navbar
================================================== -->
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <a class="brand" href="/">SilkJS.org</a>
      <div class="nav-collapse">
        <ul class="nav">
          <li class="#{active('/')}">
            <a href="/">Overview</a>
          </li>
          <li class="#{active('/Installing/')}">
            <a href="/Installing/">Installing SilkJS</a>
          </li>
          <li class="#{active('/GettingStarted/')}">
            <a href="/GettingStarted/">Getting Started</a>
          </li>
          <li class="#{active('/HttpServer/')}">
            <a href="/HttpServer/">HTTP Server</a>
          </li>
          <li class="#{active('/Docs/')}">
            <a href="/Docs/">Documentation</a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>

"""