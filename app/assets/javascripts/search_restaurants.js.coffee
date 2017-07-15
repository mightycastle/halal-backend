TOGGLE_SEARCH = true

$(document).ready ->
  $("#more-filters").on "click", (e) ->
    show_more_filter()

  $("#less-filters").on "click", (e) ->
    show_less_filter()

  $("#search_filter_form").on "submit", (e) -> 
    $("#result_table").addClass("cover_loading")   

  $("#search_filter_form").on "change", ".short-filter .finder-checkbox-image input", (e) ->
    e.preventDefault()
    if TOGGLE_SEARCH == true
      setTimeout (->
        $("#search_filter_form").submit()
      ), 500
      


window.show_more_filter = ->
  TOGGLE_SEARCH = false
  $(".short-filter").fadeOut()
  $(".long-filter").fadeIn()

window.show_less_filter = ->
  TOGGLE_SEARCH = true
  $(".short-filter").fadeIn()
  $(".long-filter").fadeOut()    