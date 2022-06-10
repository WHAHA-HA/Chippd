/* globals $, ko, Chippd */
$.fn.initSingleUpload = function (existing, type, inputName, helpText) {
  "use strict";
  var elem = this.get(0);
  inputName = inputName || "upload";

  if (!elem) { return; }
  
  (function () {
    var self = this,
      $form = $(self).closest("form");
    
    if ($form.length === 0) { throw new Error ("Uploader div must be inside a form"); }

    var fileUpload = existing || new type(),
      required = true;

    // allow user to override the required attribute
    if ($(elem).attr("data-required")) {
      required = $(elem).attr("data-required") === "true";
    }

    fileUpload.required(required);
    if (helpText) {
      fileUpload.helpText(helpText);
    }

    fileUpload.onError(function () {
      fileUpload.cancel();

      // Don't show the validation error message too.
      fileUpload.showErrorMessage(false);
    });

    fileUpload.onFinished(function () {
      var json = JSON.stringify([fileUpload.toJSON()]),
        encodedJson = encodeURIComponent(json);

      $form
        .append('<input name="' + inputName + '" type="hidden" value="' + encodedJson + '" >')
        .submit();
    });

    ko.applyBindings(fileUpload, self);

    $form.submit(function (e) {
      if (fileUpload.uploaded()) {
        return true;
      } else if (!fileUpload.started()) {
        if (fileUpload.chosenFile()) {
          fileUpload.start();
        } else if (fileUpload.id()) {
          return true;
        } else if (!fileUpload.required()) {
          return true;
        }

        fileUpload.showErrorMessage(true);
        e.preventDefault();
        return false;
      } else if (!fileUpload.uploaded()) {
        e.preventDefault();
        return false;
      } else {
        return false;
      }
    });
  }).apply(elem);
};
