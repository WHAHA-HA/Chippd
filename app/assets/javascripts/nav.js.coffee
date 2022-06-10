toggleNavigationBasedOnWindowWidth = (win)->
  nav = $('header nav')
  if $(win).width() <= 767
    unless nav.hasClass('hidden')
      nav.hide().addClass('hidden')
  else
    nav.show().removeClass('hidden')

jQuery ->
  win = $(window)

  toggleNavigationBasedOnWindowWidth(win)

  win.resize ->
    toggleNavigationBasedOnWindowWidth(this)

  $('#toggle').click ->
    $('header nav').slideToggle('1000', "linear", ->
    )
