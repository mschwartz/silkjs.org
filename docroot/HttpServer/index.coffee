res.data.title = 'SilkJS - HTTP Server'

include 'Header.coffee'

code = (s) ->
  "<p>$ <code>#{s}</code></p>"

res.write """
<h1>HTTP Server</h1>
<p>SilkJS comes with an HTTP server that is written almost entirely in JavaScript using the SilkJS libraries
and modules.  The HTTP server can serve both static and dynamic content, and is very fast.  This walkthrough
will get you started at building WWW applications using the SilkJS HTTP server.</p>

<h2>Design Considerations</h2>
<p>Great care has been taken to assure the HTTP server is fast.  It was designed to be a replacement for PHP,
Java, mod_perl, Ruby, and other non-JavaScript language based environments.  It is ideally suited for RIA
applications due to its ability to process transactional type requests (e.g. Ajax) in microseconds or a few
milliseconds each.  The server can also serve static content (images, scripts, css, etc.), so it is well suited
to serve just about every kind of request that might be made from clients.</p>

<p>Emphasis is placed on implementing as much of SilkJS and the HTTP server in JavaScript as possible.
C++ is mainly used to implement a "thin layer of glue" between the JavaScript context and the operating system
calls and libraries supported by the operating system.  In theory, users of SilkJS HTTP server can hack on the
JavaScript code to bend it to their will, without needing expertise in any language but JavaScript.</p>

<p>The silkjs.org WWW site should be served entirely by its own HTTP server.  This is not true of other
HTTP server solutions.</p>

<p>The server is to be highly extendable without hacking on the server's source code.</p>

<p>The server should be able to handle "Servlet" style requests as well as dynamic "JSP" style requests, on
top of being fast for static content.</p>

<p>"Servlet" style requests are handled by calling a subroutine that is already resident in the server.  This
is the fastest way to run some business logic on the server side in response to a request.</p>

"JSP" style requests are handled by loading a script file from the file system, compiling it, and running it.
"JSP" scripts can be JST (a JSP-like template langauge), CoffeeScript, Less CSS, etc.  The server should be
smart enough to load, compile, cache, and run these scripts.  If the file does not change on disk, the
cached version will be run for the second and each succeeding request.</p>

<h3>Pre-fork Model</h3>
<p>The HTTP server is implemented as a <strong>synchronous</strong> traditional pre-fork model program.  The
server consists of a "main" process and some number of "child" processes.  There may be additional processes
running as part of the server, such as the log file flush process, which wakes up every few seconds and flushes
log file messages to the disk.  Each HTTP child process is designed to handle a large number of requests and
support keep-alive connections.  The child processes are protected from one another so if one somehow
crashes, it doesn't bring down the server - the main process will simply spawn a new child to take its
place.</p>

<p>If you've read the <a href="/GettingStarted/">Getting Started</a> page on this site, you should have a
good idea of how nice it is to write your logic in top-to-bottom/left-to-right style, without having to
mess with callbacks.  If your logic needs to block, that's fine because the operating system is very good
at scheduling process that need to block and those that need to run.</p>

<h2>Setting up an application</h2>

<p>The server is started from the command line:</p>
#{code('httpd-silk.js bootstrap.js')}
<p>The bootstrap.js program is a startup script that you will write to load your API into the server, as well
as your "Servlet" request handler methods.  The bootstrap is loaded and run before the server pre-forks the
child processes.  This means each child will have all the API libraries and request handlers you've loaded available
to them.</p>

<p>With that in mind, a good initial layout for your application might look something like this:</p>
<ul>
  <li>Application/</li>
  <ul>
    <li>bootstrap.js</li>
    <li>docroot/</li>
    <li>server/</li>
  </ul>
</ul>

<p>You'll name your Application directory as the name of the application or WWW site.<p>

<p>The docroot directory will contain your static content and your dynamic "JSP" style pages.
You might organize your docroot into a /css, a /js, an /img, directories.  Your CSS files will be
served by requests for /css/whatever.css, your JavaScript files will be served by requests for /js/whatever,
and so on.  Otherwise you'll organize your static HTML and dynamic pages as you would for a server like
Apache; if you make an about/ folder, a request for /about/ will attempt to serve the directory index page
for the about/ folder.<p>

<p>The HTTP server has a default Config object, which you can modify in your bootstrap.js script.  The Config
object contains the path to your documentRoot, the numChildren (number of children to pre-fork), MySQL
connection parameters, and directoryIndex setup.  The Config.directoryIndex member is an array of filenames
that will be looked for if the request is for a directory.  The defaults are:</p>
<pre>
		'index.jst',
		'index.coffee',
		'index.md',
		'index.html'
</pre>
<p>Thus if a directory is requested by URI, an index.jst will be served if found, an index.coffee served if
index.jst not found, etc.  If none of the directoryIndex filenames are found, then a notFound error occurs.</p>

<p>The server/ directory might contain any custom classes, modules, etc., that you might want to require()
or include() for your application.  This site, for example, has a templates/ folder which contains CoffeeScript
snippets to generate the Header, Footer, Navigation, etc., and they are included by .coffee pages dynamically
run upon request.</p>

<h3>Actions</h3>
<p>"Servlet" style requests are handled by "action" methods that are pre-loaded into the server.  These are
simply <strong>global</strong> methods that have names that end with _action().  If there is an action method
for the first element of the requested URI, it is called; anything else in the URI is ignored, though the
action method may examine the URI and perform appropriate logic in response.  If the _action() method returns,
the normal HTTP server processing will continue - the documentRoot is searched for a file that is served
statically or JSP style.<p>

<p>For example, if you have defined a global foo_action() method, and the requested URI is /foo, or /foo/, or
/foo/anything/else/you/want, then foo_action() is called to handle the request.  The same thing is true
if you have a function bar_action() and the URI is /bar.</p>

<p>A special case main_action() method may be defined.  It handles the / request URI, but only that URI.</p>

<p>If you want to have a function that is called on each request, you can set HttpChild.requestHandler to your
own function; this function will be executed for each request, and if it returns, the normal HTTP server
processing will occur.  You might want to install a requestHandler to authenticate a user by cookie, each
request.</p>

<p>When a 404 occurs, the server will look for a notFound_action() method and will call that.  If that function
returns, the built-in 404 handler will execute.</p>

<h3>The req and res Objects</h3>
<p>There is a global req and global res object set up in the HTTP environment per request.  These are available
in the onRequest() method, in your action methods, and in your dynamic pages.</p>

<p>The req object represents information about the request.  This is an example dump of the req object:</p>
<pre>
(object) :
 [init] : function() { ... }
 [getHeader] : function (key) {
			return headers[key.toLowerCase()];
		}
 [close] : function() { ... }
 [start] : (number) 1332115211475
 [headers] : (object) :
   [user-agent] : (string) curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
   [host] : (string) localhost:9091
   [accept] : (string) */*
   [] : (string) (empty)
 [host] : (string) localhost
 [port] : (string) 9091
 [method] : (string) GET
 [uri] : (string) /
 [proto] : (string) HTTP/1.1
 [remote_addr] : (string) 127.0.0.1
 [data] : (object) :
 [script_path] : (string) /
</pre>
<p>As you can see, it contains the headers, the host name requested, the port, the method (GET, PUT, etc.),
the requested URI, the HTTP protocol, the client's IP address, and the path to the script that is being
executed (if it is not a script, this is meaningless).</p>

<p>The req.data member contains the post variables, query_string variables, multi-part/mime variables, and
cookies.  It is a has of key/value pairs, where key is the name of the variable or cookie, and value is the
value.  For POST data that is a file upload, the value is a hash containing information about the file, and
the base64 encoded file data.</p>

<p>The res object represents information your code is preparing to send to the client as the response.  This
is an example dump of the res object:</p>

<pre>
(object) :
 [sock] : (number) 6
 [status] : (number) 200
 [contentLength] : (number) 0
 [contentType] : (string) text/html
 [headers] : (object) :
   [Server] : (string) SILK JS Server
   [Connection] : (string) close
 [init] : function() { ... }
 [stop] : function () {
			throw 'RES.STOP';
		}
 [reset] : function () {
			buffer.reset(buf);
		}
 [setCookie] : function() { ... }
 [setHeader] : function (key, value) {
			res.headers[key] = value;
		}
 [sendHeaders] : function() { ... }
 [write] : function() { ... }
 [writeln] : function (s) {
            res.write(s + '\n');
		}
 [write64] : function() { ... }
 [sendFile] : function() { ... }
 [flush] : function() { ... }
 [redirect] : function() { ... }
 [close] : function () {
			buffer.destroy(buf);
		}
 [cookies] : (object) :
 [data] : (object) :
</pre>
<p>You may set the response code to something other than 200 (OK) by setting res.status.  You may
set the content's MIME type to something other than text/html by setting res.contentType.</p>

<p>The res.data member is free for you to use for any purpose you choose.  Think of it as a "global"
variable you can pass to all functions, initialized per request.</p>

<p>There are several functions provided by res that you will use heavily:</p>
<ul>
<li>res.stop() - call this to end your request processing without allowing the server to do its normal
processing (e.g. serving static or dyanmic content from documentRoot).</li>
<li>res.write(s) - write a string to the client; these are buffered until you call res.stop(), then sent.</li>
<li>res.writeln(s) - same as res.write() but adds a newline to the output.</li>
<li>res.sendFile(path) - sends a file of your choosing, does not return.</li>
<li>res.redirect(uri) - send a 302 redirect to the specified URI.</li>
<li>res.setHeader(key, value) - sets a header to be sent to the client.</li>
<li>res.setCookie(key, value, expires, path, domain) - set a cookie, only key/value are required.</li>
</ul>




"""

include 'Footer.coffee'


