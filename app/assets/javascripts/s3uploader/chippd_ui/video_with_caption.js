//= require s3uploader/chippd_ui/video
/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.VideoWithCaption = Chippd.Video.extend({
    templateName: "representations/video_with_caption",

    constructor: function () {
      var self = this;
      Chippd.VideoWithCaption.__super__.constructor.apply(self);
      self.caption = ko.observable();
    },

    toJSON: function () {
      var self = this,
        json = Chippd.VideoWithCaption.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        caption: self.caption()
      });
    }
  }, { pluralName: "Videos" });
})();
