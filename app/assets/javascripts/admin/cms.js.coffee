resetZebraStripes = (el)->
  $("tbody tr", el).removeClass("odd")
  $("tbody tr:nth-child(odd)", el).addClass("odd")

jQuery.fn.makeSortable = (sort_path, authenticity_token)->
  el = $(this);
  el.tableDnD(
    {
      onDragClass: 'is-dragging'
      onDrop: (table, row)->
        $.ajax(
          {
            type: "POST",
            url: sort_path,
            processData: false,
            data: $.tableDnD.serialize() + '&authenticity_token=' + encodeURIComponent(authenticity_token),
            dataType: 'json',
            success: (msg)->
              resetZebraStripes()
              el.effect("highlight", {}, 1000)
          }
        )
    }
  )

jQuery ->
  $('.btn-destroy').click ->
    if !confirm("Are you sure you want to delete this?")
      return false

  $('input.date').datepicker(
    {
      dateFormat: "yy-mm-dd",
      changeMonth: true,
      changeYear: true
    }
  )

  $('a.disabled').click ->
    false

  $('.form-actions button').click ->
    btn = $(this)
    btn.button('loading')

  $('#page_template_widget_type').change ->
    $sel = $(this)
    $name = $('#page_template_widget_name')
    $name.val($sel.find('option:selected').html())

  toggleBatchProduct = ->
    $wrapper = $('#product_id_wrapper')
    if $('#batch_retail_true').is(':checked')
      $wrapper.show()
    else
      $wrapper.hide()

  toggleBatchProduct()
  $('input[name="batch[retail]"]').on 'change', ->
    toggleBatchProduct()
    
  $(".chosen-select").chosen();