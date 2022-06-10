jQuery ->

  $('[data-behavior~=sortable-section-list]').sortable
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))

  $('[data-behavior~=sortable-section-list]').disableSelection()
  $('[data-behavior~=reorder-page-sections]').click ->
    $('[data-behavior~=page-sections-preview]').hide()
    $('[data-behavior~=sortable-page-sections]').show()
    false

  $('[data-behavior~=disabled-section-type-link]').click ->
    false

