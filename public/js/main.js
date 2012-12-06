$(function() {

	$(window).resize(function() {

		var a = $('.timeline').width();
		$('.pointer').css('left', a/2);
		$('.item:nth-child(2n) .pointer').css({
			'left' : 'auto',
			'right' : a/2
		});

	}).resize();


    $('body').click(function() {
        if ($('#language .drop').hasClass('active')) {
            $('#language .drop').removeClass('active').fadeOut();
        }
    });

    $('#language').click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        $('#language .drop').stop(true, true).addClass('active').fadeToggle('fast');
    });

    $('#language .drop').click(function(e) {
        e.stopPropagation();
    });

});
