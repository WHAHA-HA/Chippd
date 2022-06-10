jQuery ->

  # GENERAL FORM UI
  # ------------------------------------------------

  # RADIOS
  $("input[type=radio]:checked").parents(".radio").addClass("selected")

  $("body").delegate "input[type=radio]", "click", ->
    el = $(this)
    thisName = el.attr("name")
    $("input[name='"+thisName+"']").parents(".radio").removeClass("selected")
    el.parents(".radio").addClass("selected")



  # CHARACTER COUNTERS
  # ------------------------------------------------
  # GET INPUTS WITH MAXLENGTH ATTRIBUTES/VALUES
  $("[maxlength]").each ->
    el = $(this)
    charCurrent = el.val().length
    charMax = parseInt(el.attr("maxlength"))
    charRemaining = charMax - charCurrent
    el.parents(".controls").addClass("with-char-count").prepend("<span class='control__char-count'>"+charRemaining+"</span>")

  $("[maxlength]").on "focus", ->
    el = $(this)
    el.siblings(".control__char-count").addClass("is-visible")

  $("[maxlength]").on "blur", ->
    el = $(this)
    el.siblings(".control__char-count").removeClass("is-visible")

  $("[maxlength]").on "keyup", ->
    el = $(this)
    charCurrent = el.val().length
    charMax = parseInt(el.attr("maxlength"))
    charRemaining = charMax - charCurrent
    el.siblings(".control__char-count").text(charRemaining)



  # FORM VALIDATION
  # ------------------------------------------------
  # OVERRIDE THE PLUGIN TO REDEFINE DEFAULT MESSAGES
  $.extend $.validator.messages,
    required: "Don't forget this."


  # APPLY PLUGIN TO ALL FORMS
  $('form').validate
    onfocusout: (e)->
      this.element(e)
    ,onkeyup: false



  # PREVENT FILE UPLOAD IF REQUIRED TEXT IS STILL EMPTY
  # ------------------------------------------------
  $("form").submit ->
    $(this).find("input.required:visible").each ->
      if $.trim($(this).val()) == ""
        return false



  # VALIDATE SOCIAL URLS
  # ------------------------------------------------
  validateSocialURL = (el)->
    thisInput = el
    if thisInput.val().length and thisInput.val().indexOf(thisInput.data("base_url")) < 0
      thisInput.removeClass("valid").addClass("base_url_error").siblings(".base_url_message").show()
    else
      thisInput.addClass("valid").removeClass("base_url_error").siblings(".base_url_message").hide()

  # ADD ERROR MESSAGE
  $("input[data-base_url]").each ->
    thisInput = $(this)
    thisInput.after "<label class='base_url_message error' style='display:none;'>URL must contain "+$(this).data("base_url")+"</label>"
    thisInput.parents("form").addClass "require-1"
    validateSocialURL(thisInput)

  # MAKE SURE THEY CONTAIN RELATED BASE URL
  $("input[data-base_url]").on "keyup", ->
    validateSocialURL($(this))

  # MAKE SURE INPUTS ARE NOT EMPTY ON SUBMIT
  $("form.require-1").on "submit", (e)->
    isValid = false
    thisForm = $(this)
    thisForm.find("input[data-base_url]").each ->
      validateSocialURL($(this))
      if $(this).val().length > 0
        isValid = true
    if isValid == false
      alert "Please enter at least one URL"
      e.preventDefault()
    if thisForm.find(".base_url_error").length
      e.preventDefault()



  # REQUIRE INPUTS TO ACCEPT PROPER FILE TYPES IF NO FILEREADER
  # ------------------------------------------------
  # .no-filereader inputs will be hidden with css and then shown when dom is ready
  $(".no-filereader input[type='file']").show()

  $(".no-filereader input[type='file']").on "change", (e)->
    $this = $(this)
    acceptedType = $this.attr("accept")
    ext = $this.val().split('.').pop().toLowerCase()

    if acceptedType.indexOf('image') > -1
      if $.inArray(ext, ['gif','png','jpg','jpeg']) == -1
        alert 'Sorry, that file won\'t work. You must select an image to upload (.gif, .png, .jpg, or .jpeg).'
        # Since ie8+ inputs are read-only must clone and replace
        $this.replaceWith($this.clone(true))

    if acceptedType.indexOf('video') > -1
      if $.inArray(ext, ['mov', 'mp4', 'm4v', 'ogg', 'wmv']) == -1
        alert 'Sorry, that file won\'t work. You must select a video to upload (.mov, .mp4, .m4v, .ogg or .wmv)'
        # Since ie8+ inputs are read-only must clone and replace
        $this.replaceWith($this.clone(true))

    if acceptedType.indexOf('mp3') > -1
      if $.inArray(ext, ['mp3']) == -1
        alert 'Sorry, that file won\'t work. You must select an mp3 to upload.'
        # Since ie8+ inputs are read-only must clone and replace
        $this.replaceWith($this.clone(true))

    if acceptedType.indexOf('pdf') > -1
      if $.inArray(ext, ['pdf']) == -1
        alert 'Sorry, that file won\'t work. You must select a pdf to upload.'
        # Since ie8+ inputs are read-only must clone and replace
        $this.replaceWith($this.clone(true))



  $('#chipp-form').on 'focus', 'input.url[data-base_url]', (event)->
    console.log 'focused'
    event.stopPropagation()
    el = $(this)
    if _.isEmpty(el.val())
      el.val(['http://',el.data('base_url'),'/'].join(''))

  $('#chipp-form').on 'blur', 'input.url[data-base_url]', (event)->
    console.log 'blured'
    event.stopPropagation()
    el = $(this)
    if el.val() == ['http://',el.data('base_url'),'/'].join('')
      el.val('')

  $('#chipp-form').on 'focus', 'input.url', ->
    el = $(this)
    if _.isEmpty(el.val())
      el.val('http://')

  $('#chipp-form').on 'blur', 'input.url', ->
    el = $(this)
    if el.val() == 'http://'
      el.val('')
