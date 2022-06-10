/* globals ko, $ */
(function () {
  "use strict";

  /** 
   * Helper for the datepicker component.
   */
  ko.bindingHandlers.datepicker = {
    init: function (element, valueAccessor, allBindingsAccessor) {
      // initialize datepicker with some optional options
      var options = allBindingsAccessor().datepickerOptions || {},
        picker = $(element).datetimepicker(options).data("datetimepicker"),
        input = $(element).find("input").get(0),
        initialDate = valueAccessor()(),
        applyValue = function () {
          var elem = this,
          date = new Date($(elem).val());
          valueAccessor()(date);
        };

      if (initialDate) {
        picker.setValue(new Date(initialDate));
      }

      // when a user changes the date, update the view model
      ko.utils.registerEventHandler(element, "changeDate", function (event) {
        var value = valueAccessor();
        if (ko.isObservable(value)) {
          value(event.date);
        }
      });

      ko.utils.registerEventHandler(input, "keypress", applyValue);
      ko.utils.registerEventHandler(input, "blur", applyValue);
      ko.utils.registerEventHandler(input, "click", function () {
        picker.show();
      });
    },
    update: function (element, valueAccessor)   {
      var widget = $(element).data("datepicker");
      // when the view model is updated, update the widget
      if (widget) {
        widget.date = ko.utils.unwrapObservable(valueAccessor());
        if (widget.date) {
          widget.setValue();
        }
        $(element).val(widget.date);
      }

    }
  };

  /**
   * Binding helper for setting the required attribute.
   */
  ko.bindingHandlers.required = {
    update: function (element, valueAccessor) {
      var value = ko.unwrap(valueAccessor());
      if (value) {
        $(element).attr("required", "true");
      } else {
        $(element).removeAttr("required");
      }
    }
  };
})();
