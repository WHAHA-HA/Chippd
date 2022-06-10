//= require soundmanager2
//= require page-player

soundManager.useFlashBlock = true;
soundManager.url = '/flash/';
soundManager.debugMode = false;

if ($('ul.playlist').exists()) {
  soundManager.onready(function() {
    pagePlayer = new PagePlayer();
    pagePlayer.init(typeof PP_CONFIG !== 'undefined' ? PP_CONFIG : null);
  });
}
