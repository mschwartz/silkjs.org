res.write """

<!-- Footerx
 ================================================== -->
 <footer class="footer">
   <p class="pull-right"><a href="#">Back to top</a></p>
   <p>Designed and built by Michael Schwartz using SilkJS, CoffeeScript, and Bootstrap from Twitter.</p>
"""


res.write """
     <p>Served by SilkJS HTTP server.  Requested URI was <code>#{req.uri}</code></p>
 </footer>

</div><!-- /container -->

<!-- Le javascript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/app.js"></script>

  </body>
</html>
"""
