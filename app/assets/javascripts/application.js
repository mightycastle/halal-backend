// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-1.8.2
//= require jquery_ujs
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require tmpl.min
//= require bootstrap.min
//= require history
//= require load-image.min
//= require jquery.fileupload
//= require jquery.fileupload-ui

//= require rails.validations
//= require rails.validations.simple_form
//= require jquery.tn3lite.min
//= require jquery.placeholder
//= require jquery.validate
//= require jquery.textareaCounter.plugin
//= require scroll_bar
//= require_tree ./lib
//= require users
//= require menus
//= require restaurants
//= require search_restaurants
//= require review_star_rating
//= require jquery.remotipart
//= require autocomplete-rails


var list_cuisine_ids = [];

$(document).ready(function(){
    home_slider();
    info_tab();
    read_more_review();
    filter();
    set_position_popup();
    check_filter();
    tongle_filter();
    popup_message();
    $('.dropdown-toggle').dropdown();
    list_user_reviews_popover();
    set_left_sidebar();
    avatar();
    placeholder();
    form_validation();
    submit_new_restaurant();
    ajax_history_state();
    $('.select_cuisine').selectpicker({
      style: 'btn_select_cuisin',
      size: 10
    });
    $('.sort_select').selectpicker({
      style: 'btn_select_cuisin',
      size: 10
    });
    btn_select_cuisin();
    restaurant_open_time();
    $('.select-opentime').selectpicker();
    $('#filter_cuisines').selectpicker();
    limit_3_cuisine()
    
    $('#offer_select').selectpicker();
    $('.select_time_open').selectpicker();
    $('#offer_time_public').selectpicker();
    $('.selectpicker').selectpicker();
    $("#date_picker").datepicker({
      onSelect: function(date) {
        $('#btn-now').show();
        $('#show-time').val('').hide(); 
        $('.time_start_offer').val('');
        $('label[for="choice_time_public"]').html('');
      }
    });

    $('.datepicker-schedule-offer').on('click', function (e) {
      $("#date_picker").datepicker('show');
    })

    removeDrage();
    validate_reply();
    $('.select-sort-review').selectpicker({
      style: 'btn_select_cuisin',
      size: 10
    });
    sidebar_scroll();
    $('.tpopover').popover({html: true})
});



function removeDrage(){
  $('.search_submit_btn').on('click', function (e) {
    $('input#drage').val('');
  })
}
function limit_3_cuisine(){
  last_valid_selection = null;

  $('#filter_cuisines').on('change', function(){
    if($(this).val().length > 3){
      last_valid_selection = $(this).val();
      last_valid_selection = last_valid_selection.slice(0,3);
      $(this).val(last_valid_selection);
      $(this).selectpicker('refresh');
    }else{
      last_valid_selection = $(this).val();
    }
  })
}
function validate_reply(){
  $('#btn-reply').live ('click', function(e){
    var id = $(this).parent().parent('.reply-owner').attr('id');
    e.preventDefault();
    if($('#'+id+' #reply_review_reply_content').val().trim().length == 0){
      $('#'+id+' label.error[for=review_reply_content]').removeClass('hide')
      return false;
    }else{
      $('#'+id+' #reply_owner_form').submit()
    }
  })
  $('#reply_review_reply_content').live('keydown', function(e){
    var id = $(this).parent().parent('.reply-owner').attr('id');
    $('#'+id+' label.error[for=review_reply_content]').addClass('hide');
  })
}
function tongle_filter(){
  $('.icon-top-tongle').click( function(){
    parent_price = $(this).parents('.price')
    target = $(this).parents('.li-filter').children('.content_filter')
    if($(this).hasClass('fa-angle-up')){
      $(this).removeClass('fa-angle-up').addClass('fa-angle-down');
      target.hide();
      if(parent_price.length > 0){
        $('.qtip-custom-slider').hide();
      }
    }else{
      $(this).removeClass('fa-angle-down').addClass('fa-angle-up');
      target.show();
      if(parent_price.length > 0){
        $('.qtip-custom-slider').show();
      }
    }

  })
}
function btn_select_cuisin(){
  $('.select_cuisine').on('change',function(){
    $('form#search_home_cuisine').submit()
    // return false;  
  })
   $('.select_cuisine').find('li:first-child').on('click', function(){
    $('form#search_home_cuisine').submit();
   })


}
function ajax_history_state(){

  if (history && history.pushState) {
    $(function() {
      $("#search_filter_form").submit(function() {
        $("div.loading").removeClass('hide');
        list_cuisine_ids = [];
        $.get($("#search_filter_form").attr("action"), $("#search_filter_form").serialize(), null, "script");
        history.replaceState(null, document.title, $("#search_filter_form").attr("action") + "?" + $("#search_filter_form").serialize());
      }); 
      $(window).bind("popstate", function() {
        $.getScript(location.href);
      });
    });
  }
}

