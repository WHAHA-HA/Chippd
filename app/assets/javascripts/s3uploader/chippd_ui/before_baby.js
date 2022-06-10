//= require s3uploader/chippd_ui/image
/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.BeforeBaby = Chippd.Image.extend({
    templateName: "representations/before_baby",

    constructor: function () {
      var self = this;
      Chippd.BeforeBaby.__super__.constructor.apply(self);
      self.caption = ko.observable();
    },

    toJSON: function () {
      var self = this,
        json = Chippd.BeforeBaby.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        caption: self.caption()
      });
    }
  }, { pluralName: "images" });
})();
