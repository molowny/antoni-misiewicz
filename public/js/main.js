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

    if ($('#contact').size() > 0) {

        $('#contact').submit(function (e) {
            $('.msg').addClass('hidden')
            $('.spinner').removeClass('hidden');

            $.ajax('/kontakt', {
                type: 'post',

                data: {
                    name: $('#name').val(),
                    email: $('#email').val(),
                    message: $('#message').val()
                },

                error: function () {
                    $('.spinner').addClass('hidden');
                    $('.error').removeClass('hidden');
                },

                success: function () {
                    $('.spinner').addClass('hidden');
                    $('.ok').removeClass('hidden');
                }
            });

            e.preventDefault();
        });

        $('.spinner').spin('small');
    }

});
