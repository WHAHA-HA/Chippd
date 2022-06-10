// UTILITIES
// =====================================================




// FILTER
$("[data-filter-option]").on("click", function(e){
  e.preventDefault();
  var el = $(this),
      filterOption = el.attr("data-filter-option"),
      filterText   = el.text();
  // Only show matching items
  $("[data-filter-tags]").removeClass("is-visible").addClass("is-hidden");
  $("[data-filter-tags="+filterOption+"]").addClass("is-visible").removeClass("is-hidden");
  // Change selected text
  $(".filter__current").text(filterText);
});




// TOOLTIP (checkout)
$('.card-details, #page-line-items-list').tooltip({
  selector: "a[rel=tooltip]"
});

$("p.intro").fitText(3.8, { minFontSize: '16px'});
$("p.outro").fitText(3.8, { minFontSize: '16px'});

$(".modal-body.video, .embedded_video").fitVids();


// TABS
$('.chippdTab a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');
});




// COLLAPSE
$(".chippdCollapse").on("click", function(e){
  e.preventDefault();
  var el = $(this),
      target = $(el.attr("data-target"));
  el.toggleClass("is-active");
  target.collapse("toggle");
});




// BACKGROUND IMAGE ON HOMEPAGE VIDEO BLOCK
$('#calls-to-action .video').anystretch("/assets/promo-video.jpg", {speed: 150});

// SMART RESIZE
(function($,sr){
  // debouncing function from John Hann
  // http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
  var debounce = function (func, threshold, execAsap) {
      var timeout;

      return function debounced () {
          var obj = this, args = arguments;
          function delayed () {
              if (!execAsap)
                  func.apply(obj, args);
              timeout = null;
          };

          if (timeout)
              clearTimeout(timeout);
          else if (execAsap)
              func.apply(obj, args);

          timeout = setTimeout(delayed, threshold || 100);
      };
  }
  // smartresize
  jQuery.fn[sr] = function(fn){  return fn ? this.bind('resize', debounce(fn)) : this.trigger(sr); };

})(jQuery,'smartresize');



// REACTOR
// Direct changes in classnames depedent on the ebb and flow of the viewport
function doReact(){

  $(".js-reactor, #content article").each(function(){
    var el = $(this),
        w = el.width(),
        d = "";
    if ( w < 300 ) { d += "lt300 "; }
    if ( w < 350 ) { d += " lt350"; }
    if ( w < 400 ) { d += " lt400"; }
    if ( w < 400 ) { d += " lt425"; }
    if ( w < 400 ) { d += " lt435"; }
    if ( w < 450 ) { d += " lt450"; }
    if ( w < 475 ) { d += " lt475"; }
    if ( w < 500 ) { d += " lt500"; }
    if ( w > 300 ) { d += " gt300"; }
    if ( w > 350 ) { d += " gt350"; }
    if ( w > 400 ) { d += " gt400"; }
    if ( w > 450 ) { d += " gt450"; }
    if ( w > 500 ) { d += " gt500"; }
    if ( w > 550 ) { d += " gt550"; }
    if ( w > 600 ) { d += " gt600"; }
    if ( w > 650 ) { d += " gt650"; }
    if ( w > 700 ) { d += " gt700"; }
    if ( w > 750 ) { d += " gt750"; }
    if ( w > 800 ) { d += " gt800"; }
    el.attr("data-reactor-width", d);
  });
}
$(window).smartresize(function(){
  doReact();
});
// On Load
$(document).ready(function() {
  doReact();
});




// open all external links in new window
$("a[href^='http']").attr("target", "_blank");

// How It Works Nested links
$('strong.example_link').on("click", function(e){
  e.preventDefault();
  $link = $(this);
  window.location = $link.data('sample-url');
});

