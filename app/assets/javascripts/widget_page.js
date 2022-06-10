// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery.flexslider
//= require jquery.scrollTo
//= require jquery.exists
//= require underscore
//= require my_chippd/audio_player


/*
  Gallery for widget
============================================================================= */
$('#gallery').flexslider({
  animation: "fade",
  slideDirection: "horizontal",
  slideshow: true,
  slideshowSpeed: 9000,
  animationDuration: 600,
  directionNav: false,
  touch: false,
  controlNav: true,
  keyboardNav: true,
  mousewheel: false,
  prevText: "Previous",
  nextText: "Next",
  pausePlay: false,
  pauseText: 'Pause',
  playText: 'Play',
  randomize: false,
  slideToStart: 0,
  animationLoop: true,
  start: function()
  {
    $('.flex-control-nav').delay(500).fadeIn(300);
  }
});


/*
  RSVP Form Handlers
============================================================================= */
var RSVP = {
  guestNum: 0,
  data: [
    { going: 'Yes', meal: null}
  ],
  mealChoiceHandler: function(e,index) {
    $(e.currentTarget).siblings().removeClass('selected');
    $(e.currentTarget).addClass('selected');
    RSVP.data[index].meal = $(e.currentTarget).text();
  },
  addGuestHandler: function(e) {
    e.preventDefault();
    if (!$(this).hasClass('inactive')) {
      var guestTemplate = _.template($('#guestTemplate').html(), {num: ++RSVP.guestNum});
      RSVP.data.push({ going: 'Yes', meal:null });
      RSVP.guests.append(guestTemplate);
      RSVP.bindMealChoices();
    }
  },
  saveHandler: function(e) {
    e.preventDefault();
    var tpl;
    if (RSVP.data[0].going == 'No') {
      tpl = _.template($('#sorry').html(), {data: RSVP.data});
    } else {
      // Get the guests
      var guests = RSVP.guests.find('input[type="text"]');
      if (guests.length > 0) {
        for (var i = 0; i < guests.length; i++) {
          RSVP.data[i+1].name = $(guests[i]).val();
        }
      }
      tpl = _.template($('#cantWait').html(), {num:guests.length, data:RSVP.data});
    }
    $('#rsvpForm').hide();
    $('#thankyou').html(tpl).show();
    $('#edit').on('click', function(e) {
      e.preventDefault();
      $('#rsvpForm').show();
      $(this).parent().html('').hide();
    });
    $.scrollTo('#thankyou');
    console.log(RSVP.data);
  },
  rsvpHandler: function(e) {
    e.preventDefault();
    switch ($(this).attr('id')) {
      case 'yes':
        $('#no').addClass('inactive');
        $('#no').removeClass('active');
        $(this).removeClass('inactive').addClass('active');
        RSVP.data[0].going = "Yes";
        $('.mealChoice').show();
        $('#addGuest').removeClass('inactive');
        break;
      case 'no':
        $('#yes').addClass('inactive');
        $('#yes').removeClass('active');
        $(this).removeClass('inactive').addClass('active');
        RSVP.data[0].going = "No";
        $('.mealChoice').hide();
        $('#addGuest').addClass('inactive');
        break;
    }
  },
  bindMealChoices: function() {
    this.mealChoice = $('.mealChoice');
    this.mealChoice.each(function(i) {
      $(this).find('.radio').on('click', function(e) {
        e.stopPropagation();
        e.preventDefault();
        RSVP.mealChoiceHandler(e,i);
      });
    });
  },
  init: function() {
    // Meal Choice Buttons
    this.bindMealChoices();
    // Guest Handler
    this.guests = $('#guests');
    $('#addGuest').on('click', this.addGuestHandler);
    // RSVP Buttons
    $('#yes').on('click', this.rsvpHandler);
    $('#no').on('click', this.rsvpHandler);
    // Save
    $('#save').on('click', this.saveHandler);
  }
}
RSVP.init();