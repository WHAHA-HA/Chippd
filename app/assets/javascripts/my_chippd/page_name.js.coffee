jQuery ->

  editPageNameLinks = $('.page-name-wrapper a')
  pageNameForms = $('.page-name-form')
  pageNameForms.hide()

  editPageNameLinks.live 'click', ->
    link = $(this)
    form = $(link.data('form'))
    link.parent().hide()
    form.show()
    false

  pageNameForms.live 'ajax:before', ->
    form = $(this)
    $("button[type=submit]", form).attr('disabled', 'disabled')

  pageNameForms.live 'ajax:error', (e, jqxhr, settings, exception) ->
    form = $(this)
    name_wrapper = $(form.data('name'))
    form.hide()
    $("button[type=submit]", form).removeAttr('disabled')
    $('input[name="page[name]"]', form).val $('.page-name', name_wrapper).text()
    name_wrapper.show()

  pageNameForms.live 'ajax:success', (e, data, status, xhr) ->
    form = $(this)
    name_wrapper = $(form.data('name'))
    form.hide()
    $("button[type=submit]", form).removeAttr('disabled')
    $('.page-name', name_wrapper).text $('input[name="page[name]"]', form).val()
    name_wrapper.show()
