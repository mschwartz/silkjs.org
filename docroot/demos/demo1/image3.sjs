var cairo = require('builtin/cairo'),
    fs = require('fs'),
    uuid = require('phpjs').uuid;

var surface = cairo.image_surface_create (cairo.FORMAT_ARGB32, 120, 120);
var context = cairo.context_create (surface);
/* Examples are in 1.0 x 1.0 coordinate space */
cairo.context_scale (context, 120, 120);

/* Drawing code goes here */
cairo.context_set_source_rgb (context, 0, 0, 0);
cairo.context_move_to (context, 0, 0);
cairo.context_line_to (context, 1, 1);
cairo.context_move_to (context, 1, 0);
cairo.context_line_to (context, 0, 1);
cairo.context_set_line_width (context, 0.2);
cairo.context_stroke (context);

cairo.context_rectangle (context, 0, 0, 0.5, 0.5);
cairo.context_set_source_rgba (context, 1, 0, 0, 0.80);
cairo.context_fill (context);

cairo.context_rectangle (context, 0, 0.5, 0.5, 0.5);
cairo.context_set_source_rgba (context, 0, 1, 0, 0.60);
cairo.context_fill (context);

cairo.context_rectangle (context, 0.5, 0, 0.5, 0.5);
cairo.context_set_source_rgba (context, 0, 0, 1, 0.40);
cairo.context_fill (context);

var filename = '/tmp/' + uuid() + '.png';
cairo.context_destroy(context);
cairo.surface_write_to_png(surface, filename);
cairo.surface_destroy(surface);
res.contentType = 'image/png';
res.sendFile(filename);
fs.unlink(filename);
res.stop();
