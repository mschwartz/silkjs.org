Config.documentRoot = 'docroot';

include.path.push('templates');

hr = () ->
  res.write '<hr class="soften">'

print = res.write
println = res.writeln
