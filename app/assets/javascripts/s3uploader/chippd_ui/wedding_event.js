//= require s3uploader/chippd_ui/image
/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.WeddingEvent = Chippd.Image.extend({
    templateName: "representations/wedding_event",

    constructor: function WeddingEvent () {
      var self = this;
      Chippd.WeddingEvent.__super__.constructor.apply(self);

      self.what = ko.observable();
      self.when = ko.observable();
      self.happens_on = ko.observable();
      self.starts_at = ko.observable();
      self.where =  ko.observable();
      self.website = ko.observable();
      self.note = ko.observable();
    },

    toJSON: function () {
      var self = this,
        json = Chippd.WeddingEvent.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        what: self.what(),
        when: self.when(),
        happens_on: self.happens_on(),
        starts_at: self.starts_at(),
        where: self.where(),
        website: self.website(),
        note: self.note()
      });
    }
  }, { pluralName: "events" });
})();
