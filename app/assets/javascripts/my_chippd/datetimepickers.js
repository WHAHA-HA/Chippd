/* globals $ */
(function() {
    "use strict";

    function setupPickers() {
        $(".datetimepicker .input-append").datetimepicker({
            language: "en",
            pick12HourFormat: true,
            pickSeconds: false
        });

        $(".datepicker .input-append").datetimepicker({
            language: "en",
            pickTime: false
        });

        $(".pastdatepicker .input-append").datetimepicker({
            language: "en",
            pickTime: false,
            endDate: new Date()
        });

        $(".timepicker .input-append").datetimepicker({
            language: "en",
            pickDate: false,
            pick12HourFormat: true,
            pickSeconds: false
        });
    }

    function bindStartEndPickers() {
        $(".bind-start-end").each(function() {
            var start = $(this).find(".bind-start .input-append input"),
                end = $(this).find(".bind-end .input-append input");

            end.focus(function() {
                if (start.val() && !end.val()) {
                    end.val(start.val());
                }
            });
        });
    }

    setupPickers();
    bindStartEndPickers();

}).call(this);