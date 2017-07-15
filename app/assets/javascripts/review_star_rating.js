$(function(){
  //   var options2 = {
		// 				'maxCharacterSize': 500,
		// 				'originalStyle': 'originalTextareaInfo',
		// 				'warningStyle' : 'warningTextareaInfo',
		// 				'warningNumber': 40,
		// 				'displayFormat' : '#input/#max'
		// 		};
		// $('textarea#review_content').textareaCount(options2);
   
    
  });

  var set_stars = function(form_id, stars){
    for(i=1; i <= 5; i++){
      if(i <= stars){
        $('#' + form_id + '_' + i).addClass("ratings_stars");
      } else {
        $('#' + form_id + '_' + i).removeClass("ratings_stars");
      }
    }
  }
  
  $(function() {
     $('.rating_star').click(function() {
        var star = $(this);
        var form_id = star.attr("data-form-id");
        var stars = star.attr("data-stars");

        $('#' + form_id + '_stars').val(stars);

        $.ajax({
        type: "post",
        url: $('#' + form_id).attr('get_ratings'),
        data: $('#' + form_id).serialize()
      })
    });

    $('.star_rating_form').each(function() {
      var form_id = $(this).attr('id');
      set_stars(form_id, $('#' + form_id + '_stars').val());
     });
 });

  function rating_stars(name, i){
    $('#'+name+'_5').removeClass('fa-star');
    $('#'+name+'_4').removeClass('fa-star');
    $('#'+name+'_3').removeClass('fa-star');
    $('#'+name+'_2').removeClass('fa-star');
    $('#'+name+'_1').removeClass('fa-star');
    if(i == 5){
      $('#'+name+'_5').addClass('fa-star');
      $('#'+name+'_4').addClass('fa-star');
      $('#'+name+'_3').addClass('fa-star');
      $('#'+name+'_2').addClass('fa-star');
      $('#'+name+'_1').addClass('fa-star');
    }else if(i == 4){
      $('#'+name+'_5').addClass('fa-star-o');
      $('#'+name+'_4').addClass('fa-star');
      $('#'+name+'_3').addClass('fa-star');
      $('#'+name+'_2').addClass('fa-star');
      $('#'+name+'_1').addClass('fa-star');
    }else if(i == 3){
      $('#'+name+'_5').addClass('fa-star-o');
      $('#'+name+'_4').addClass('fa-star-o');
      $('#'+name+'_3').addClass('fa-star');
      $('#'+name+'_2').addClass('fa-star');
      $('#'+name+'_1').addClass('fa-star');
    }else if(i == 2){
      $('#'+name+'_5').addClass('fa-star-o');
      $('#'+name+'_4').addClass('fa-star-o');
      $('#'+name+'_3').addClass('fa-star-o');
      $('#'+name+'_2').addClass('fa-star');
      $('#'+name+'_1').addClass('fa-star');
    }else if(i == 1){
      $('#'+name+'_5').addClass('fa-star-o');
      $('#'+name+'_4').addClass('fa-star-o');
      $('#'+name+'_3').addClass('fa-star-o');
      $('#'+name+'_2').addClass('fa-star-o');
      $('#'+name+'_1').addClass('fa-star');
    }
  }

  function rating_bars(name, i){
    $('#'+name+'_5').removeClass('rating_bars_over');
    $('#'+name+'_4').removeClass('rating_bars_over');
    $('#'+name+'_3').removeClass('rating_bars_over');
    $('#'+name+'_2').removeClass('rating_bars_over');
    $('#'+name+'_1').removeClass('rating_bars_over');
    if(i == 5){
      $('#'+name+'_5').addClass('rating_bars_over');
      $('#'+name+'_4').addClass('rating_bars_over');
      $('#'+name+'_3').addClass('rating_bars_over');
      $('#'+name+'_2').addClass('rating_bars_over');
      $('#'+name+'_1').addClass('rating_bars_over');
    }else if(i == 4){
      $('#'+name+'_5').addClass('rating_bars');
      $('#'+name+'_4').addClass('rating_bars_over');
      $('#'+name+'_3').addClass('rating_bars_over');
      $('#'+name+'_2').addClass('rating_bars_over');
      $('#'+name+'_1').addClass('rating_bars_over');
    }else if(i == 3){
      $('#'+name+'_5').addClass('rating_bars');
      $('#'+name+'_4').addClass('rating_bars');
      $('#'+name+'_3').addClass('rating_bars_over');
      $('#'+name+'_2').addClass('rating_bars_over');
      $('#'+name+'_1').addClass('rating_bars_over');
    }else if(i == 2){
      $('#'+name+'_5').addClass('rating_bars');
      $('#'+name+'_4').addClass('rating_bars');
      $('#'+name+'_3').addClass('rating_bars');
      $('#'+name+'_2').addClass('rating_bars_over');
      $('#'+name+'_1').addClass('rating_bars_over');
    }else if(i == 1){
      $('#'+name+'_5').addClass('rating_bars');
      $('#'+name+'_4').addClass('rating_bars');
      $('#'+name+'_3').addClass('rating_bars');
      $('#'+name+'_2').addClass('rating_bars');
      $('#'+name+'_1').addClass('rating_bars_over');
    }
  }
  function chage_rating(rating_type, i){

    if(rating_type == 'service'){
      $('#restaurant_review_service').val(i)
      if ($('#restaurant_review_quality').val() != 0 && $('#restaurant_review_value').val() != 0 ) {
        $('.validate-message-row').addClass('hide');
      };
    }
    if(rating_type == 'quality'){
      $('#restaurant_review_quality').val(i)
      if ($('#restaurant_review_value').val() != 0 && $('#restaurant_review_service').val() != 0 ) {
        $('.validate-message-row').addClass('hide');
      };
    }
    if(rating_type == 'value'){
      $('#restaurant_review_value').val(i)
      if ($('#restaurant_review_quality').val() != 0 && $('#restaurant_review_service').val() != 0 ) {
        $('.validate-message-row').addClass('hide');
        $('.rate-row').removeClass('border-red');
      };
    }
    var rating_count = i;
    var rate_id = 'review_' + rating_type;
    $('li[type="'+rating_type+'"]').attr('last', rating_type+'_false');
    $("#"+rating_type+"_"+i).attr('last', rating_type+'_true');
    target =  document.getElementById(rate_id)
    if(target != null){
      target.value = rating_count;
      rating_stars(rating_type, rating_count)
      var ser = document.getElementById('review_service').value;
      var qua = document.getElementById('review_quality').value;
      var val = document.getElementById('review_value').value;
      var rat = (parseInt(ser) + parseInt(qua) + parseInt(val))/3.0;
      rating_bars('rating_overall', parseInt(rat));
    }
  }

  $(function(){
    $(".review_number").hover(
      function(){
        var $id = $(this).attr('id');
        $("img.review_badge_active").addClass('review_badge');
        $("img.review_badge_active").removeClass('review_badge_active');
        $("img#review_badge_"+$id).removeClass();
        $("img#review_badge_"+$id).addClass('review_badge_active');
      },
      function(){
        
      }
    )
  })
function choose_over_stars(id,type){
  $('li[type="'+type+'"]').removeClass('fa-star').addClass('fa-star-o');
  for(var i = 1; i<= id; i++){
    $("#"+type+"_"+i).addClass('fa-star').removeClass('fa-star-o')
  }
}
function choose_out_stars(id,type){
  for(var i = 1; i<= id; i++){
      $("#"+type+"_"+i).removeClass('fa-star').addClass('fa-star-o')
    }
  var $last = $('li[last="'+type+'_true"]').attr('num');
  if($last){
    for(var i = 1; i<=$last; i++){
      $("#"+type+"_"+i).addClass('fa-star').removeClass('fa-star-o')
    }
  }
}
