/*global req, res, include */

"use strict";

res.data.title = 'SilkJS - Contact Us';

include('Header.sjs');

println('<div class="row">');
println('<div class="span8">');
println('<div class="page-header"><h1>Contact Us</h1></div>');
println('<p>Choose a method:</p>');
println('<ul>');
println('<li><a target="_new" href="mailto:mykesx@gmail.com">Michael Schwartz By Email</a></li>');
println('<li><a target="_new" href="https://groups.google.com/group/silkjs">The SilkJS Google Group</a></li>');
println('<li><a target="_new" href="https://github.com/mschwartz/SilkJS/issues">Post an Issue at GitHub</a></li>');
println('</ul>');
println('</div>');
println('</div>');

include('Footer.sjs');
