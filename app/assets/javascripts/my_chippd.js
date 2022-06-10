// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// IMPORTANT: This manifest is loaded into all views within MyChipp'd, including the page builder.
//            It should only contain code that is used in the management of Chipp'd pages.
//            IT IS NOT LOADED ON THE ACTUAL CHIPP'D PAGE (app/views/my_chippd/pages/show.html.erb)
//
//= require_self
//= require bootstrap-tab
//= require bootstrap-collapse
//= require bootstrap-datetimepicker.min
//= require underscore
//= require object
//= require ko-helpers
//= require s3uploader/s3uploader
//= require baby_grows/baby_grows
//= require babys_favorites/babys_favorites
//= require my_chippd/babys_first
//= require my_chippd/auction
//= require my_chippd/datetimepickers
//= require my_chippd/page_name
//= require my_chippd/page_access
//= require my_chippd/section_sorting
//= require b2b_stats_page

// declare the top level Chippd namespace
window.Chippd = {};
