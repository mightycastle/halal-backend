stat_objects = {};
stat_objects_list = []

/* Support functions */

/* Sectiional chart */

var initiate_sectional_chart = function(id, data) {
  initiate_chart(id, data);

  data.draw = sectional_chart_draw;
  data.draw_by_index = sectional_chart_draw_chart_by_index;
  data.pull_data_and_draw = sectional_chart_pull_data_and_draw;
  data.get_height = sectional_chart_get_height;
}

var sectional_chart_get_height = function() {
  var grid_w = this.get_width() - this.left_margin - this.right_margin;
  var num_charts = this.datasets.length;
  var radius = (grid_w - this.circle_distance * (num_charts - 1)) / num_charts / 2

  var height = this.top_margin + this.bottom_margin + radius*2 + 20;
  return height;
}

var sectional_chart_draw = function() {
  this.clear_canvas();

  var num_charts = this.datasets.length;
  var ctx = this.canvas.getContext("2d");

  for (var i = 0; i < num_charts; i++) {
    if (this.datasets[i].retreived_data) {
      this.draw_by_index(i);
    }
  }
  /*  */
}

var sectional_chart_draw_chart_by_index = function(i) {
  var ctx = this.canvas.getContext("2d");

  var grid_x = this.left_margin;
  var grid_y = this.top_margin;
  var grid_w = this.get_width() - this.left_margin - this.right_margin;
  var grid_h = this.get_height() - this.top_margin - this.bottom_margin;

  var num_charts = this.datasets.length;
  var radius = (grid_w - this.circle_distance * (num_charts - 1)) / num_charts / 2

  var center_x = grid_x + radius + radius*2*i + this.circle_distance*i;
  var center_y = grid_y + radius;

  var sat = this.datasets[i].retreived_data.satisfied;
  var unsat = this.datasets[i].retreived_data.unsatisfied;
  var ratio = sat / (sat + unsat);

  if (sat + unsat != 0) {
    ctx.beginPath(center_x, center_y);
    ctx.moveTo(center_x, center_y);
    ctx.arc(center_x, center_y, radius, - Math.PI / 2, 2 * Math.PI * ratio - Math.PI / 2, false);
    ctx.moveTo(center_x, center_y);
    ctx.fillStyle = '#d2c5af';
    ctx.fill();
    ctx.closePath();

    if (ratio != 1) {
      ctx.beginPath();
      ctx.moveTo(center_x + Math.cos(2 * Math.PI * ratio - Math.PI / 2) * radius, center_y  + Math.sin(2 * Math.PI * ratio - Math.PI / 2) * radius);
      ctx.lineTo(center_x, center_y);
      ctx.lineTo(center_x, center_y - radius);
      ctx.strokeStyle = '#FFF';
      ctx.lineWidth = 1;
      ctx.stroke();
      ctx.closePath();
    }

    ctx.beginPath();
    ctx.arc(center_x, center_y, radius, 0, 2 * Math.PI, false);
    ctx.strokeStyle = '#FFF';
    ctx.lineWidth = 1;
    ctx.stroke();
    ctx.closePath();
    ctx.beginPath();
  } else {
    ctx.font = "bold 14px Open Sans";
    ctx.textAlign = "center";
    ctx.fillStyle = "#ffffff"
    ctx.fillText("No ratings", center_x, center_y);
  }

  /* Draw title */
  var text_margin = 20;
  var draw_y = this.get_height() - text_margin;

  ctx.font = "14px Open Sans";
  ctx.textAlign = "center";
  ctx.fillStyle = "#ffffff"
  ctx.fillText(this.datasets[i].name, center_x, draw_y);

  /* Draw numericals */

  var font_w = ctx.measureText(sat + "-" + unsat).width
  var font_x = center_x - font_w/2;
  var font_y = draw_y + 16;

  ctx.font = "12px Open Sans";
  ctx.textAlign = "left";
  ctx.fillStyle = "#d2c5af"
  ctx.fillText(sat + " ", font_x, font_y);

  font_x += ctx.measureText(sat + " ").width

  ctx.font = "12px Open Sans";
  ctx.textAlign = "left";
  ctx.fillStyle = "#ffffff"
  ctx.fillText("- ", font_x, font_y);

  font_x += ctx.measureText("- ").width

  ctx.font = "12px Open Sans";
  ctx.textAlign = "left";
  ctx.fillStyle = "#a5b0af"
  ctx.fillText(unsat, font_x, font_y);
}

