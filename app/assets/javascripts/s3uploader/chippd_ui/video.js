/* globals ko, Chippd */
(function() {
  "use strict";
  Chippd.Video = Chippd.FileUpload.extend({
    accept: "video/*,.mov,.avi",
    type: "video",
    templateName: "representations/video"

  }, { pluralName: "Videos" });
})();
