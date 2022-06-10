/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.Favorite = Chippd.Object.extend({
    constructor: function () {
      var self = this;
      self._id = ko.observable();
      self.category = ko.observable();
      self.title = ko.observable();
    }
  });
})();
