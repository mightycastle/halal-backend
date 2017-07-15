function sidebar_scroll(){
    var $window = $(window),
        $search_bar = $("#search_bar"),
        $leftside = $(".left"),
        $rightside = $(".right"),
        $nav_top = $('.nav_top'),
        $pnl_img_top = $('.pnl_img_top'),
        $nav_bottom = $(".nav_bottom"),
        rest_height = $window.height() - $("#search_bar").height();
    $window.scroll(function(){
        if($search_bar.outerHeight() >= $rightside.outerHeight()){
          return;
        }
        if($window.scrollTop() > ($nav_top.outerHeight() + $pnl_img_top.outerHeight())){
            $search_bar.addClass('search_bar_fixed');
            if(($window.scrollTop() + $search_bar.height()) > ($(document).height() - $nav_bottom.outerHeight() - 40)) {
                $search_bar.css({
                    'bottom':0,
                    'top':'auto',
                    'position':'absolute'
                })
            }else{
                $search_bar.css({
                    'bottom':'',
                    'top':0,
                    'position':''
                })
            }
        }else{
            $search_bar.removeClass('search_bar_fixed');
        }
    })
}