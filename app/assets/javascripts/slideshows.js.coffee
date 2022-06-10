$(document).ready ->
  $('#deck .overlay').delay(500).fadeIn(300)

  $('#featured').flexslider
    animation: "fade"
    slideDirection: "horizontal"
    slideshow: true
    slideshowSpeed: 9000
    animationDuration: 600
    directionNav: false
    touch: false
    controlNav: true
    keyboardNav: true
    mousewheel: false
    prevText: "Previous"
    nextText: "Next"
    pausePlay: false
    pauseText: 'Pause'
    playText: 'Play'
    randomize: false
    slideToStart: 0
    animationLoop: true
    start: ->
      $('.flex-control-nav').delay(500).fadeIn(300)

  $('#product').flexslider
    animation: "fade"
    slideDirection: "horizontal"
    slideshow: false
    slideshowSpeed: 5000
    animationDuration: 600
    directionNav: false
    touch: false
    controlNav: true
    keyboardNav: false
    mousewheel: false
    prevText: "Previous"
    nextText: "Next"
    pausePlay: false
    pauseText: 'Pause'
    playText: 'Play'
    randomize: false
    manualControls: "#thumbnail-nav li"
    slideToStart: 0
    animationLoop: true
