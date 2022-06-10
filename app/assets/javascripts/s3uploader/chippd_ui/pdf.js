/* globals Chippd */
(function() {
  "use strict";
  Chippd.Pdf = Chippd.FileUpload.extend({
    accept: "application/pdf",
    type: "pdf",
    templateName: "representations/pdf"
  }, { pluralName: "Pdfs" });
})();
