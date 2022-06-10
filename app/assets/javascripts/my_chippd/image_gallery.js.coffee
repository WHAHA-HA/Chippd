//= require photoswipe

jQuery ->
  if $(".gallery-images a").exists()
    $(".gallery-images").each ->
      photos = $(this).find("a")
      myPhotoSwipe = photos.photoSwipe({ enableMouseWheel: false , enableKeyboard: true , captionAndToolbarShowEmptyCaptions: false })