var sectional_chart_pull_data_and_draw = function() {
  this.current_request_id += 1;

  for (var i = 0; i < this.datasets.length; i++) {
    var stat_object = this
    var dataset = this.datasets[i];
    var request_id = this.current_request_id;
    pull_data(dataset.pull_data_url, dataset, i, function(data, status, jqXHR, indice) {
      dataset = stat_object.datasets[indice]
      dataset.retreived_data = data;

      if (stat_object.current_request_id == request_id) {
        stat_object.draw_by_index(indice)
      }
    });
  }
}

/* Line Chart */

var initiate_line_chart = function(id, data) {
  data.draw_background = line_chart_draw_background;
  data.pull_data_and_draw = line_chart_pull_data_and_draw;
  data.draw = line_chart_draw;
  data.change_data_range = line_chart_change_data_range;
  data.go_back = line_chart_go_back;
  data.go_forward = line_chart_go_forward;
  data.get_days_to_display = line_chart_get_number_of_days;

  initiate_chart(id, data);
}

var line_chart_draw_background = function() {
  var ctx = this.canvas.getContext("2d");

  var grid_x = this.left_margin;
  var grid_y = this.top_margin;
  var grid_w = this.get_width() - this.left_margin - this.right_margin;
  var grid_h = this.get_height() - this.top_margin - this.bottom_margin;

  var date = new Date(this.start_date);
  var count = 0;

  var draw_x = grid_x

  var days = this.get_days_to_display();
  for (var i = 0; i < days; i++) {
    /* Draw line */
    if (date.getDay() != 0 && date.getDay() != 1) {
      ctx.setLineDash([1]);
    } else {
      ctx.setLineDash([0]);
    }

    ctx.strokeStyle="#a5b0af"
    ctx.lineWidth = 1
    ctx.beginPath();
    ctx.moveTo(draw_x, grid_y);
    ctx.lineTo(draw_x, grid_y + grid_h);
    ctx.stroke();

    /* Draw dates */

    if (count % 2 == 0) {
      var draw_width = grid_w / this.get_days_to_display() * 2
      ctx.font = "12px Open Sans Light";
      ctx.textAlign = "center";
      ctx.fillStyle = "#ffffff"

      var date_s = (date.getDate()).toString();
      var month_s = (date.getMonth()).toString();

      if (date_s.length == 1) {
        date_s = "0" + date_s
      }
      if (month_s.length == 1) {
        month_s = "0" + month_s
      }

      ctx.fillText(date_s + "/" + month_s, draw_x, grid_y + grid_h + this.bottom_margin / 2);
    }

    date = new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1, date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds());
    count += 1

    draw_x += grid_w / (this.get_days_to_display() - 1.0);
  }

  /* Draw the Y-axis */

  var draw_y = grid_y;
  var font_adjust = 16
  for (var i = this.y_axis.length - 1; i >= 0; i -= 1 ) {
    ctx.font = "bold 14px Open Sans";
    ctx.textAlign = "center";
    ctx.fillStyle = "#ffffff"
    ctx.fillText(this.y_axis[i].toString(), this.left_margin / 3, draw_y + 12);

    draw_y += (grid_h - font_adjust) / (this.y_axis.length - 1)
  }

  /* Draw legend */

  /*
  var legend_margin = 10

  ctx.font = "12px Open Sans Light"
  var total_text_width = legend_margin* (this.datasets.length - 1)
  for (var i = 0; i < this.datasets.length; i++) {
    total_text_width += ctx.measureText(this.datasets[i].name).width;
  }

  var draw_x = this.get_width() - total_text_width;
  var */
}

var line_chart_draw_data = function(data_index) {
  var dataset = this.datasets[data_index]
  var ctx = this.canvas.getContext("2d");
  ctx.setLineDash([0]);

  var grid_x = this.left_margin;
  var grid_y = this.top_margin;
  var grid_w = this.get_width() - this.left_margin - this.right_margin;
  var grid_h = this.get_height() - this.top_margin - this.bottom_margin;

  var prev_draw_x = -1
  var prev_draw_y = -1
  var draw_x = grid_x;
  var draw_y = -1;

  for (var i = 0; i < dataset.retreived_data.length; i++) {
    prev_draw_y = draw_y
    draw_y = grid_h - ((dataset.retreived_data[i] - this.min_value) / (this.max_value - this.min_value)) * grid_h + grid_y

    if (dataset.retreived_data[i] == -1) {
      prev_draw_y = -1
      draw_y = -1
    }


    if (prev_draw_y != -1) {
      ctx.strokeStyle = dataset.color;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(prev_draw_x, prev_draw_y);
      ctx.lineTo(draw_x, draw_y);
      ctx.stroke();
    }

    prev_draw_x = draw_x
    draw_x += grid_w / (dataset.retreived_data.length - 1.0);
  }
}

