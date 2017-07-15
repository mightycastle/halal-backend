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
//= require_tree ./manager

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function overlay() {
	el = document.getElementById("overlay");
	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
}

managing_reocurring_offers = false;
var manage_offers_recurring = function(e) {
  btn = document.getElementById("manage-offers-recurring-btn");

  if (managing_reocurring_offers) {
    btn.textContent = "Manage offers";
    managing_reocurring_offers = false;

    $(".recurring-offers .edit-btn").css("display", "none")
    $(".recurring-offers .delete-btn").css("display", "none")
    $(".recurring-offers .weekday").css("display", "table-cell")
  } else {
    btn.textContent = "Stop managing offers";
    managing_reocurring_offers = true;

    $(".recurring-offers .edit-btn").css("display", "table-cell")
    $(".recurring-offers .delete-btn").css("display", "table-cell")
    $(".recurring-offers .weekday").css("display", "none")
  }
}

managing_offers_one_time = false;
var manage_offers_one_time = function(e) {
  btn = document.getElementById("manage-offers-one-time-btn");

  if (managing_offers_one_time) {
    btn.textContent = "Manage offers";
    managing_offers_one_time = false;

    $(".one-time-offers .edit-btn").css("display", "none")
    $(".one-time-offers .delete-btn").css("display", "none")
  } else {
    btn.textContent = "Stop managing offers";
    managing_offers_one_time = true;

    $(".one-time-offers .edit-btn").css("display", "table-cell")
    $(".one-time-offers .delete-btn").css("display", "table-cell")
  }
}

var previous_history = [];

var request_page = function(page) {
  $.get(paths[page], function(data, status) {
    current_page = page;
    init();
    window.history.pushState({path: paths[page]},'', paths[page] );
    previous_history.push(page);
  })
  .fail(function() {
    alert("Error")
  });
};

/* Enable sidebar ajax */
var enable_sidebar_ajax = function() {
  $(".sidebar a").removeAttr("href");
}

/* Disable ajax from sidebar, so that the user navigates by loading other pages */
var disable_sidebar_ajax = function() {
  $(".sidebar a").removeAttr("onclick");
}

var init = function() {
};

var ajax = false;
$(function() {
  if (ajax) {
    enable_sidebar_ajax();
  } else {
    disable_sidebar_ajax();
  }

  init();
});
