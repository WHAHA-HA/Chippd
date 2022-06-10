jQuery ->
  resetCollectionNumbers = ->
    $('form').each (index) ->
      $form = $(this)
      collectionNumbers = $('.nested-fields:visible .collection-number', $form)
      collectionNumbers.each ->
        el = $(this)
        item_number = _.indexOf(collectionNumbers, this) + 1
        el.html(item_number)

  showOrHideRemoveFieldsLinks = ->
    $('form').each (index) ->
      $form = $(this)
      minimum_fields = $('div[data-min]', $form).data 'min'
      if minimum_fields < $(".repeatable-field:visible", $form).length
        $('.remove_fields', $form).show()
      else
        $('.remove_fields', $form).hide()

  showOrHideAddFieldsLinks = ->
    $('form').each (index) ->
      $form = $(this)
      maximum_fields = $('div[data-max]', $form).data 'max'
      if maximum_fields
        if $(".repeatable-field:visible", $form).length < maximum_fields
          $('[data-behavior~=collection-add]', $form).show()
        else
          $('[data-behavior~=collection-add]', $form).hide()
      else
        $('[data-behavior~=collection-add]', $form).show()

  toggleMealChoices = (input, form) ->
    if input.val() == 'true'
      $('.meal-choice-wrapper', form).show()
    else
      $('.meal-choice-wrapper', form).hide()

  resetCollectionNumbers()
  showOrHideRemoveFieldsLinks()
  showOrHideAddFieldsLinks()

  $('[data-behavior~=collection-add]').live 'cocoon:after-insert', ->
    showOrHideAddFieldsLinks()
    resetCollectionNumbers()
    showOrHideRemoveFieldsLinks()


  $('form').live 'cocoon:after-remove', ->
    showOrHideAddFieldsLinks()
    resetCollectionNumbers()
    showOrHideRemoveFieldsLinks()

  $('.rsvp-form').each (index) ->
    $rsvpForm = $(this)

    $mealChoiceInput = $('input[name="rsvp_response[attending]"]:checked', $rsvpForm)
    toggleMealChoices($mealChoiceInput, $rsvpForm)

    $('input[name="rsvp_response[attending]"]', $rsvpForm).change ->
      $input = $(this)
      if $input.is(':checked')
        toggleMealChoices($input, $rsvpForm)

    $rsvpForm.validate
      submitHandler: (form)->
        $.rails.handleRemote( $(form) )

    $rsvpForm.live 'ajax:before', ->
      $("input[type=submit]", $rsvpForm).attr('disabled', 'disabled')

    $rsvpForm.live 'ajax:complete', (xhr, status) ->
      $('.rsvp-form-interior', $rsvpForm).hide
        duration: 200
        complete: ->
          $('.rsvp-form-thank-you', $rsvpForm).show()
          $.scrollTo($rsvpForm.parent('article.rsvp'));

  $('.rsvp-form #rsvp_response_guests_attributes_0_name').attr('readonly', true)
  $('.rsvp-form .nested-fields:first .remove_fields').remove()

  toggleMaxGuestsAllowed = (input) ->
    if input.is(':checked')
      $('#section_maximum_number_of_guests_allowed').attr('disabled', false)
    else
      $('#section_maximum_number_of_guests_allowed').attr('disabled', true).val(0)

  toggleMaxGuestsAllowed($('#section_guests_allowed'))
  $('#section_guests_allowed').change ->
    $input = $(this)
    toggleMaxGuestsAllowed($input)