handleGiftMessageFields = (toggle) ->
  if toggle
    $('#order_gift_recipient_email, #order_gift_recipient_message').removeAttr('disabled')
  else
    $('#order_gift_recipient_email, #order_gift_recipient_message').attr('disabled', 'disabled')

jQuery ->
  orderIsGift = $('#order_is_gift_true').is(':checked')
  handleGiftMessageFields(orderIsGift)

  $('input[name="order[is_gift]"]').change( ->
    orderIsGift = $('#order_is_gift_true').is(':checked')
    handleGiftMessageFields(orderIsGift)
  )
