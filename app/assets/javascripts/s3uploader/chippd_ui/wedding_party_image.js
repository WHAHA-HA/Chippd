//= require s3uploader/chippd_ui/image

/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.WeddingPartyImage = Chippd.Image.extend({
    constructor: function () {
      var self = this;
      Chippd.WeddingPartyImage.__super__.constructor.apply(self);
      self.image_type = ko.observable();
      self.name       = ko.observable();
      self.title      = ko.observable();
    },
    templateName: "representations/wedding_party_image",

    toJSON: function () {
      var self = this,
        json = Chippd.WeddingPartyImage.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        image_type: self.image_type(),
        name:       self.name(),
        title:      self.title()
      });
    }
  }, { pluralName: "Wedding Party Images" });
})();
