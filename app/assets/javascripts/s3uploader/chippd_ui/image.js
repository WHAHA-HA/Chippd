/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.Image = Chippd.FileUpload.extend({
    accept: "image/*",
    type: "image",
    templateName: "representations/image",

  }, { pluralName: "images" });
})();