function form_validation(){
    $(".contact_us").validate({
        rules:{
            name:{required: true},
            email:{required: true, email: true},
            message:{required: true},
            captcha:{required: true}
        },
        messages:{
            name: "Please enter your name",
            email: {
                required: "Please enter your email",
                email: "Please enter a valid email"
            },
            message: "Please enter your message",
            captcha: "Please type the letters you see"
        }
    });
    $(".advertise_your_restaurant").validate({
        rules:{
            name:{required: true},
            email:{required: true, email: true},
            restaurant_name:{required: true},
            captcha:{required: true},
            phone:{required: true, number: true}
        },
        messages:{
            name: "Please enter your name",
            email: {
                required: "Please enter your email",
                email: "Please enter a valid email"
            },
            restaurant_name: "Please enter your restaurant name",
            captcha: "Please type the letters you see",
            phone: {
                required: "Please enter your phone number",
                number: "Please enter a valid phone number"
            },
        }
    });
    $(".new_review").validate({
        rules:{
            'review[content]': {required: true, maxlength: 5000}
        },
        messages:{
            'review[content]': {
                required: "Please enter review content.",
                maxlength: "is too long (maximum is 5000 characters)."
            }
        }
    });
    $(".new_user").validate({
        rules:{
            'user[username]': {required: true},
            'user[email]': {required: true, email: true},
            'user[password]': {required: true, minlength: 6}
        },
        messages:{
            'user[username]': {
              required: 'Please enter your username'
            },
            'user[email]': {
                required: "Please enter your email.",
                email: "Please enter a valid email."
            },
            'user[password]': {
              required: "Please enter your password.",
              minlength: "Password is too short (minimum is 6 characters)"
            }
        }
    });
    $("#personal_info_form").validate({
        rules:{
            'user[username]': {required: true},
            'user[password]': {minlength: 6},
            'user[password_confirmation]' : {
              minlength : 6,
              equalTo : '#user_password'
            }
        },
        messages:{
            'user[username]': {
              required: 'Please type your name'
            },
            'user[password]': {
              minlength: "Password is too short (minimum is 6 characters)"
            },
            'user[password_confirmation]': {
              minlength: "Password is too short (minimum is 6 characters)",
              equalTo : "Password confirmation doesn’t match"
            }
        }
    });
}
function isNumberKey(evt){
 var charCode = (evt.which) ? evt.which : event.keyCode
 if (charCode > 31 && (charCode < 48 || charCode > 57))
    return false;
 return true;
}
function home_slider(){
    setInterval(function(){
        var $current_image = $("#home_slider img.active"),
            $v = 'slow',
            $class = 'active',
            $next_image = $current_image.next();
        if($next_image.index() == -1){
            $next_image = $("#home_slider img:first");
        }
        $next_image.fadeIn($v, function(){
            $current_image.fadeOut($v, function(){
                $(this).removeClass($class);
            });
            $(this).addClass($class);
        });
    },5000);
}
function placeholder(){
    $('input[placeholder],textarea[placeholder]').placeholder();
}
function set_left_sidebar(){
    if($(".search_result .left")){
        $(".search_result .left").css('min-height',$(".search_result #search_bar").outerHeight());
    }
}
function avatar(){
    $("#choose_file_button").click(function(){
        $("#upload_file_input").click();
    });
    $("#upload_file_input").change(function(){
        $("#new_file_name").addClass('label label-success');
        $("#new_file_name").html($(this).val());
    });
}
function list_user_reviews_popover(){
    $(".lur_restaurant_info").popover({
        trigger:'hover'
    });
}
function info_tab(){
    $("#info_container_tab a").click(function(){
        tab_click = $(this).attr('id');
        tab_active = $("#info_container_tab a.active").attr('id');
        if(tab_click == tab_active){
            return false;
        }
        $("#info_container_tab a.active").removeClass('active');
        $("#info_container_tab a#"+tab_click).addClass('active');
        $("#info_container_content div.active").removeClass('active');
        $("#info_container_content div#content_"+tab_click).addClass('active');
        if(tab_click == 3){
          google.maps.event.trigger(map, 'resize');
          map.setCenter(centrePoint);
        }
    });    
}
function read_more_review(){
    $("#read_more_review").click(function(){
        tab_click = $(this).attr('tab');
        $("#info_container_tab a.active").removeClass(function(){
            $("#info_container_tab a#"+tab_click).addClass('active');
        });
        $("#info_container_content div.active").removeClass('active');
        $("#info_container_content div#content_"+tab_click).addClass('active');
        return false;
    });
}
function filter(){
    $("#search_filter label").click(function(){
        id = $(this).attr('id');
        content_style = $("#search_filter #"+id+"_content").css('display');
        if(content_style == 'block'){

            $("#search_filter #"+id+"_content").hide();
        }else{

            $("#search_filter #"+id+"_content").show();

        }
    });
}
function set_position_popup(){
    $popup_pnl = $(".popup .pnl");
    $window = $(window);
    var pnl_height = $popup_pnl.outerHeight();
    var pnl_width = $popup_pnl.outerWidth();
    var win_height = $window.outerHeight();
    var win_width = $window.outerWidth();
    var top = ((win_height - pnl_height)/2)-200;
    var left = ((win_width - pnl_width)/2)-100;
    $popup_pnl.css({"top":top,"left":left});
}
function check_filter () {
  $('input[type="checkbox"]').click (function(){

    $('input#' + $(this).attr('id')).prop('checked', $(this).is(':checked'))
  });
}
function sidebar_scroll(){
    var $window = $(window),
        $search_bar = $("#search_bar"),
        $leftside = $(".left"),
        $rightside = $(".right"),
        $nav_top = $('.nav_top'),
        $pnl_img_top = $('.pnl_img_top'),
        $nav_bottom = $(".nav_bottom"),
        rest_height = $window.height() - $("#search_bar").height();
        $header = $('.header')

    $window.scroll(function(){
      if($window.scrollTop() >= $header.height()){
        $('.map-part').addClass('fixed-map')
      }else{
        $('.map-part').removeClass('fixed-map')
      }
      //   
        // if($search_bar.outerHeight() >= $rightside.outerHeight()){
        //   return;
        // }
        // if($window.scrollTop() > ($nav_top.outerHeight() + $pnl_img_top.outerHeight())){
        //     $search_bar.addClass('search_bar_fixed');
        //     if(($window.scrollTop() + $search_bar.height()) > ($(document).height() - $nav_bottom.outerHeight())) {
        //         $search_bar.css({
        //             'bottom':0,
        //             'top':'auto',
        //             'position':'absolute'
        //         })
        //     }else{
        //         $search_bar.css({
        //             'bottom':'',
        //             'top':0,
        //             'position':''
        //         })
        //     }
        // }else{
        //     $search_bar.removeClass('search_bar_fixed');
        // }
    })
}
function popup_message(){
    if($("#popup_message").html() != ""){
        setTimeout(function(){
            $("#popup_message").html('');
                
        },10000);
    }
}
jQuery(document).ready(function($) {
  
  // This disable submiting the form with the ENTER key only for inputs and selects of search location when location sugguestion are visible
  // $('form#search_filter_form input#ln').keydown(function(event){    
  //   if(event.keyCode == 13) {
  //     search_text_change = $('input#search_text_change').val()
  //     $('input[name=llat]').val('');
  //     $('input[name=llng]').val('');
  //     event.preventDefault();
  //     $('.searching-img').removeClass('hide');
  //     text_search = $('#ln').val()
  //     url = "by_location?utf8=✓&ln=" + text_search + "&llat=&llng=&lt=&search_text_change=" + search_text_change;
  //     window.location = url;
  //       // $('form#search_filter_form').submit();
  //   }
  //   else{
  //     $('input#search_text_change').val('true');
  //   }
  // });
  // Delay search form submit
  $('form#search_home').submit(function (e) {
      var form = this;
      e.preventDefault();
      setTimeout(function () {
          form.submit();
      }, 500); // in milliseconds
  });
  
  $('input#ln').keydown(function(event) {

    if(event.keyCode != 13) {
      $('input[name=llat]').val('');
      $('input[name=llng]').val('');
      $('input#search_text_change').val('true');
    }
  });
  // This function to set direction content to send user
  $("a.email_me_directions").click(function() {
    $("#direction_content").val($("#direction_text").html());
  });
  
  // $(".search_not_mobile div.content_filter input, select.sort_by").live('change',function() {
  //   $('input[id=' + $(this).attr('id')+']').prop('checked', $(this).is(':checked'));
  //   list_cuisine_ids = [];
  //   $("form#search_filter_form").submit();
  // });
  //   $(" .search_not_mobile select#filter_time , .search_not_mobile select#rest_hour_filter").live('change',function() {
  //   $('input[id=' + $(this).attr('id')+']').prop('checked', $(this).is(':checked'));
  //   list_cuisine_ids = [];
  //   if($(".search_not_mobile select#rest_hour_filter").val() != "" && $(".search_not_mobile select#filter_time").val() != ""){
  //     $("form#search_filter_form").submit();
  //   }
  // });
  


  $("select#sort_review").change(function() {
    $("form#sort_review").submit();
  });
  
  $("div.cuisine_pnl input").change(function() {
    $('input#' + $(this).attr('id')).prop('checked', $(this).is(':checked'));
    if ($(this).is(':checked')) {
      $('#label_cuisine_' + $(this).attr('id')).removeClass('hide');
    } else {
      $('#label_cuisine_' + $(this).attr('id')).addClass('hide');
    }
    list_cuisine_ids.push($(this).attr('id'));
  });
  
  $("a#sm_1_popup").click(function() {
    var i, _i, _len;
    for (_i = 0, _len = list_cuisine_ids.length; _i < _len; _i++) {
      i = list_cuisine_ids[_i];
      $('input#' + i).prop('checked', !$('div.cuisine_pnl input#' + i).is(':checked'));
      if ($('div.cuisine_pnl input#' + i).is(':checked')) {
        $('#label_cuisine_' + $('div.cuisine_pnl input#' + i).attr('id')).removeClass('hide');
      } else {
        $('#label_cuisine_' + $('div.cuisine_pnl input#' + i).attr('id')).addClass('hide');
      }
    }
    list_cuisine_ids = [];
  });
  // old code
  // $('input#restaurant_is_owner').change(function() {
  //   if ($(this).is(':checked') == true ) {
  //     $('div.is_not_owner').addClass('hide');
  //     $('div.is_not_owner input').val('');
  //     $('div.is_owner').removeClass('hide');
  //   } else {
  //     $('div.is_owner').addClass('hide');
  //     $('div.is_owner input').val('');
  //     $('div.is_not_owner').removeClass('hide');
  //   }
  // });
});

