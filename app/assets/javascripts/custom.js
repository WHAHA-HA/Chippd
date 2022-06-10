// Expand Longpage Nav
$('#longpage-nav .collapsed').click(function () {
    $('#longpage-nav').addClass("active");
});

// Collapse Longpage Nav
$('#longpage-nav .expanded .collapse').click(function () {
    $("#longpage-nav").removeClass("active");
});

// Collapse Longpage Nav
$('#longpage-nav .expanded a').click(function () {
    $("#longpage-nav").removeClass("active");
});

// Make Longpage Nav Stick to Top on Scroll
var s = $("#longpage-nav-container");
var m = $(".wrapper");
if (s.exists() && m.exists()) {
    var pos = s.position();
    $(window).scroll(function() {
        var windowpos = $(window).scrollTop();
        if (windowpos >= pos.top - 24) {
            s.addClass("stick");
            m.css("margin-top","112px");
        } else {
            s.removeClass("stick");
            m.css("margin-top","112px");
        }
    });
}

// If Longpage Nav exists Add margin-top to wrapper
if ($('#longpage-nav-container').exists()) {
    $('.wrapper').css("margin-top","112px");
}

// Initialize slider
$(".rslides").responsiveSlides({
  auto: true,             // Boolean: Animate automatically, true or false
  speed: 800,            // Integer: Speed of the transition, in milliseconds
  timeout: 4000,          // Integer: Time between slide transitions, in milliseconds
  pager: true,           // Boolean: Show pager, true or false
  nav: false,             // Boolean: Show navigation, true or false
  random: false,          // Boolean: Randomize the order of the slides, true or false
  pause: false,           // Boolean: Pause on hover, true or false
  pauseControls: true,    // Boolean: Pause when hovering controls, true or false
  prevText: "Previous",   // String: Text for the "previous" button
  nextText: "Next",       // String: Text for the "next" button
  maxwidth: "",           // Integer: Max-width of the slideshow, in pixels
  navContainer: "",       // Selector: Where controls should be appended to, default is after the 'ul'
  manualControls: "",     // Selector: Declare custom pager navigation
  namespace: "rslides",   // String: Change the default namespace used
  before: function(){},   // Function: Before callback
  after: function(){}     // Function: After callback
});

// Add Label Class for Custom Radio Buttons
$('#chipp-form label').each(function () {
    $(this).addClass("custom");
});


// On Load
$(document).ready( function(){
    // Hide Wrapper until page has fully loaded
    $('.wrapper').fadeIn(1000);
    // Trigger Datepicker menu when input is clicked
    $(".input-append").click(function() {
      $( this ).children( '.add-on' ).click();
    });
});




