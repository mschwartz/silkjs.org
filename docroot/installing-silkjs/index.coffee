res.data.title = 'SilkJS - installing-silkjs'

include 'Header.sjs'

code = (s) ->
  "<p>$ <code>#{s}</code></p>"

url = (s) ->
  "<a href=\"#{s}\">#{s}</a>"

#res.write """
#<div class="row-fluid">
#<div class="span2">
#    <h1>Navigation</h1>
#    <ul class="nav">
#      <li><a href="#installing">Installing SilkJS</a></li>
#      <li><a href="#first">Before you start</a></li>
#      <li><a href="#ubuntu">Ubuntu Instructions</a></li>
#      <li><a href="#osx">OSX Instructions</a></li>
#    </ul>
#</div>
#<div class="span10">
#"""

res.write """

<header class="hero-unit">
  <h1>Installing SilkJS</h1>
  <p>SilkJS is currently available only via #{res.data.github} currently.  Intallation is a breeze, though!</p>
  <a href="https://github.com/mschwartz/SilkJS/" class="btn btn-primary btn-large">View project on GitHub</a>
  <a href="http://groups.google.com/group/SilkJS" class="btn btn-large">SilkJS Google Group</a>
</header>

"""

res.write """
<div class="tabbable">
  <ul id="tab" class="nav nav-tabs">
  <li class="active"><a href="#first" data-toggle="tab">Build Notes</a></li>
  <li><a href="#ubuntu" data-toggle="tab">Ubuntu Instructions</a></li>
  <li><a href="#osx" data-toggle="tab">OSX Instructions</a></li>
  <li><a href="#post-build" data-toggle="tab">Post Build Install</a></li>
  </ul>
  <div class="tab-content">
"""

res.write """

<div class="tab-pane fade in active" id="first">
  <h1>Build Notes</h1>
  <p>Currently SilkJS builds on Ubuntu/Linux and Mac OSX. Building for Ubuntu is rather straightforward, thanks to the apt package management system. Building for OSX is a bit more complicated as certain libraries SilkJS links against must also be built.</p>

  <p><em>NOTE: Some systems are configured for IPv6 in their /etc/hosts files (Mac OSX for one). To run the ab tests, you will need to use http://127.0.0.1:9090/(whatever) instead of http://localhost:9090/(whatever)</em></p>

  <p><em>These instructions are for building SilkJS in your ~/src directory (for both OSX and Ubuntu).  If
  you don't have a ~/src directory, you can create it from the comand line:</em><br/>
  #{code 'mkdir ~/src; cd ~/src'}</p>

  <p>If you have feedback on the build process or these instructions, please email me at #{res.data.contact} or post to the #{res.data.googleGroup}.</p>
</div>

"""

res.write """
<div class="tab-pane fade" id="ubuntu">
<h1>Ubuntu Instructions</h1>
<p>These instructions are for Ubuntu Oneiric, though they will work for other versions of Ubuntu as well. I like to build my C/C++ projects in my ~mschwartz/src directory. Feel free to adapt these instructions to suit your preferences.</p>

<h2>1. Install Prerequisites</h2>
<p>SilkJS compiles and links against several libraries that are trivial to install using the apt package manager.</p>
<p><em>After building and testing SilkJS, you might want to install it via the Install.js script.</em></p>

<p>First the essentials:</p>
#{code 'sudo apt-get install build-essential subversion git'}
<p>General purpose libraries:</p>
#{code 'sudo apt-get install libmm-dev libssl-dev libgd2-xpm-dev libncurses5-dev libcurl4-openssl-dev libssh2-1-dev'}
<p>Database interface libraries:</p>
#{code 'sudo apt-get install libmysqlclient-dev libsqlite3-dev libdb4.7-dev libmongo-client-dev libglib2.0-dev'}

<p>The apache2-util package installs the ab program, which can be used to benchmark SilkJS and other HTTP servers:</p>
#{code 'sudo apt-get install apache2-utils'}

<h2>2. Get SilkJS from GitHub</h2>
#{code 'mkdir src'}
#{code 'cd src'}
#{code 'git clone https://github.com/mschwartz/SilkJS.git SilkJS'}

<h2>3. Build and test</h2>
<p>SilkJS should now build:</p>

#{code 'cd SilkJS'}
#{code 'make'}

<p>To see it works:</p>

#{code './silkjs httpd/main.js'}
<i class="icon-arrow-right"></i>Point your browser at http://localhost:9090/
</div><!-- ubuntu tab -->

"""

