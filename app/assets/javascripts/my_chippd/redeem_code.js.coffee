jQuery ->

  activateProductType = (li)->
    $li = $(li)
    $("ul#chippd-select li").removeClass('active')
    $("input[name='chippd_product_type_id']").attr('checked', false)
    $li.addClass('active')
    $("input[name='chippd_product_type_id'][value='#{$li.data('target')}']").attr('checked', true)

  $("ul#chippd-select li a").click ->
    $el = $(this)
    activateProductType($el.parent())
    false

  verified = false

  $('input[name=code]').change ->
    verified = false

  $('#redeem-code-form .btn-large').click ->
    $btn = $(this)
    $form = $('#redeem-code-form')

    $btn.attr('disabled', 'disabled')

    if verified
      $form.submit()
    else
      $.ajax(
        url: $form.data('verification-url')
        type: 'GET'
        dataType: 'json'
        data:
          code: $('input[name=code]').val()
      ).done((data, textStatus, jqXHR)->
        if data.type == 'retail'
          if data.chippd_product_type_ids.length == 1
            $("input[name='chippd_product_type_id'][value='#{data.chippd_product_type_ids[0]}']").attr('checked', true)
            $form.submit()
          else
            $('#chippd-type').show()
            $.each(data.chippd_product_type_ids, (index, value) ->
              $("li[data-target~=#{value}]").show()
            )

            activateProductType($('ul#chippd-select li:visible').first();)

          verified = true
          $btn.removeAttr('disabled').val('Activate Product')
        else
          $form.submit()
      ).fail((jqXHR, textStatus, errorThrown)->
        $form.submit()
      )

    false