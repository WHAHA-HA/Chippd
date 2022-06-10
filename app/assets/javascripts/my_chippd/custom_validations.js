jQuery(document).ready(function(jQuery) {

    //custom validate methods
    jQuery.validator.addMethod("validWeight",function(value,element){
        var regEx = /a/;
        return regEx.test(value);
    },'Please input valid address!');

    //otherjob validator
    jQuery.validator.addMethod("validHeight",function(value,element){
        var job_title = value;

        var position_in_org = jQuery('#position_in_org').val();
        if(position_in_org=='other')
        {
            if(job_title=='')
                return false;
        }
        return true;
    },'Please input valid job title!');


    //step 3 validate
    jQuery.validator.addMethod("minmaxparticipants",function(value,element){
        var min = jQuery('#min_tour_participants').val();
        var max = jQuery('#max_tour_participants').val();
        console.log(min);
        console.log(max);
        if (jQuery.isNumeric(min) && jQuery.isNumeric(max))
            if( max<=min)
                return false;
        return true;
    },'Please max participants should be bigger than min participants!');


    //end document ready
});
