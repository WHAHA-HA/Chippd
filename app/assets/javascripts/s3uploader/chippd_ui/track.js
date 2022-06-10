/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.Track = Chippd.FileUpload.extend({
    accept: "audio/mp3, audio/x-m4a",
    type: "track",
    templateName: "representations/track",

    constructor: function () {
      var self = this;
      Chippd.Track.__super__.constructor.apply(self);
      self.name = ko.observable();
    },

    toJSON: function () {
      var self = this,
        json = Chippd.Track.__super__.toJSON.apply(self);
      return ko.utils.extend(json, {
        name: self.name()
      });
    }
  }, { pluralName: "tracks" });
})();
