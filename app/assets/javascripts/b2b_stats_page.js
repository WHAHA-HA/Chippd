/* global async, $, PageVisitStats, PageImpressionStats */
$(function () {
  "use strict";

  function bytesToSize(bytes) {
    if (bytes === 0) { return "0 Byte"; }
    var k = 1000,
      sizes = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"],
      i = Math.floor(Math.log(bytes) / Math.log(k));
    return (bytes / Math.pow(k, i)).toPrecision(3) + " " + sizes[i];
  }

  var statHandlers = {
    get: function (el, args, stats) {
      findPath(stats, args)(function (val) {
        $(el).text(val);
      });
    },

    getBytes: function (el, args, stats) {
      findPath(stats, args)(function (val) {
        $(el).text(bytesToSize(parseInt(val, 10)));
      });
    },

    getViewersAfter: function (el, timestamp, stats) {
      var options = {
        timeframe: {
          start: timestamp,
          end: (new Date()).toISOString()
        },
        callback: function (v) {
          $(el).text(v);
        }
      };
      stats.viewersAfter(options);
    },
    
    getPercentViewersAfter: function (el, timestamp, stats) {
      async.parallel([
        function (cb) {
          stats.total.uniqueViewers(function (v) {
            cb(null, v);
          });
        },
        function (cb) {
          var afterOptions = {
            timeframe: {
              start: timestamp,
              end: (new Date()).toISOString()
            },
            callback: function (v) {
              cb(null, v);
            }
          };
          stats.viewersAfter(afterOptions);
        }
      ], function (err, results) {
        var total = results[0],
          returned = results[1],
          percentage = (parseFloat(returned) / parseFloat(total)) * 100;

        $(el).text(percentage + "%");
      });
    }
  };

  /** 
   * Find a deep path in a object.
   *
   * For example, findPath(obj, "a.b.c") would return 2 if obj looked like:
   *
   * obj = { a: { b: { c: 2 } } }
   */
  function findPath(obj, path) {
    var i, parts = path.split(".");
    for (i = 0; i < parts.length; i++) {
      obj = obj[parts[i]];
    }
    return obj;
  }

  function handleStatHolders(selector, clazz) {
    $(selector).each(function () {
      var pageId = $(this).attr("data-page"),
        stats = clazz.forPage(pageId);
      $(this).find(".stat-holder").each(function () {
        var self = this,
          args = $(this).attr("data-args").split(":"),
          loadNow = $(this).attr("data-load-now"),
          loadValue = function () {
            var otherArgs = args.slice(1).join(":");
            statHandlers[args[0]](self, otherArgs.trim(), stats);
          };
        
        if (loadNow) {
          loadValue();
        } else {
          $(self).one("inview", function (e, isInView) {
            if (isInView) {
              loadValue();
            }
          });
        }
      });
    });
  }

  function handleListStatHolders(selector, clazz, formatCb) {
    $(selector).each(function () {
      var pageId = $(this).attr("data-page"),
        stats = clazz.forPage(pageId);
      $(this).find(".statlist-holder").each(function () {
        var self = this,
          path = $(this).attr("data-path"),
          loadNow = $(this).attr("data-load-now"),
          loadValue = function () {
            findPath(stats, path)(function (results) {
              if (results.length === 0) {
                $(self).append("<li>Not enough data found.</li>");
                return;
              }

              $.each(results, function () {
                var r = formatCb(this, pageId);
                $(self).append($("<li></li>").html(r));
              });
            });
          };
        
        if (loadNow) {
          loadValue();
        } else {
          $(self).one("inview", function (e, isInView) {
            if (isInView) {
              loadValue();
            }
          });
        }
      });
    });
  }

  handleStatHolders(".b2b-visit-statistics", PageVisitStats);
  handleStatHolders(".b2b-asset-statistics", PageImpressionStats);
  handleListStatHolders(".b2b-asset-statistics", PageImpressionStats, function (r, pageId) {
    var el = $("<a></a>"),
      type = r.section_type.replace("_", " "),
      url = "/my-chippd/pages/" + pageId + "/sections/" + r.section_id + "/edit";
  
    el.text(type + " (" + r.result + " impresssions)");
    el.attr("href", url);
    return el;
  });
});
