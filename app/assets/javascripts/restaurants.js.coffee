# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $('#show-time').hide()
  $('#btn-now').on 'click', () ->
    $('#btn-now').hide()

    time =  new Date();
    h = time.getHours();
    m = time.getMinutes();
    day = $.datepicker.formatDate('MM - dd - yy', time )
    $('.time_start_offer').val(time)
    # $('#show-time').text("#{day} - #{h}:#{m}").show()
    $("#date_picker").datepicker('setDate', null);
    $('label[for="choice_time_public"]').html('')
    $("#new_offer").submit();
    
  $('#own_offer_content').on 'keydown', () ->
    $('#offer_select').val('')
    $('#offer_select').selectpicker('refresh')
    $('label[for="choice_or_create_offer"]').html('')

  $('#offer_select').on 'change',() ->
    $('#own_offer_content').val('')
    $('label[for="choice_or_create_offer"]').html('')
    offer_id = $('#offer_select').val()
    if offer_id != ''
      $.ajax
        url: '/offer/' + offer_id + '/get_offer_image',
        dataType: 'json',
        type: 'GET',
        success: (data) ->
          if data.image != null
            $('img.off-image-old').attr('src', data.image)
            $('.old_image_offer').removeClass('hide')

  $('.remove-offer-image').on 'click', () ->
    offer_id = $('#offer_select').val()
    if offer_id != ''
      $.ajax
        url: '/offer/' + offer_id + '/remove_offer_image',
        dataType: 'json',
        type: 'POST',
        success: (data) ->
          $('.old_image_offer').addClass('hide')


  $('.time-choice-offer').on 'change', () -> 
    $('.select_day_from').val('')
    $('.select_day_to').val('')
    $('#offer_start_time').val('')
    $('#offer_end_time').val('')
    $('.select_day_from').selectpicker('refresh');
    $('.select_day_to').selectpicker('refresh');
    $('#offer_start_time').selectpicker('refresh');
    $('#offer_end_time').selectpicker('refresh');

  $('.select_time_open').on 'change', () ->
    $('.time-choice-offer').prop('checked', false);
    $('label[for="choice_time_available"]').html('')


  $('.btn-submit-offer').on 'click', (e) ->
    e.preventDefault()
    isFormValid = true
    if($('#offer_select').val().length == 0 && $('#own_offer_content').val().trim().length == 0 )
      isFormValid = false
      $('label[for="choice_or_create_offer"]').html('Please choice an offer or create new an offer')
    radio = $('#options_time').find('input[type="radio"]:checked')
    uncheck_custom_timing = false
    if($('#offer_start_date').val().length == 0 || $('#offer_end_date').val().length == 0 || $('#offer_start_time').val().length == 0 || $('#offer_end_time').val().length == 0 )
      uncheck_custom_timing = true
    if(radio.length == 0 && uncheck_custom_timing)
      isFormValid = false
      $('label[for="choice_time_available"]').html('Please choice time available for this offer')
    unchoice_time_public = false
    if($('.offer_date_public').val().length == 0 || $('#offer_time_public').val().trim().length == 0)
      unchoice_time_public =  true
    if($('#offer_time_start_offer').val().length == 0 && unchoice_time_public)
      isFormValid = false
      $('label[for="choice_time_public"]').html('Please choice time available for this offer')  
    if(isFormValid)
      $('#new_offer').submit()


  $('.next-offer-public-first').on 'click', (e) ->
    e.preventDefault()
    if($('#offer_select').val().length == 0 && $('#own_offer_content').val().trim().length == 0 )
      
      $('label[for="choice_or_create_offer"]').html('Please choice an offer or create new an offer')
    else

      $('.col-second').removeClass('opacity-disable')
      $('.col-second .block-action').hide()
      $('#choose_offer').addClass('hide')
      $('#section_first').removeClass('hide')
      offer_id = $('#offer_select').val()
      if offer_id != ''
        $.ajax
          url: '/offer/' + offer_id + '/get_offer',
          dataType: 'json',
          type: 'GET',
          success: (data) ->
            if data.time_available == null || data.time_available == ''
              $("input.time-choice-offer[type='radio']").prop("checked", false)
            else
              $("input.time-choice-offer[type='radio'][value='"+data.time_available+"']").prop("checked", true)
            if data.start_time == null || data.start_time == ''
              $('#offer_start_time').val('')
              $('#offer_start_time').selectpicker('refresh')
            else $('#offer_start_time').selectpicker('val', data.start_time)

            if data.start_date == null || data.start_date == ''
              $('#offer_start_date').val('')
              $('#offer_start_date').selectpicker('refresh')
            else $('#offer_start_date').selectpicker('val', data.start_date)
            
            if data.end_time == null || data.end_time == ''
              $('#offer_end_time').val('')
              $('#offer_end_time').selectpicker('refresh')
            else $('#offer_end_time').selectpicker('val', data.end_time)

            if data.end_date == null || data.end_date == ''
              $('#offer_end_date').val('')
              $('#offer_end_date').selectpicker('refresh')
            else $('#offer_end_date').selectpicker('val', data.end_date)

            if data.date_publish == null || data.date_publish == ''
              $("#date_picker").datepicker('setDate', '')
            else $("#date_picker").datepicker('setDate', data.date_publish )

            if data.time_publish == null || data.time_publish == ''
              $('#offer_time_public').val('')
              $('#offer_time_public').selectpicker('refresh')
            else $('#offer_time_public').selectpicker('val', data.time_publish)

            if data.time_start_offer != ''
              date = new Date(data.time_start_offer)
              h = date.getHours();
              m = date.getMinutes();
              day = $.datepicker.formatDate('MM - dd - yy', date )

              # $('#show-time').html("#{day}-#{h}:#{m}").show() 
              $('.time_start_offer').val(data.time_start_offer)
            else $('#show-time').html("").hide()
      else
        $('.select_day_from').val('')
        $('.select_day_to').val('')
        $('#offer_start_time').val('')
        $('#offer_end_time').val('')
        $('.select_day_from').selectpicker('refresh');
        $('.select_day_to').selectpicker('refresh');
        $('#offer_start_time').selectpicker('refresh');
        $('#offer_end_time').selectpicker('refresh');
            

  $('.next-offer-public-second').on 'click',(e) ->
    e.preventDefault()
    radio = $('#options_time').find('input[type="radio"]:checked')
    uncheck_custom_timing = false
    if($('#offer_start_date').val().length == 0 || $('#offer_end_date').val().length == 0 || $('#offer_start_time').val().length == 0 || $('#offer_end_time').val().length == 0 )
      uncheck_custom_timing = true
    if(radio.length == 0 && uncheck_custom_timing)
      $('label[for="choice_time_available"]').html('Please choice time available for this offer')
    else
      $('.col-three').removeClass('opacity-disable')
      $('.col-three .block-action').hide()
      $('#choose_time').addClass('hide')
      $('#section_second').removeClass('hide')
    
  $('#options_time input[type=radio]').on 'change', () ->
    $('label[for="choice_time_available"]').html('')

  $('.edit-section-btn').on 'click', () ->
    parent = $(this).parents('.section_completed')
    parent.addClass('hide')
    $(parent).siblings('.section-open').removeClass('hide')


  $(".offer_image").change ->
    readURL(this)

  readURL = (input) -> 
    if (input.files && input.files[0]) 
      reader = new FileReader()
      reader.onload = (e) ->
        $('.image-preview').find('img').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  
  $(".jtooltip").tooltip(
    position: { my: "top center", at: "top-30" } 
  )