function selectFirstResult() {
  var firstResult = $(".pac-container .pac-item:first").text();

  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({"address":firstResult}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
          var place = results[0];

          $("#lt").val(place.types);
          $("#llat").val(place.geometry.location.lat());
          $("#llng").val(place.geometry.location.lng());
          
          $("input#ln").val(firstResult);
      }
  });
}

function restaurant_open_time(){
  $('#btn-apply-to-all-evening').click(function(){
    time_from = $('.select-opentime.from.evening option:selected').val();
    time_to = $('.select-opentime.to.evening option:selected').val();
    $('.select-opentime.from.evening').val(time_from);
    $('.select-opentime.from.evening').selectpicker('refresh');
    $('.select-opentime.to.evening').val(time_to);
    $('.select-opentime.to.evening').selectpicker('refresh');
  })
  $('#btn-apply-to-all-daily').click(function(){
    time_from = $('.select-opentime.from.daily option:selected').val();
    time_to = $('.select-opentime.to.daily option:selected').val();
    $('.select-opentime.from.daily').val(time_from);
    $('.select-opentime.from.daily').selectpicker('refresh');
    $('.select-opentime.to.daily').val(time_to);
    $('.select-opentime.to.daily').selectpicker('refresh');
  })
  $('.time-closed').click(function(){
    class_val = $(this).attr('data-value');
    $(class_val).val('');
    $(class_val).selectpicker('refresh');
  })

}

