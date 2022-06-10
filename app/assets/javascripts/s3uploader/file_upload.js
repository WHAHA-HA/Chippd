/* globals Chippd, ko, $, S3Upload, console */
(function() {
  "use strict";
  
  Chippd.FileUpload = Chippd.Object.extend({
    constructor: function FileUpload (existingFile) {
      var self = this;
      existingFile = $.extend({}, existingFile);
      self.type = ko.observable();
      self.chosenFile = ko.observable();
      self.onFinished = ko.observable();
      self.onError = ko.observable();
      self.url = ko.observable(existingFile.url);
      self.id = ko.observable(existingFile.id);
      self.name = ko.observable(existingFile.name);
      self.started = ko.observable(false);
      self.uploaded = ko.observable();
      self.error = ko.observable();
      self.progress = ko.observable(0);
      self.showErrorMessage = ko.observable(false);
      self.required = ko.observable(true);
      self.uploadSize = ko.observable();
      self.helpText = ko.observable();

      self.representationTemplate = ko.computed(function () {
        return "representations/" + this.type();
      }, self);

      self.cancel = function () {
        if (!self.started() || self.uploaded()) { return; }
        self.upload.abort();
        self.started(false);
        self.chosenFile(null);
      };

      self.start = function () {
        if (!self.chosenFile()) { throw new Error("chosenFile should not be null"); }

        var finishedCb = self.onFinished(),
            errorCb = self.onError();
        self.error(null);
        self.upload = new S3Upload(self.chosenFile(), {
          onStart: function () {
            self.started(true);
            self.uploaded(false);
          },
          onTotalAvailable: _.once(function (total) {
            self.uploadSize(total);
          }),
          onProgress: function (progress) {
            self.progress(progress);
          },
          onFinish: function (publicUrl) {
            self.uploaded(true);
            self.url(publicUrl);
            if (_.isFunction(finishedCb)) {
              finishedCb(publicUrl);
            }
          },
          onError: function (e) {
            self.error(e);
            if (_.isFunction(errorCb)) {
              errorCb(e);
            }
            console.error("There was an error while uploading the file: " + e);
          }
        });

        self.upload.start();
      };
    },

    toJSON: function () {
      var copy = ko.toJS(this),
        obj = {
          id: copy.id,
          url: copy.url
        };
      if (copy.uploadSize) {
        obj.uploadSize = copy.uploadSize;
      }
      return obj;
    }
  });
})();
