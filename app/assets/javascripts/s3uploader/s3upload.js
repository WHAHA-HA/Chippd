/* globals window, $, XMLHttpRequest, XDomainRequest */
(function () {
  "use strict";

  var S3Upload = function (file, callbacks) {
    if (!S3Upload.signUrl) {
      throw new Error("Sign url [S3Upload.signUrl] is not defined!");
    }

    this.file = file;
    this.callbacks = $.extend({
      onStart: function () {},
      onFinish: function () {},
      onProgress: function () {},
      onTotalAvailable: function () {},
      onError: function () {}
    }, callbacks);
  };

  S3Upload.signUrl = undefined;

  S3Upload.prototype.start = function () {
    var self = this;
    self.started = true;
    self.callbacks.onStart();
    self.signUrl(self.file, function (signedUrl, publicUrl) {
      self.uploadToS3(self.file, signedUrl, publicUrl);
    });
  };

  S3Upload.prototype.signUrl = function (file, cb) {
    var self = this,
      xhr = new XMLHttpRequest();
    xhr.open("POST", S3Upload.signUrl, true);
    xhr.setRequestHeader("Content-type", "application/json");
    xhr.onreadystatechange = function () {
      var result;
      if (this.readyState === 4 && this.status === 201) {
        try {
          result = JSON.parse(this.responseText);
        } catch (error) {
          self.callbacks.onError("Signing server returned some ugly/empty JSON: '" + this.responseText + "'");
          return false;
        }
        return cb(result.signed_url, result.public_url);
      } else if (this.readyState === 4 && this.status !== 201) {
        return self.callbacks.onError("Could not contact request signing server. Status = " + this.status);
      }
    };
    return xhr.send(JSON.stringify({
      mime_type: file.type,
      file_name: file.name
    }));
  };

  S3Upload.prototype.createCORSRequest = function (method, url) {
    var xhr = new XMLHttpRequest();
    if (xhr.withCredentials !== null) {
      xhr.open(method, url, true);
    } else if (typeof XDomainRequest !== "undefined") {
      xhr = new XDomainRequest();
      xhr.open(method, url);
    } else {
      xhr = null;
    }
    return xhr;
  };

  S3Upload.prototype.uploadToS3 = function (file, signedUrl, publicUrl) {
    var self = this,
      xhr = self.createCORSRequest("PUT", signedUrl);

    self.uploadXhr = xhr;

    if (!xhr) {
      self.callbacks.onError("CORS not supported");
    } else {
      xhr.onload = function () {
        if (xhr.status === 200) {
          self.callbacks.onProgress(100, "Upload completed.", publicUrl, file);
          self.uploaded = true;
          return self.callbacks.onFinish(publicUrl, file);
        } else {
          return self.callbacks.onError("Upload error: " + xhr.status, file);
        }
      };

      xhr.onerror = function () {
        return self.callbacks.onError("XHR error.", file);
      };

      xhr.upload.onprogress = function (e) {
        var percentLoaded;
        if (e.lengthComputable) {
          percentLoaded = Math.round((e.loaded / e.total) * 100);
          self.callbacks.onTotalAvailable(e.total, file);
          return self.callbacks.onProgress(percentLoaded, (percentLoaded === 100 ? "Finalizing." : "Uploading."), publicUrl, file);
        }
      };
    }
    xhr.setRequestHeader("Content-Type", file.type);
    xhr.setRequestHeader("x-amz-acl", "public-read");
    return xhr.send(file);
  };

  S3Upload.prototype.abort = function () {
    if (!this.uploadXhr) { return; }
    this.uploadXhr.abort();
  };

  window.S3Upload = S3Upload;
})();