function submit_new_restaurant () {
  $('#new_restaurant').validate({
    rules: {
      'restaurant[name]': "required",
      'restaurant[city]': "required",
      'restaurant[phone]':{
        number: true
      },
      'restaurant[suggester_email]':{
        email: true
      },
      'restaurant[suggester_phone]':{
        number: true
      }
    },
    messages: {
      'restaurant[name]':"<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill restaurant name",
      'restaurant[city]': "<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill city",
      'restaurant[suggester_email]':{
        email: "<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill a valid email address."
      } ,
      'restaurant[phone]':{
        number: "<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill a valid phone number."
      },
      'restaurant[suggester_phone]':{
        number: "<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill a valid phone number."
      },
      'restaurant[address]': "<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill a valid address."
    }
  });
  $('#submit_restaurant_normal').on('click', function (e) {
    e.preventDefault(); 
    check_validate_new_restaurant_normal();
  })
  $('#submit_restaurant_user').on('click', function (e) {
    e.preventDefault(); 
    check_validate_new_restaurant_user();
  });

  $('.submit_new_review').on('click', function(e){
    e.preventDefault();
    check_validate_new_review();
  })
}

function check_validate_new_review(){
  var isFormValid = true;
  if ($('#review_service').val() == 0 || $('#review_quality').val() == 0 || $('#review_value').val() == 0){
    $('.rate-row').addClass('border-red');
    $('.validate-message-row').removeClass('hide');
    isFormValid = false;
  }

  if ($('#review_content').val().length == 0){
    $('label[for="review_content"]').html("<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill your review about this restaurant.")
    isFormValid = false;
  }

  if(isFormValid ){
    $('#new_review_restaurant').submit();
  }
}
function check_validate_new_restaurant_normal() {
  var isFormValid = true;
  if ($('#restaurant_review_service').val() == 0 || $('#restaurant_review_quality').val() == 0 || $('#restaurant_review_value').val() == 0){
    $('.rate-row').addClass('border-red');
    $('.validate-message-row').removeClass('hide');
    isFormValid = false;
  }

  if ($('#review_content').val().length == 0){
    $('label[for="review_content"]').html("<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill your review about this restaurant.")
    isFormValid = false;
  }

  if(isFormValid ){
    $('#new_restaurant').submit();
  }
}

function check_validate_new_restaurant_user() {
  var isFormValid = true;
  if($('#restaurant_suggester_name').val().trim().length == 0){
    $('label[for="restaurant_suggester_name"]').html("<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill your name.")
    $('label[for="restaurant_suggester_name"]').show();
    isFormValid = false;
  }
  if ($('#restaurant_suggester_email').val().trim().length == 0){
    $('label[for="restaurant_suggester_email"]').html("<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill a valid email address.")
    isFormValid = false;
  }
  if ($('#restaurant_suggester_phone').val().trim().length == 0){
    $('label[for="restaurant_suggester_phone"]').html("<i  class='fa fa-exclamation custom-icon-invalid'></i> Please fill your phone number.")
    isFormValid = false;
  }
  if(isFormValid ){
    $('#check_user_restaurant').val(true)
    $('#new_restaurant').submit();

  }
}

function countChar(val) {
  var len = val.value.length;
  var target = $(val).siblings('.content_character_count');
  if (len > 4999) {
    target.text(len+"/5000");
    val.value = val.value.substring(0, 4999);
  } else {
    target.text((len)+"/5000");
  }
};


