jQuery ->
  confirmation = '<p class="confirmation">You&#8217;re ahead of your time, but we&#8217;ll be in touch real soon!</p>'

  $preorderForm = $('#preorder-form')

  $preorderForm.live 'ajax:before', ->
    $("input[type=submit]", $preorderForm).attr('disabled', 'disabled')

  $preorderForm.live 'ajax:complete', (xhr, status) ->
    $preorderForm.replaceWith(confirmation)
