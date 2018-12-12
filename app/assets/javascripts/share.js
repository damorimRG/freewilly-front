$(document).ready(function() {
    $('#filtertxt').on('input', function() {
        var filter = $('#filtertxt').val();
        if (filter.length > 3) {
            var cards = $('.card .card-header');
            var titles = $('.card .card-body .card-title');
            for (var i = 0; i < cards.length; i++) {
                var text = cards[i].textContent;
                text += ' '+titles[i].textContent;
                if (text.toLowerCase().indexOf(filter.toLowerCase()) < 0) {
                    $(cards[i].parentElement).hide();
                } else {
                    $(cards[i].parentElement).show();
                }
            }
        } else {
            $('.card').show();
        }
    });
});