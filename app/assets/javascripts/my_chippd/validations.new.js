jQuery(function() {
    var validateSocialURL;
    $("input[type=radio]:checked").parents(".radio").addClass("selected");

    $("body").delegate("input[type=radio]", "click", function() {
        var el, thisName;
        el = $(this);
        thisName = el.attr("name");
        $("input[name='" + thisName + "']").parents(".radio").removeClass("selected");
        return el.parents(".radio").addClass("selected");
    });
    $("[maxlength]").each(function() {
        var charCurrent, charMax, charRemaining, el;
        el = $(this);
        charCurrent = el.val().length;
        charMax = parseInt(el.attr("maxlength"));
        charRemaining = charMax - charCurrent;
        return el.parents(".controls").addClass("with-char-count").prepend("<span class='control__char-count'>" + charRemaining + "</span>");
    });
    $("[maxlength]").on("focus", function() {
        var el;
        el = $(this);
        return el.siblings(".control__char-count").addClass("is-visible");
    });
    $("[maxlength]").on("blur", function() {
        var el;
        el = $(this);
        return el.siblings(".control__char-count").removeClass("is-visible");
    });
    $("[maxlength]").on("keyup", function() {
        var charCurrent, charMax, charRemaining, el;
        el = $(this);
        charCurrent = el.val().length;
        charMax = parseInt(el.attr("maxlength"));
        charRemaining = charMax - charCurrent;
        return el.siblings(".control__char-count").text(charRemaining);
    });
    $.extend($.validator.messages, {
        required: "Don't forget this."
    });
    $('form').validate({
        onfocusout: function(e) {
            return this.element(e);
        },
        onkeyup: false
    });
    $("form").submit(function() {
        return $(this).find("input.required:visible").each(function() {
            if ($.trim($(this).val()) === "") {
                return false;
            }
        });
    });
    validateSocialURL = function(el) {
        var thisInput;
        thisInput = el;
        if (thisInput.val().length && thisInput.val().indexOf(thisInput.data("base_url")) < 0) {
            return thisInput.removeClass("valid").addClass("base_url_error").siblings(".base_url_message").show();
        } else {
            return thisInput.addClass("valid").removeClass("base_url_error").siblings(".base_url_message").hide();
        }
    };
    $("input[data-base_url]").each(function() {
        var thisInput;
        thisInput = $(this);
        thisInput.after("<label class='base_url_message error' style='display:none;'>URL must contain " + $(this).data("base_url") + "</label>");
        thisInput.parents("form").addClass("require-1");
        return validateSocialURL(thisInput);
    });
    $("input[data-base_url]").on("keyup", function() {
        return validateSocialURL($(this));
    });
    $("form.require-1").on("submit", function(e) {
        var isValid, thisForm;
        isValid = false;
        thisForm = $(this);
        thisForm.find("input[data-base_url]").each(function() {
            validateSocialURL($(this));
            if ($(this).val().length > 0) {
                return isValid = true;
            }
        });
        if (isValid === false) {
            alert("Please enter at least one URL");
            e.preventDefault();
        }
        if (thisForm.find(".base_url_error").length) {
            return e.preventDefault();
        }
    });
    $(".no-filereader input[type='file']").show();
    $(".no-filereader input[type='file']").on("change", function(e) {
        var $this, acceptedType, ext;
        $this = $(this);
        acceptedType = $this.attr("accept");
        ext = $this.val().split('.').pop().toLowerCase();
        if (acceptedType.indexOf('image') > -1) {
            if ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) === -1) {
                alert('Sorry, that file won\'t work. You must select an image to upload (.gif, .png, .jpg, or .jpeg).');
                $this.replaceWith($this.clone(true));
            }
        }
        if (acceptedType.indexOf('video') > -1) {
            if ($.inArray(ext, ['mov', 'mp4', 'm4v', 'ogg', 'wmv']) === -1) {
                alert('Sorry, that file won\'t work. You must select a video to upload (.mov, .mp4, .m4v, .ogg or .wmv)');
                $this.replaceWith($this.clone(true));
            }
        }
        if (acceptedType.indexOf('mp3') > -1) {
            if ($.inArray(ext, ['mp3']) === -1) {
                alert('Sorry, that file won\'t work. You must select an mp3 to upload.');
                $this.replaceWith($this.clone(true));
            }
        }
        if (acceptedType.indexOf('pdf') > -1) {
            if ($.inArray(ext, ['pdf']) === -1) {
                alert('Sorry, that file won\'t work. You must select a pdf to upload.');
                return $this.replaceWith($this.clone(true));
            }
        }
    });
    $('#chipp-form').on('focus', 'input.url[data-base_url]', function(event) {
        var el;
        console.log('focused');
        event.stopPropagation();
        el = $(this);
        if (_.isEmpty(el.val())) {
            return el.val(['http://', el.data('base_url'), '/'].join(''));
        }
    });
    $('#chipp-form').on('blur', 'input.url[data-base_url]', function(event) {
        var el;
        console.log('blured');
        event.stopPropagation();
        el = $(this);
        if (el.val() === ['http://', el.data('base_url'), '/'].join('')) {
            return el.val('');
        }
    });
    $('#chipp-form').on('focus', 'input.url', function() {
        var el;
        el = $(this);
        if (_.isEmpty(el.val())) {
            return el.val('http://');
        }
    });
    return $('#chipp-form').on('blur', 'input.url', function() {
        var el;
        el = $(this);
        if (el.val() === 'http://') {
            return el.val('');
        }
    });
});