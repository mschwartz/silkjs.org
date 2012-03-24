res.data.title = 'SilkJS - JavaScript for the rest of us'

include 'Header.coffee'

res.write """
  <header class="hero-unit">
    <img align="left" src="/img/logo.png" />
    <h1>What is it?</h1>
    <div stlye="float: right">
    <p>SilkJS is a command shell built on top of Google's v8 JavaScript engine, highly optimized for
    server-side applications.  Targeted for the Linux server environment, the API strongly resembles
    Linux OS and library calls.</p>
    <br clear="all" />
    <p>* SilkJS runs on Linux and is supported for OSX as a development environment.</p>
    <a href="https://github.com/mschwartz/SilkJS/" class="btn btn-primary btn-large">View project on GitHub</a>
    <a href="http://groups.google.com/group/SilkJS" class="btn btn-large">SilkJS Google Group</a>
  </header>
"""

hr()


res.write """
  <div class="row">
    <div class="span4">
      <h2>Scripting for the Server</h2>
        <p>SilkJS enables JavaScript as a scripting language in the server environment.  You can think of SilkJS
        as a command shell, along the lines of Perl or PHP, except the language you write in is JavaScript.
        Virtually anything you currently do with a combination of server-side technologies can be done using
        JavaScript running under SilkJS.</p>
    </div>
    <div class="span4">
      <h2>Blazing fast HTTP server</h2>
        <p>SilkJS includes an HTTP server written almost entirely in JavaScript.  You don't have to wonder
        what's going on under the hood, or dive into a mess of C++ code to figure out how it works.  The
        server is pre-fork model, so you get to write your business logic top-to-bottom and left-to-right.
        With SilkJS, you will find you write less code and it runs faster!</p>
    </div>
    <div class="span4">
      <h2>Fewer Moving Parts</h2>
      <p>SilkJS does a lot of what you want out of the box, including the dynamic loading, compilation,
      and execution of dynamic languages like JST, CoffeeScript, Markdown, and Less CSS.  The HTTP server
      naturally uses your machine's resources, including your CPU cores, as your application demands.
      </p>
    </div>
  </div><!--/row-->
"""

res.write """
  <div class="row">
    <div class="span4">
      <h2>Ideal for RIA</h2>
      <p>Rich Internet Applications (RIA) tend to be a single page with little HTML markup.  The client pages
      are rendered as logical components via DOM manipulation in JavaScript.  The content for these component
      areas are fetched from the server via AJAX calls.  SilkJS HTTP server can deliver the HTML markup, the
      static content (images, stylesheets, JavaScripts, etc.), and handle large numbers of AJAX requests.
      </p>
    </div>
    <div class="span4">
      <h2>RPC Strategy</h2>
        <p>Each Ajax request from client to server can be thought of as a remote procedure call.  The
        client JavaScript program requests a remote method, either by URL scheme or by POST or query_string
        parameters, and passes arguments to that remote method the same ways.  The server executes the requested
        procedure and returns the results via HTML, JSON, XML, or other agreed upon format.  SilkJS HTTP server
        is very fast for these types of transactions.</p>
    </div>
    <div class="span4">
      <h2>API Strategy</h2>
      <p>A primary design objective of SilkJS is to implement of its ecosphere as much as possible
      in JavaScript.  To that end, the lowest level functionality is implemented as the most minimal
      "glue" functions to the operating system's functions and library functions.  The idea is to
      implement sophisticated JavaScript API on top of these glue functions.
      </p>
    </div>
  </div><!--/row-->
"""

res.write """
  <div class="row">
    <div class="span4">
      <h2>OS-Level API</h2>
        <p>SilkJS provides a thin layer of "glue" functions to access Linux and OSX OS calls:</p>
        <ul>
        <li>File System</li>
        <li>Networking</li>
        <li>Process Management</li>
        <li>Console</li>
        </ul>
    </div>
    <div class="span4">
      <h2>Library API</h2>
        <p>SilkJS includes a thin layer of "glue" functions to access several popular libraries:</p>
        <ul>
        <li>GD2</li>
        <li>MySQL</li>
        <li>ncurses</li>
        <li>SQLite3</li>
        <li>SSH2</li>
        <li>CURL</li>
        </ul>
    </div>
    <div class="span4">
      <h2>JavaScript API</h2>
      <p>SilkJS comes with a set of classes and modules that you may use (or roll your own!):</p>
      <ul>
      <li>Showdown (Markdown)</li>
      <li>CoffeeScript compiler</li>
      <li>Less CSS compiler</li>
      <li>UglifyJS minifier</li>
      <li>PHPJS (some functions)</li>
      <li>MySQL</li>
      <li>Schema (ORM)</li>
      <li>SSH (exec)</li>
      <li>XHR</li>
    </div>
  </div><!--/row-->
"""

hr()

res.write """

<div class=row">
  <div class="span12">
    <p>Operating systems like Windows, Linux, BSD, and Solaris are written in "C" for good reason - it's the fastest
    structured and (mostly) portable language.  JavaScript is quickly becoming the "C" language of the Internnet.
    SilkJS brings the speed of v8 compiled JavaScript and the "C" function calls to JavaScript.
  </div>
</div>
<div class="row">
  <div class="span6">
    <h2>In "C":</h2>
    <pre>
#include &lt;stdio.h\>

int main(int ac, char *av[]) {
	printf(\"hello, world\\n\");
}
    </pre>
  </div>
  <div class="span6">
    <h2>In SilkJS:</h2>
    <pre>
function main() {
  print(\"hello, world\\n\");
}
    </pre>
  </div>
</div>
<div class="row">
  <div class="span6">
    <pre>
#include &lt;stdio.h\>
#include &lt;unistd.h\>

int main(int ac, char *av[]) {
  if (fork()) {
    printf(\"main process\\n\");
  }
  else {
    printf(\"child process\\n\");
  }
}
    </pre>
  </div>
  <div class="span6">
    <pre>
fork = require('builtin/process').fork;

function main() {
  if (fork()) {
    print(\"main process\\n\");
  }
  else {
    print(\"child process\\n\");
  }
}
    </pre>
  </div>
</div>
"""

hr()

res.write """
<h1>License</h1>
<p>SilkJS is intended to be free for use by anyone and for any legal purpose.</p>

<p>To that end, please see this link:<br/>
<a target="_new" href="http://www.opensource.org/licenses/alphabetical">http://www.opensource.org/licenses/alphabetical</a></p>
<p>Pick whichever license you choose, as long as it is OSI approved.</p>
 """


include 'Footer.coffee'

