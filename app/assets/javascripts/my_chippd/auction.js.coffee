jQuery ->

  $('input[type=radio][name="section[media_type]"]').change ->

    if @value == 'photo'
      $('#auction_video').hide()
      $('#auction_photo').show()

    if @value == 'video'
      $('#auction_video').show()
      $('#auction_photo').hide()
