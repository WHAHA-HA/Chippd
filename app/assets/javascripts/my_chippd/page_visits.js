$(function() {
  
  if($('[data-track-visits=true]').length < 1) return;
  
  var pageKey = $('.wrapper').data('page-key');
  var customerId = $('meta[name="customer-id"]').attr('content');
  
  var visit = {
    page_id: pageKey,
    customer_id: customerId
  };
  
  Keen.addEvent("visits", visit);
});