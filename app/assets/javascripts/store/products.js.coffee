jQuery ->
  activeProductType = $('input[name="line_item[chippd_product_type_id]"]:checked')
  if activeProductType.length > 0
    $("a[data-target='#{activeProductType.val()}']").parent().addClass('active')
  else
    $("ul#chippd-select li:first").addClass('active')

  $("ul#chippd-select li a").click ->
    $("ul#chippd-select li").removeClass('active')
    el = $(this)
    el.parent().addClass('active')
    $("input[name='line_item[chippd_product_type_id]']").attr('checked', false)
    $("input[name='line_item[chippd_product_type_id]'][value='#{el.data('target')}']").attr('checked', true)
    false