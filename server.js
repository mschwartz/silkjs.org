/**
 * Created by JetBrains WebStorm.
 * User: mschwartz
 * Date: 3/25/12
 * Time: 9:30 AM
 */
Config.documentRoot = 'docroot';

include.path.push('templates');

print = res.write;
println = res.writeln;

function hr() {
    println('<hr class="soften">');
}

