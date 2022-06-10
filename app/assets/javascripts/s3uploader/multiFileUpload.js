/* globals $, ko */
$.fn.initMultiUpload = function (existing, opts) {
  "use strict";
  this.each(function () {
    var self = this,
      Model = opts.model || Chippd.FileUploads,
      uploads,
      $form = $(self).closest("form");
    
    if ($form.length === 0) { throw new Error("Uploader div must be inside a form"); }

    uploads = new Model(existing, opts);
    uploads.onFinished(function () {
      var removedUploads = _.map(uploads.removedUploads(), function (f) {
          return { id: f.id() };
        }),
        json = JSON.stringify(removedUploads.concat(_.map(uploads.uploads(), function (f) {
          return f.toJSON();
        }))),
        encodedJson = encodeURIComponent(json);

      $form
        .append('<input name="upload" type="hidden" value="' + encodedJson + '" >')
        .submit();
    });

    $form.submit(function (e) {
      var requiredFields = $form.find("[required]");
      uploads.showErrorMessage(true);

      if (requiredFields.length > 0 && !requiredFields.valid()) {
        return false;
      }

      if (uploads.uploaded()) {
        return true;
      }

      if (!uploads.started()) {
        if (uploads.canStart()) {
          uploads.start();
        }
        e.preventDefault();
        return false;
      }

      if (!uploads.uploaded()) {
        e.preventDefault();
        return false;
      }
    });

    ko.applyBindings(uploads, self);
  });
};
