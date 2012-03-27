/**
 * Created by JetBrains WebStorm.
 * User: mschwartz
 * Date: 3/25/12
 * Time: 9:30 AM
 */
Config.extend({
  documentRoot: 'docroot',
  numChildren: 25
});
var fs = require('fs');
if (fs.exists('httpd-conf.js')) {
  include('httpd-conf.js');
}

include.path.push('templates');

print = res.write;
println = res.writeln;

function hr() {
    println('<hr class="soften">');
}