var line_chart_draw = function() {
  this.draw_background();

  for (var i = 0; i < this.datasets.length; i++) {

    if (this.datasets[i].retreived_data) {
      line_chart_draw_data.call(this, i);
    }
  }
}

var line_chart_pull_data_and_draw = function() {
  this.draw_background();
  this.current_request_id += 1;
  for (var i = 0; i < this.datasets.length; i++) {
    var stat_object = this
    var dataset = this.datasets[i];
    var request_id = this.current_request_id;
    pull_data(dataset.pull_data_url,
      {
        source: dataset.source,
        start_date: this.start_date,
        days: this.get_days_to_display().toString()
      }, i, function(data, status, jqXHR, indice) {
      dataset = stat_object.datasets[indice]
      dataset.retreived_data = data;

      if (stat_object.current_request_id == request_id) {
        line_chart_draw_data.call(stat_object, stat_object.datasets.indexOf(dataset));
      }
    });

  }
}

var line_chart_change_data_range = function(start_date, days_to_display) {
  this.start_date = start_date;
  this.days_to_display = days_to_display;
  this.clear_canvas();
  line_chart_draw_background.call(this);
  this.pull_data_and_draw();
}
var line_chart_go_back = function(days) {
  old = new Date(this.start_date);
  start = new Date(old.getFullYear(), old.getMonth(), old.getDate() - days, old.getHours(), old.getMinutes(), old.getSeconds(), old.getMilliseconds());
  this.change_data_range(start.toISOString().substring(0, 10), this.get_days_to_display())
}
var line_chart_go_forward = function(days) {
  old = new Date(this.start_date);
  start = new Date(old.getFullYear(), old.getMonth(), old.getDate() + days, old.getHours(), old.getMinutes(), old.getSeconds(), old.getMilliseconds());
  this.change_data_range(start.toISOString().substring(0, 10), this.get_days_to_display())
}

var line_chart_get_number_of_days = function() {
  var days = this.days_to_display;

  if (window.innerWidth <= 1000) {
    days = 15;
  }

  if (window.innerWidth <= 500) {
    days = 10;
  }

  return days;
}

/* General */

var pull_data = function(url, _data, indice, success_func) {
  $.ajax({
    dataType: "json",
    url: url,
    data: _data,
    success: function(data, status, jqXHR) {
      success_func(data, status, jqXHR, indice)
    }
  });
}

var stat_get_width = function() {
  var width = -1

  if (this.scale_type == "PERCENTAGE_X" || this.scale_type == "PERCENTAGE_XY") {
    var parent_node = this.canvas.parentNode
    width = $(parent_node).width() * (this.canvas_width / 100.0);
  } else {
    width = this.canvas_width;
  }

  return width;
}

var stat_get_height = function() {
  var height = -1

  if (this.scale_type == "PERCENTAGE_Y" || this.scale_type == "PERCENTAGE_XY") {
    var parent_node = this.canvas.parentNode
    height = $(parent_node).height() * (this.canvas_height / 100.0);
  } else {
    height = this.canvas_height;
  }

  return height;
}

var stat_clear_canvas = function () {
  var ctx = this.canvas.getContext("2d");
  ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
}

var stat_refresh_size = function() {
    this.canvas.width = this.get_width();
    this.canvas.height = this.get_height();
}

var initiate_chart = function(id, data) {
  stat_objects[id] = data;
  stat_objects_list.push(data);
  data.stat_id = id
  data.canvas = document.getElementById(id);

  data.get_width = stat_get_width;
  data.get_height = stat_get_height;
  data.refresh_size = stat_refresh_size;
  data.clear_canvas = stat_clear_canvas;

  if(!data.canvas.getContext) {
    data.canvas.innerHTML = "This browser does not support HTML5 canvases.";
  }

  /* Since there's a delay when drawing data, only data that is actually req-
     uested should be used. */
  data.current_request_id = -1;
}

/* Other */



/* Handle automatic resizing and refreshing of canvases */

$(window).bind('resize', function(){
  for (var i = 0; i < stat_objects_list.length; i++) {
    stat = stat_objects_list[i];
    stat.refresh_size();
    stat.draw();
  }
});

/* Draw everything once document is ready */

$(function() {
  for (var i = 0; i < stat_objects_list.length; i++) {
    stat = stat_objects_list[i];
    stat.refresh_size();
    stat.pull_data_and_draw()
  }
});
