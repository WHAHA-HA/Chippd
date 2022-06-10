/* globals ko, Chippd */
(function () {
  "use strict";
  var extend;

  Chippd.Object = function () {};
  Chippd.Object.prototype.toJS = function () {
    return ko.toJS(this);
  };
  Chippd.Object.fromJS = function (obj, cls) {
    if (!cls) { throw new Error("cls should not be null"); }
    var create = function (data) {
      var prop, upload = new cls();
      for (prop in data) {
        if (_.has(data, prop) && ko.isObservable(upload[prop])) {
          upload[prop](data[prop]);
        }
      }
      return upload;
    };

    if (_.isArray(obj)) {
      return _.map(obj, create);
    } else {
      return create(obj);
    }
  };

  // Convenient way to create child classes.
  //
  // See Model.extend in http://backbonejs.org/backbone.js
  extend = Chippd.Object.extend = function (protoProps, staticProps) {
    var parent = this, child, Surrogate;

    // The constructor function for the new subclass is either defined by you
    // (the "constructor" property in your `extend` definition), or defaulted
    // by us to simply call the parent's constructor.
    if (protoProps && _.has(protoProps, "constructor")) {
      child = protoProps.constructor;
    } else {
      child = function () { return parent.apply(this, arguments); };
    }

    // Add static properties to the constructor function, if supplied.
    _.extend(child, parent, staticProps);

    // Set the prototype chain to inherit from `parent`, without calling
    // `parent`'s constructor function.
    Surrogate = function () { this.constructor = child; };
    Surrogate.prototype = parent.prototype;
    child.prototype = new Surrogate();

    // Add prototype properties (instance properties) to the subclass,
    // if supplied.
    if (protoProps) { _.extend(child.prototype, protoProps); }

    // Add mixins if any are defined
    if (protoProps && _.has(protoProps, "mixins")) {
      _.each(protoProps.mixins, function (mixin) {
        _.extend(child.prototype, mixin);
      });
    } 

    // Set a convenience property in case the parent's prototype is needed
    // later.
    child.__super__ = parent.prototype;
    child.extend = function() { return extend.apply(child, arguments); };

    return child;
  };
})();
