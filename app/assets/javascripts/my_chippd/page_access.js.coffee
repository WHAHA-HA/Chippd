jQuery ->

  $('[data-behavior~=access-toggle] .btn').click ->
    p = $($(this).parent())
    console.log(p.data('url'))
    $.ajax(
      url: p.data('url')
      type: 'PUT'
      dataType: 'script'
    )
