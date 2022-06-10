/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.Milestone = Chippd.Object.extend({
    constructor: function () {
      var self = this;
      self._id = ko.observable();
      self.date = ko.observable();
      self.age = ko.observable();
      self.weight = ko.observable();
      self.height = ko.observable();
    }
  });
})();
