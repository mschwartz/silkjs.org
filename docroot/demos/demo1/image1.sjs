var cairo = require('builtin/cairo'),
    fs = require('fs'),
    uuid = require('phpjs').uuid;

var surface = cairo.image_surface_create(cairo.FORMAT_ARGB32, 120, 120);
var context = cairo.context_create(surface);
cairo.context_scale (context, 120, 120);

var radpat = cairo.pattern_create_radial (0.25, 0.25, 0.1,  0.5, 0.5, 0.5);
cairo.pattern_add_color_stop_rgb (radpat, 0,  1.0, 0.8, 0.8);
cairo.pattern_add_color_stop_rgb (radpat, 1,  0.9, 0.0, 0.0);

for (var i=1; i<10; i++) {
    for (var j=1; j<10; j++) {
        cairo.context_rectangle (context, i/10.0 - 0.04, j/10.0 - 0.04, 0.08, 0.08);
    }
}
cairo.context_set_source (context, radpat);
cairo.context_fill (context);

var linpat = cairo.pattern_create_linear (0.25, 0.35, 0.75, 0.65);
cairo.pattern_add_color_stop_rgba (linpat, 0.00,  1, 1, 1, 0);
cairo.pattern_add_color_stop_rgba (linpat, 0.25,  0, 1, 0, 0.5);
cairo.pattern_add_color_stop_rgba (linpat, 0.50,  1, 1, 1, 0);
cairo.pattern_add_color_stop_rgba (linpat, 0.75,  0, 0, 1, 0.5);
cairo.pattern_add_color_stop_rgba (linpat, 1.00,  1, 1, 1, 0);

cairo.context_rectangle (context, 0.0, 0.0, 1, 1);
cairo.context_set_source (context, linpat);
cairo.context_fill (context);

var filename = '/tmp/' + uuid() + '.png';
cairo.context_destroy(context);
cairo.surface_write_to_png(surface, filename);
cairo.surface_destroy(surface);
res.contentType = 'image/png';
res.sendFile(filename);
fs.unlink(filename);
res.stop();
