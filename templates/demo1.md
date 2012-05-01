# Demo 1 - Cairo Images

This demo consists of this dynamically rendered GitHub flavored Markdown page and 3 images.

Doesn't seem so special?

The images are rendered on the fly using SilkJS' libcairo interface.  The HTML, other static elements of the page, and the images are all being served by SilkJS in parallel.

There's no async anything going on here.  SilkJS simply runs the code to render the images from top-to-bottom, left-to-right as fast as it can, in parallel.  All that was done was to create the image1.sjs, image2.sjs, and image3.sjs files in the HTTP server's documentRoot and generate img tags in the source to this page to those programs.

<table align="left" border="1"><tr><td><img src="image1.sjs" /></td></tr><tr><td align="center">img src="image1.sjs"</td></tr></table>
<table align="left" border="1"><tr><td><img src="image2.sjs" /></td></tr><tr><td align="center">img src="image2.sjs"</td></tr></table>
<table align="left" border="1"><tr><td><img src="image3.sjs" /></td></tr><tr><td align="center">img src="image3.sjs"</td></tr></table><br clear="all"/>

Inspect the source code for yourself below.  You can see the images are dynamically generated, saved to disk, served from disk, then deleted from disk, every request.  BLOCKING.

The source code for the 3 image generation programs follows.

