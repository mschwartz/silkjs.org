res.data.title = 'SilkJS - Getting Started'

include 'Header.coffee'

code = (s) ->
  "<p>$ <code>#{s}</code></p>"

res.write """
<h1>Getting Started</h1>

<p><em>This guide assumes you have already installed SilkJS.</em></p>

<p>The Install.js script created (or updated) 3 files in /usr/local/bin; /usr/local/bin should be on your path.
The three files are httpd-silk.js, silkjs, and systat.js.  The systat.js program only works on Linux systems.</p>

<h2>Scripting with SilkJS</h2>

<p>All of the programs in this guide can be found in your SilkJS/walkthrough/scripting directory.  You will want
to cd there in your terminal program to follow along.</p>

<p>SilkJS is a Unix command-line tool that loads and runs the first JavaScript file on the command line.  For example:</p>
#{code('silkjs hello.js')}
<p>runs /usr/local/bin/silkjs and loads and runs the hello.js script in the current directory.  Let's
try it out by creating a hello.js file with the following contents:</p>
<pre>
print('hello, world\\n');
</pre>
<p>We run the program and we see:</p>
<pre>
$ silkjs hello.js
hello, world
$
</pre>
<p>If you provide a main() function in your script, the script will be loaded, compiled, run, and then the main function called.
Let's modify our hello.js program so it reads (hello2.js).  We're using the default println() function which writes
a string to stdout, adding a newline:</p>
<pre>
function main() {
  println('hello, world');
}
</pre>
<p>We run the program and see:</p>
<pre>
$ silkjs hello.js
hello, world
$
</pre>
<p>The upshot of this behavior is that you can use the load/compile/run phase to load up your API libraries and
then your main() function will be the entry point to your program.</p>

<h3>Builtin functionality</h3>
<p>SilkJS comes with a decent set of builtin functionality, accessed via the global builtin namespace.  This builti
 functionality includes access to the console, file system, networking, processes, and libraries like ncurses, gd2,
 and mysql.  The builtin.console module provides console.log() and console.error() methods.  We can see how to access
 these with the following program, console.js:</p>
<pre>
var console = builtin.console;

function main() {
  console.log('hello, world');
}
</pre>
<p>We run the program and see:</p>
<pre>
$ silkjs console.js
hello, world
$
</pre>

<p>A very useful builtin is print_r.  This is a function that dumps an arbitrary JavaScript variable, be it an object or
array etc, and formats it as a string.  We can see it in action with print_r.js:

<pre>
var o = {
	key1: 'value1',
	key2: 'value2',
	key3: [ 1,2,3],
	key4: { a: '1', b: 2, c: 3 }
};

var print_r = builtin.print_r;

function main() {
	println(print_r(o));
}
</pre>

When we run it, we see:
<pre>
$ silkjs print_r.js
(object) :
 [key1] : (string) value1
 [key2] : (string) value2
 [key3] : (array) :
   [0] : (number) 1
   [1] : (number) 2
   [2] : (number) 3
 [key4] : (object) :
   [a] : (string) 1
   [b] : (number) 2
   [c] : (number) 3
</pre>

<p>SilkJS extends the default JavaScript Object prototype to add a dump() method:</p>
<pre>
// dump.js
var o = {
	key1: 'value1',
	key2: 'value2',
	key3: [ 1,2,3],
	key4: { a: '1', b: 2, c: 3 }
};

function main() {
	o.dump();
}
</pre>
When we run it, we see:
<pre>
$ silkjs dump.js
(object) :
 [key1] : (string) value1
 [key2] : (string) value2
 [key3] : (array) :
   [0] : (number) 1
   [1] : (number) 2
   [2] : (number) 3
 [key4] : (object) :
   [a] : (string) 1
   [b] : (number) 2
   [c] : (number) 3
</pre>
<h3>Shebang!</h3>
<p>Shebang is a Unix term for the first line of shell scripts.  These lines look something like #!/path/to/shell.
  SilkJS supports shebang, too.  For example, let's look at shebang.js:</p>
<pre>
#!/usr/local/bin/silkjs

function main() {
	arguments.dump();
}
</pre>
<p>Notice the shebang on the first line?  If we chmod the file to turn on the 'X' bit, it will execute like
  any other shell script or Unix command:</p>
#{code('chmod 700 shebang.js')}
<p>Now we can run it directly:</p>
<pre>
$ ./shebang.js a b c
(array) :
 [0] : (string) a
 [1] : (string) b
 [2] : (string) c
</pre>
<p>We didn't have to invoke silkjs (/usr/local/bin/silkjs) directly, the shebang line took care of it for us.
Another thing to note is that the additional command line arguments to our shebang.js script were passed to our main()
function as the arguments array.  This means our main() function can take arguments.  Consider shebang2.js:</p>
<pre>
#!/usr/local/bin/silkjs

function main(name) {
	if (!name) {
		println('Usage: ./shebang2.js name');
		println('name is required!');
	}
	else {
		println('Hi there, ' + name + '.');
	}
}
</pre>
<p>Run it twice, first time without an argument, second time with:</p>
<pre>
$ ./shebang2.js
Usage: ./shebang2.js name
name is required!
$ ./shebang2.js Mike
Hi there, Mike.
</pre>

<h3>Loading scripts: include() vs. require()</h3>
<p>The examples so far have only involved a single script.  Now let's explore how we can load additional
scripts and call the functions provided by those.  SilkJS features both include() and require() for loading
scripts.</p>

<h4>include()</h4>
<p>There is a builtin.include() method that is overloaded by the include() implementation in JavaScript
in the builtin/include.js file in the SilkJS sources.  The include() function will load, compile, and run
a file from the file system.  <em>This happens each time you include() the same file, even.</em></p>

<p>To illustrate include() functionality, there are two files involved in the next example.  First is
test.inc.js:</p>
<pre>
println('including test.inc.js');

function included_function() {
	println('included');
}
</pre>
<p>And include_test.js:</p>
<pre>
include('test.inc.js');
include('test.inc.js');

function main() {
	included_function();
}
</pre>
<p>Notice we include test.inc.js twice.  Let's see what happens when we run it:</p>
<pre>
$ silkjs ./include_test.js
including test.inc.js
including test.inc.js
included
</pre>

<p>The include() function acts very much like &lt;script> tags do in client side JavaScript.</p>

<p>Another interesting aspect of include() is that it will see a .coffee extension on a file and compile
CoffeeScript to JavaScript before running it.  To illustrate this functionality, we'll use two files,
test.coffee and coffee-test.js:</p>
<pre>
$ cat test.coffee
coffee = ->
  println 'hello, world from CoffeeScript'

$ cat coffee-test.js
include('test.coffee');

function main() {
	coffee();
}

$ silkjs coffee-test.js
hello, world from CoffeeScript
</pre>
<p>The only restriction on usig CoffeeScript files is that the main program must be JavaScript.</p>
<p>The include() function searches for files to load using the include.paths array, which is initally
populated with reasonable values.  Feel free to manipulate this array to set the paths to your liking.</p>
<pre>
$ cat include.paths.js
println('These paths are searched in order:');
include.path.dump();
$ silkjs include.paths.js
These paths are searched in order:
(array) :
 [0] : (string) ./
 [1] : (string) ./coffeescript
 [2] : (string) /usr/share/silkjs
 [3] : (string) /usr/share/silkjs/coffeescript
</pre>

<h4>require()</h4>

<p>An alternate means of loading your API into SilkJS is the require() function.  SilkJS implements the
CommonJS Require/1.1 specification.  The require() function differs from include() in a few key ways.</p>

<p>First, the file is loaded and compiled and run in a sort of sandbox.  The modules you require() may not
modify any global variables.</p>
<pre>
$ cat test1.mod.js
println('test1.mod.js');

foo = 10;	// this is illegal!

$ cat rtest1.js
var x = require('test1.mod.js');

$ silkjs ./rtest1.js
test1.mod.js
~/src/SilkJS/walkthrough/scripting/test1.mod.js:10: ReferenceError: foo is not defined
foo = 10;	// this is illegal!
    ^
no stack trace available
</pre>

<p>Second, there is a predefined "exports" variable in module code.  The module code sets the properties
of exports to whatever it wants to make available to the code that calls require().</p>
<pre>
$ cat test2.mod.js
println('loading module test2.mod.js');

function a() {
	println('a');
}

// will not be available to caller of require()
function b() {
	println('private b');
}

function c() {
	b();	// is available privately to me
	println('c');
}

// export these
exports.a = a;
exports.c = c;

$ cat rtest2.js
var mod = require('test2.mod.js');

mod.dump();

var c = require('test2.mod.js').c;
c.dump();

c();


$ silkjs rtest2.js
loading module test2.mod.js
(object) :
 [a] : function a() {
	println('a');
}
 [c] : function() { ... }

function() { ... }

private b
c
</pre>
<p>As you can see, the same exports object was returned by require() both times, since the loading message
was only printed once.  Calling the c() function proves it could call the private b() function.</p>

<p>Third, require() has a concept of current directory when a module requires another module.  Consider
the following folder structure for a module:</p>
<ul>
  <li>MyModule</li>
  <ul>
    <li>module.js</li>
    <li>lib/</li>
    <ul>
      <li>lib/submodule.js</li>
    </ul>
  </ul>
</ul>

<p>If you require('MyModule/module'), and module.js does require('lib/submodule.js'), it does the right thing.</p>

<p>Fourth, the SilkJS require() implementation does a special case for modules named "builitin/something" - if there
is a global.builtin.something, that builtin (C++, native) module is loaded.  <em>This is the preferred way
to access the global.builtin namespace!</em>.</p>

<p><strong>If a module's file is modified on disk, it will be reloaded and compiled the next time require() is
called for it.</strong></p>

<h4>include() vs. require()</h4>
<p>There is a place for both methods of loading scripts into your application.</p>

<p>You may find libraries of code that are usable in SilkJS that are not written as modules; include() is suitable
for those libraries.  This site is written in CoffeeScript as dynamic pages.  The header, footer, navigation, etc.,
are implemented as files loaded with include().</p>

<p>On the other hand, require() allows for entire modules to be implemented as their own subdirectory
heirarchy and allows you to limit the scope of the Objects that are imported.</p>

<h2>Conclusion</h2>
<p>SilkJS provides a number of modules and include-style libraries that you can use to build useful
command-line applications.  These same modules are available in the HTTP context, so your tools and HTTP
applications can literally share the same APIs. Scripting with SilkJS is quite powerful; you can:</p>
<ul>
<li>Recurse through a directory adding watermarks to all images, using the gd module.</li>
<li>Implement a long-running data import tool that loads up a MySQL database.</li>
<li>Combine a bunch of JavaScript files into one file, minfied using Uglify-JS.</li>
<li>Compile Less CSS files into CSS files.</li>
<li>Etc.</li>
</ul>

<p>If you've installed SilkJS on a Linux server, you might try out the /usr/local/bin/systat.js program to
see that it's quite possible to implement full-blown ncurses based console UI applications.</p>

<p>Now that you've read about how SilkJS works, you might want to check out the HTTP server documentation.</p>

"""


include 'Footer.coffee'

