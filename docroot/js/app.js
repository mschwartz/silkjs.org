!function ($) {

    $(function(){
        // Disable certain links in documentation
        $('section [href^=#]').click(function (e) {
            e.preventDefault()
        })
        $('.nav-collapse').on('show', function() {
            $('#gitLink').hide();
	});
        $('.nav-collapse').on('hide', function() {
            $('#gitLink').show();
        });
        // make code pretty
        window.prettyPrint && prettyPrint()

        // fix sub nav on scroll
        var $win = $(window)
            , $nav = $('.subnav')
            , navTop = $('.subnav').length && $('.subnav').offset().top - 40
            , isFixed = 0

        processScroll()

        $win.on('scroll', processScroll)

        function processScroll() {
            var i, scrollTop = $win.scrollTop()
            if (scrollTop >= navTop && !isFixed) {
                isFixed = 1
                $nav.addClass('subnav-fixed')
            } else if (scrollTop <= navTop && isFixed) {
                isFixed = 0
                $nav.removeClass('subnav-fixed')
            }
        }

    });

}(window.jQuery)
