$(function() {

	$(window).resize(function() {

		var a = $('.timeline-wraper').width();
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

    function slider(){
        var options = {
            nextButton: false,
            prevButton: false,
            animateStartingFrameIn: true,
            autoPlayDelay: 3000,
            preloader: true,
            pauseOnHover: false,
            preloadTheseFrames: [1],
            preloadTheseImages: [
                "/img/slide1.png",
                "/img/slide2.png",
                "/img/slide3.png",
                "/img/slide4.png",
                "/img/slide5.png"
            ]
        };
        
        var sequence = $("#sequence").sequence(options).data("sequence");

    }

    slider();

});
