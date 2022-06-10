/* globals ko, Chippd */
(function() {
  "use strict";
  var counter = 0;
  Chippd.TimelineAsset = Chippd.FileUpload.extend({
    constructor: function () {
      var self = this;
      Chippd.TimelineAsset.__super__.constructor.apply(self);
      self.media_type  = ko.observable();
      self.timeframe   = ko.observable();
      self.heading     = ko.observable();
      self.description = ko.observable();
      self.track_name  = ko.observable();
      self.radio_name  = ko.observable("media_type_"+counter);
      counter++;
    },
    accept: "image/*,video/*,.mov,.avi,audio/mp3,audio/x-m4",
    templateName: "representations/timeline_asset",

    toJSON: function () {
      var self = this,
        json = Chippd.TimelineAsset.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        media_type:  self.media_type(),
        timeframe:   self.timeframe(),
        heading:     self.heading(),
        description: self.description(),
        track_name:  self.track_name()
      });
    }
  }, { pluralName: "Timeline Assets" });
})();
