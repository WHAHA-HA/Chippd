jQuery ->

  $('input[type=radio][name="section[media_type]"]').change ->

    if @value == 'photo'
      $('#babys_first_video').hide()
      $('#babys_first_photo').show()

    if @value == 'video'
      $('#babys_first_video').show()
      $('#babys_first_photo').hide()
