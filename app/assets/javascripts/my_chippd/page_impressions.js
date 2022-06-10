$(function() {

  function track_impression(section_el, impression_behavior)
  {
    if(section_el.data('impressions-tracked') === true) return; // if it's been tracked already then don't track again

    var section_id = section_el.data('impressions-section');
    var page_key = section_el.parents('.wrapper').data('page-key');

    var impression = {
      page_id: page_key,
      section_id: section_id,
      section_type: section_el.data('impressions-section-type'),
      customer_id: $('meta[name="customer-id"]').attr('content'),
      impression_type: impression_behavior
    };

    Keen.addEvent("impressions", impression, function() {
      section_el.data('impressions-tracked', true);
    });
  }

  $('[data-impressions-behavior=click]').click(function() {
    var section_el = $(this).parents('article');
    track_impression(section_el, "click");
  });

  $('[data-impressions-behavior=scroll]').waypoint(function() {
    var section_el = $(this);
    if(section_el.find('[data-impressions-behavior=click]').length > 0) return; // click's override the default scroll tracking

    track_impression(section_el, "scroll");
  });

});