res.write """

<div id="osx" class="tab-pane fade">
<h2>Mac OSX Instructions</h2>

<p>Building for OSX is much more complicated, and there may be some issues with the new gyp build system for v8
that prevent SilkJS from being built for OSX using gyp.</p>

<p>According to the gyp build instructions page (for v8):</p>
<blockquote>"trying to build x64 targets on Mac currently fails."</blockquote>

<p>That said...</p>

<h2>1. Install XCode</h2>
<p>Install Xcode from the App Store. It's free!</p>

<h2>2. Install SubVersion</h2>
<p>Install the command line binary version of SubVersion from this page:<br/>
#{url('http://www.wandisco.com/subversion/download#osx')}</p>
<p><em>Make sure to edit your ~/.profile to include this line at the end:<br/>
<code>export PATH=/opt/subversion/bin:$PATH</code><br/>
<i class="icon-arrow-right"></i> Close and open your shell window again.</em></p>

<h2>3. Install scons</h2>
<p>scons is a python based build system that is used to build/compile the v8 JavaScript engine.  It is being
depricated in favor of the gyp build system, but for now scons is the only way to build x64 (e.g. Lion) versions
of v8.</p>

<p>Download scons-2.1.0.tar.gz from #{url 'http://scons.org'} to your ~/src directory.  Then in your shell window:</p>
#{ code 'tar xzvfp scons-2.1.0.tar.gz'}
#{ code 'cd scons-2.1.0'}
#{ code 'sudo python setup.py install'}

<h2>4. Get SilkJS from GitHub</h2>
#{ code 'cd ~/src'}
#{ code 'git clone https://github.com/mschwartz/SilkJS.git SilkJS'}

<h2>5. Build and test</h2>
<p>SilkJS should now build:</p>

#{code 'cd SilkJS'}
#{code 'make'}

<p>To see it works:</p>

#{code './silkjs httpd/main.js'}
<p><i class="icon-arrow-right"></i>Point your browser at #{url '}http://localhost:9090/'}</p>
</div><!-- osx pane -->

"""

res.write """

<div class="tab-pane fade" id="post-build">
<h1>Post Build Installation of SilkJS</h1>
<p>Once built, installing SilkJS should be a simple and harmless process.  Feel free to examine the Install.js
script in the ~/src/SilkJS directory to understand what it will do.</p>
<p><em>OSX Note: DO NOT REMOVE THE ~src/SilkJS directory.  The build process created dynamic libraries
(mysql client, ncurses, etc.) in the SilkJS directory and the installed SilkJS binary needs to load these.</em></p>
<p>The thinking is that OSX is for development and we don't want to blow away or override any other versions
of those libraries you might have installed (e.g. using MacPorts or HomeBrew).</p>

<h2>Install.js</h2>
<p>Install.js creates a /usr/share/silkjs directory and copies some files there.  This
location is the default search path for SilkJS modules and include() files, as well as the default docroot
(config.documentRoot) for a local hosted copy of this documentation (silkjs.org site).  Additionally, it
will copy the httpd-silk.js script and other SilkJS command-line scripts to /usr/local/bin so they're on your
path.  <em>To uninstall SilkJS, you'll need to remove the /usr/share/silkjs directory and the files copied to
/usr/local/bin.</em></p>

<h2>Stopping SilkJS HTTP server</h2>
<p>You may have the HTTP server still running, since the last step of the build process was to run it and
test it in your browser.  To stop it, simply hit ^C (Control-C) and the HTTP server will exit.  <em>You must
stop the server before proceeding!</em></p>

<h2>Run the Install.js script</h2>
<p>If you've just successfully built SilkJS, you are likely still in your ~/src/SilkJS directory.  From
there, you can install SilkJS so it will be more fully integrated with your system:<br/>
#{code 'sudo ./silkjs Install.js'}</p>

<h2>Start the HTTP server and test</h2>
<p>In our terminal window, change directory to your home directory so you're sure to be using the
just-installed version of SilkJS.</p>
#{code 'cd'}
<p>Now start the server:</p>
#{code 'httpd-silk.js'}
<p><i class="icon-arrow-right"></i>Point your browser at #{url '}http://localhost:9090/'}</p>

<p><em>You know how to stop the server.</em></p>

<h2>Re-running Install.js</h2>
<p>If you modify any of the src/*.cpp files, lib/*.js files or modules/*.js files in the ~/src/SilkJS directory, you
may want to re-run the Install.js script.  This will install your changes to the appropriate places (/usr/share/silkjs).
<em>However, silkjs (or httpd-silk.js) must not be running when you run the Install.js script or the silkjs binary
cannot be copied over.</em></p>


<div>

"""

res.write '</div></div>'
include 'Footer.sjs'
