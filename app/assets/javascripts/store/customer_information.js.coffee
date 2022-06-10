class StripeTokenHandler
  constructor: ->
    @addressSource = if $('#order_billing_same_as_shipping').is(':checked') then 'shipping_address_attributes' else 'billing_address_attributes'

  createToken: ->
    Stripe.createToken({
      number: this.cardNumber(),
      cvc: this.cardCvc(),
      exp_month: this.cardExpMonth(),
      exp_year: this.cardExpYear()
    }, this.stripeResponseHandler)

  cardNumber: ->
    $('.card-number').val()

  cardCvc: ->
    $('.card-cvc').val()

  cardExpMonth: ->
    $('.card-exp_month').val()

  cardExpYear: ->
    $('.card-exp_year').val()

  name: ->
    [this.valueFor('first_name'), this.valueFor('last_name')].join(' ')

  address1: ->
    this.valueFor('address_1')

  address2: ->
    this.valueFor('city')

  state: ->
    $('option:selected', $(this.addressSelectorFor('state'))).val()

  postalCode: ->
    this.valueFor('postal_code')

  country: ->
    this.valueFor('country')

  valueFor: (attribute) ->
    $(this.addressSelectorFor(attribute)).val()

  addressSelectorFor: (attribute) ->
    ['#', 'order', '_', @addressSource, '_', attribute].join('')

  stripeResponseHandler: (status, response) ->
    if response.error
      $('.submit-btn').removeAttr("disabled")
      error_field = response.error.param
      error_message = response.error.message
      el = $('.card-' + error_field)
      el.addClass('error')
      $('#customer-id-wrapper').before('<p class="help-inline error">' + error_message + '</p>')
      addGlobalErrorMessage()
    else
      form = $("#checkout-form")
      token = response['id']
      form.append("<input type='hidden' name='stripeToken' value='" + token + "' />")
      form.get(0).submit()

class CheckoutValidator
  constructor: ->

  queryString: ->
    'input[data-validate]'

  elements: ->
    document.querySelectorAll(this.queryString())

  validate: ->
    @validations = judge.validate(this.elements(), (valid, messages, element) =>
      if !valid
        this.addErrorClassTo(element)
        this.addErrorMessageFor(element, messages[0])
    )

  addErrorClassTo: (element) ->
    $(element).parents('.control-group').addClass('error')

  addErrorMessageFor: (element, message) ->
    $(element).after('<span class="help-inline">' + message + '</span>')

  passes: ->
    validity = _.map(@validations, (obj) -> obj.valid);
    failing_validations = _.include(validity, false)
    !failing_validations

class AddressValidator extends CheckoutValidator
  queryString: ->
    string = ['#shipping_address_attributes input[data-validate]']
    unless $('#order_billing_same_as_shipping').is(':checked')
      string.push('#billing_address_attributes input[data-validate]')
    string.join(', ')

class PaymentValidator extends CheckoutValidator
  queryString: ->
    '#shipping_and_payment_attributes input[data-validate]'

  addErrorClassTo: (element) ->
    $(element).addClass('error')

  addErrorMessageFor: (element, message) ->
    message = [$(element).data('label'), message].join(' ')
    $('#customer-id-wrapper').before('<p class="help-inline error">' + message + '</p>')

handleBillingAddressFields = (toggle) ->
  if toggle
    $('#billing_address_attributes input.string, #billing_address_attributes select').attr('disabled', 'disabled')
    $('#billing_address_attributes span.help-inline').remove()
    $('#billing_address_attributes .control-group').removeClass('error')
    # add code to bring over values from shipping fields
    updateBillingWithShipping()
  else
    $('#billing_address_attributes input.string, #billing_address_attributes select').removeAttr('disabled')

updateBillingWithShipping = ->
  $('#billing_address_attributes input.string, #billing_address_attributes select').each ->
    $this = $(this)
    name = $this.attr("name").replace "billing", "shipping"
    $this.val($('[name="' + name + '"]').val())

disableSubmit = ->
  $('.submit-btn').attr("disabled", "disabled")

enableSubmit = ->
  $('.submit-btn').removeAttr("disabled")

removeAllErrorMessages = ->
  $('.help-inline').remove()
  $('.control-group, input').removeClass('error')

addGlobalErrorMessage = ->
  $('#shipping_address_attributes').before('<div id="error-message" class="alert alert-error">Some errors were found, please fix them below:</div>')

removeGlobalErrorMessage = ->
  $('#error-message, .alert-error').remove()

jQuery ->
  billing_same_as_shipping = $('#order_billing_same_as_shipping')
  handleBillingAddressFields(billing_same_as_shipping.is(':checked'))
  billing_same_as_shipping.change( ->
    handleBillingAddressFields($(this).is(':checked'))
  )

  $('input[data-sync-with-billing], select[data-sync-with-billing]').change ->
    if billing_same_as_shipping.is(':checked')
      sourceEl = $(this)
      updateableId = sourceEl.attr('id').replace('shipping_address', 'billing_address')
      updateable = $(['#', updateableId].join(''))
      updateable.val(sourceEl.val())

  $("#checkout-form").submit((event) ->
    disableSubmit()
    removeAllErrorMessages()
    removeGlobalErrorMessage()

    addressValidator = new AddressValidator
    addressValidator.validate()

    paymentValidator = new PaymentValidator
    paymentValidator.validate()

    if addressValidator.passes() and paymentValidator.passes()
      tokenHandler = new StripeTokenHandler
      tokenHandler.createToken()
    else
      addGlobalErrorMessage()
      enableSubmit()

    false # submit from callback
  )