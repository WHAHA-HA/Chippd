/**
 * Called once a vimeo player is loaded and ready to receive
 * commands. You can add events and make api calls only after this
 * function has been called.
 *
 * @param String $player_id — id of the iframe element firing the event. This is
 * useful when listening to multiple videos so you can identify which one fired
 * the event.
 *
 * This script depends on Vimeo's Froogaloop, Twitter Bootstrap and jQuery
 *
 */
function ready(player_id) {
  // Keep a reference to Froogaloop for this player
  var player = $f(player_id);
  // If you hide modal, pause the video
  $('#promoVideo').on('hidden', function () {
    player.api('pause');
  });
}

// Listens for the message event.
// W3C
if (window.addEventListener) {
  window.addEventListener('load', function() {
    //Attach the ready event to the iframe
    $f(document.getElementById('chippd-video-player')).addEvent('ready', ready);
  });
}
// IE
else {
  window.attachEvent('load', function() {
    //Attach the ready event to the iframe
    $f(document.getElementById('chippd-video-player')).addEvent('ready', ready);
  });
}