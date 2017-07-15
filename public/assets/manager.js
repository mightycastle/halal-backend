/*!
 * jQuery Form Plugin
 * version: 3.51.0-2014.06.20
 * Requires jQuery v1.5 or later
 * Copyright (c) 2014 M. Alsup
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Project repository: https://github.com/malsup/form
 * Dual licensed under the MIT and GPL licenses.
 * https://github.com/malsup/form#copyright-and-license
 */


!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery"],e):e("undefined"!=typeof jQuery?jQuery:window.Zepto)}(function(e){"use strict";function t(t){var r=t.data;t.isDefaultPrevented()||(t.preventDefault(),e(t.target).ajaxSubmit(r))}function r(t){var r=t.target,a=e(r);if(!a.is("[type=submit],[type=image]")){var n=a.closest("[type=submit]");if(0===n.length)return;r=n[0]}var i=this;if(i.clk=r,"image"==r.type)if(void 0!==t.offsetX)i.clk_x=t.offsetX,i.clk_y=t.offsetY;else if("function"==typeof e.fn.offset){var o=a.offset();i.clk_x=t.pageX-o.left,i.clk_y=t.pageY-o.top}else i.clk_x=t.pageX-r.offsetLeft,i.clk_y=t.pageY-r.offsetTop;setTimeout(function(){i.clk=i.clk_x=i.clk_y=null},100)}function a(){if(e.fn.ajaxSubmit.debug){var t="[jquery.form] "+Array.prototype.join.call(arguments,"");window.console&&window.console.log?window.console.log(t):window.opera&&window.opera.postError&&window.opera.postError(t)}}var n={};n.fileapi=void 0!==e("<input type='file'/>").get(0).files,n.formdata=void 0!==window.FormData;var i=!!e.fn.prop;e.fn.attr2=function(){if(!i)return this.attr.apply(this,arguments);var e=this.prop.apply(this,arguments);return e&&e.jquery||"string"==typeof e?e:this.attr.apply(this,arguments)},e.fn.ajaxSubmit=function(t){function r(r){var a,n,i=e.param(r,t.traditional).split("&"),o=i.length,s=[];for(a=0;o>a;a++)i[a]=i[a].replace(/\+/g," "),n=i[a].split("="),s.push([decodeURIComponent(n[0]),decodeURIComponent(n[1])]);return s}function o(a){for(var n=new FormData,i=0;i<a.length;i++)n.append(a[i].name,a[i].value);if(t.extraData){var o=r(t.extraData);for(i=0;i<o.length;i++)o[i]&&n.append(o[i][0],o[i][1])}t.data=null;var s=e.extend(!0,{},e.ajaxSettings,t,{contentType:!1,processData:!1,cache:!1,type:u||"POST"});t.uploadProgress&&(s.xhr=function(){var r=e.ajaxSettings.xhr();return r.upload&&r.upload.addEventListener("progress",function(e){var r=0,a=e.loaded||e.position,n=e.total;e.lengthComputable&&(r=Math.ceil(a/n*100)),t.uploadProgress(e,a,n,r)},!1),r}),s.data=null;var c=s.beforeSend;return s.beforeSend=function(e,r){r.data=t.formData?t.formData:n,c&&c.call(this,e,r)},e.ajax(s)}function s(r){function n(e){var t=null;try{e.contentWindow&&(t=e.contentWindow.document)}catch(r){a("cannot get iframe.contentWindow document: "+r)}if(t)return t;try{t=e.contentDocument?e.contentDocument:e.document}catch(r){a("cannot get iframe.contentDocument: "+r),t=e.document}return t}function o(){function t(){try{var e=n(g).readyState;a("state = "+e),e&&"uninitialized"==e.toLowerCase()&&setTimeout(t,50)}catch(r){a("Server abort: ",r," (",r.name,")"),s(k),j&&clearTimeout(j),j=void 0}}var r=f.attr2("target"),i=f.attr2("action"),o="multipart/form-data",c=f.attr("enctype")||f.attr("encoding")||o;w.setAttribute("target",p),(!u||/post/i.test(u))&&w.setAttribute("method","POST"),i!=m.url&&w.setAttribute("action",m.url),m.skipEncodingOverride||u&&!/post/i.test(u)||f.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"}),m.timeout&&(j=setTimeout(function(){T=!0,s(D)},m.timeout));var l=[];try{if(m.extraData)for(var d in m.extraData)m.extraData.hasOwnProperty(d)&&l.push(e.isPlainObject(m.extraData[d])&&m.extraData[d].hasOwnProperty("name")&&m.extraData[d].hasOwnProperty("value")?e('<input type="hidden" name="'+m.extraData[d].name+'">').val(m.extraData[d].value).appendTo(w)[0]:e('<input type="hidden" name="'+d+'">').val(m.extraData[d]).appendTo(w)[0]);m.iframeTarget||v.appendTo("body"),g.attachEvent?g.attachEvent("onload",s):g.addEventListener("load",s,!1),setTimeout(t,15);try{w.submit()}catch(h){var x=document.createElement("form").submit;x.apply(w)}}finally{w.setAttribute("action",i),w.setAttribute("enctype",c),r?w.setAttribute("target",r):f.removeAttr("target"),e(l).remove()}}function s(t){if(!x.aborted&&!F){if(M=n(g),M||(a("cannot access response document"),t=k),t===D&&x)return x.abort("timeout"),void S.reject(x,"timeout");if(t==k&&x)return x.abort("server abort"),void S.reject(x,"error","server abort");if(M&&M.location.href!=m.iframeSrc||T){g.detachEvent?g.detachEvent("onload",s):g.removeEventListener("load",s,!1);var r,i="success";try{if(T)throw"timeout";var o="xml"==m.dataType||M.XMLDocument||e.isXMLDoc(M);if(a("isXml="+o),!o&&window.opera&&(null===M.body||!M.body.innerHTML)&&--O)return a("requeing onLoad callback, DOM not available"),void setTimeout(s,250);var u=M.body?M.body:M.documentElement;x.responseText=u?u.innerHTML:null,x.responseXML=M.XMLDocument?M.XMLDocument:M,o&&(m.dataType="xml"),x.getResponseHeader=function(e){var t={"content-type":m.dataType};return t[e.toLowerCase()]},u&&(x.status=Number(u.getAttribute("status"))||x.status,x.statusText=u.getAttribute("statusText")||x.statusText);var c=(m.dataType||"").toLowerCase(),l=/(json|script|text)/.test(c);if(l||m.textarea){var f=M.getElementsByTagName("textarea")[0];if(f)x.responseText=f.value,x.status=Number(f.getAttribute("status"))||x.status,x.statusText=f.getAttribute("statusText")||x.statusText;else if(l){var p=M.getElementsByTagName("pre")[0],h=M.getElementsByTagName("body")[0];p?x.responseText=p.textContent?p.textContent:p.innerText:h&&(x.responseText=h.textContent?h.textContent:h.innerText)}}else"xml"==c&&!x.responseXML&&x.responseText&&(x.responseXML=X(x.responseText));try{E=_(x,c,m)}catch(y){i="parsererror",x.error=r=y||i}}catch(y){a("error caught: ",y),i="error",x.error=r=y||i}x.aborted&&(a("upload aborted"),i=null),x.status&&(i=x.status>=200&&x.status<300||304===x.status?"success":"error"),"success"===i?(m.success&&m.success.call(m.context,E,"success",x),S.resolve(x.responseText,"success",x),d&&e.event.trigger("ajaxSuccess",[x,m])):i&&(void 0===r&&(r=x.statusText),m.error&&m.error.call(m.context,x,i,r),S.reject(x,"error",r),d&&e.event.trigger("ajaxError",[x,m,r])),d&&e.event.trigger("ajaxComplete",[x,m]),d&&!--e.active&&e.event.trigger("ajaxStop"),m.complete&&m.complete.call(m.context,x,i),F=!0,m.timeout&&clearTimeout(j),setTimeout(function(){m.iframeTarget?v.attr("src",m.iframeSrc):v.remove(),x.responseXML=null},100)}}}var c,l,m,d,p,v,g,x,y,b,T,j,w=f[0],S=e.Deferred();if(S.abort=function(e){x.abort(e)},r)for(l=0;l<h.length;l++)c=e(h[l]),i?c.prop("disabled",!1):c.removeAttr("disabled");if(m=e.extend(!0,{},e.ajaxSettings,t),m.context=m.context||m,p="jqFormIO"+(new Date).getTime(),m.iframeTarget?(v=e(m.iframeTarget),b=v.attr2("name"),b?p=b:v.attr2("name",p)):(v=e('<iframe name="'+p+'" src="'+m.iframeSrc+'" />'),v.css({position:"absolute",top:"-1000px",left:"-1000px"})),g=v[0],x={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(t){var r="timeout"===t?"timeout":"aborted";a("aborting upload... "+r),this.aborted=1;try{g.contentWindow.document.execCommand&&g.contentWindow.document.execCommand("Stop")}catch(n){}v.attr("src",m.iframeSrc),x.error=r,m.error&&m.error.call(m.context,x,r,t),d&&e.event.trigger("ajaxError",[x,m,r]),m.complete&&m.complete.call(m.context,x,r)}},d=m.global,d&&0===e.active++&&e.event.trigger("ajaxStart"),d&&e.event.trigger("ajaxSend",[x,m]),m.beforeSend&&m.beforeSend.call(m.context,x,m)===!1)return m.global&&e.active--,S.reject(),S;if(x.aborted)return S.reject(),S;y=w.clk,y&&(b=y.name,b&&!y.disabled&&(m.extraData=m.extraData||{},m.extraData[b]=y.value,"image"==y.type&&(m.extraData[b+".x"]=w.clk_x,m.extraData[b+".y"]=w.clk_y)));var D=1,k=2,A=e("meta[name=csrf-token]").attr("content"),L=e("meta[name=csrf-param]").attr("content");L&&A&&(m.extraData=m.extraData||{},m.extraData[L]=A),m.forceSync?o():setTimeout(o,10);var E,M,F,O=50,X=e.parseXML||function(e,t){return window.ActiveXObject?(t=new ActiveXObject("Microsoft.XMLDOM"),t.async="false",t.loadXML(e)):t=(new DOMParser).parseFromString(e,"text/xml"),t&&t.documentElement&&"parsererror"!=t.documentElement.nodeName?t:null},C=e.parseJSON||function(e){return window.eval("("+e+")")},_=function(t,r,a){var n=t.getResponseHeader("content-type")||"",i="xml"===r||!r&&n.indexOf("xml")>=0,o=i?t.responseXML:t.responseText;return i&&"parsererror"===o.documentElement.nodeName&&e.error&&e.error("parsererror"),a&&a.dataFilter&&(o=a.dataFilter(o,r)),"string"==typeof o&&("json"===r||!r&&n.indexOf("json")>=0?o=C(o):("script"===r||!r&&n.indexOf("javascript")>=0)&&e.globalEval(o)),o};return S}if(!this.length)return a("ajaxSubmit: skipping submit process - no element selected"),this;var u,c,l,f=this;"function"==typeof t?t={success:t}:void 0===t&&(t={}),u=t.type||this.attr2("method"),c=t.url||this.attr2("action"),l="string"==typeof c?e.trim(c):"",l=l||window.location.href||"",l&&(l=(l.match(/^([^#]+)/)||[])[1]),t=e.extend(!0,{url:l,success:e.ajaxSettings.success,type:u||e.ajaxSettings.type,iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},t);var m={};if(this.trigger("form-pre-serialize",[this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-pre-serialize trigger"),this;if(t.beforeSerialize&&t.beforeSerialize(this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSerialize callback"),this;var d=t.traditional;void 0===d&&(d=e.ajaxSettings.traditional);var p,h=[],v=this.formToArray(t.semantic,h);if(t.data&&(t.extraData=t.data,p=e.param(t.data,d)),t.beforeSubmit&&t.beforeSubmit(v,this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSubmit callback"),this;if(this.trigger("form-submit-validate",[v,this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-submit-validate trigger"),this;var g=e.param(v,d);p&&(g=g?g+"&"+p:p),"GET"==t.type.toUpperCase()?(t.url+=(t.url.indexOf("?")>=0?"&":"?")+g,t.data=null):t.data=g;var x=[];if(t.resetForm&&x.push(function(){f.resetForm()}),t.clearForm&&x.push(function(){f.clearForm(t.includeHidden)}),!t.dataType&&t.target){var y=t.success||function(){};x.push(function(r){var a=t.replaceTarget?"replaceWith":"html";e(t.target)[a](r).each(y,arguments)})}else t.success&&x.push(t.success);if(t.success=function(e,r,a){for(var n=t.context||this,i=0,o=x.length;o>i;i++)x[i].apply(n,[e,r,a||f,f])},t.error){var b=t.error;t.error=function(e,r,a){var n=t.context||this;b.apply(n,[e,r,a,f])}}if(t.complete){var T=t.complete;t.complete=function(e,r){var a=t.context||this;T.apply(a,[e,r,f])}}var j=e("input[type=file]:enabled",this).filter(function(){return""!==e(this).val()}),w=j.length>0,S="multipart/form-data",D=f.attr("enctype")==S||f.attr("encoding")==S,k=n.fileapi&&n.formdata;a("fileAPI :"+k);var A,L=(w||D)&&!k;t.iframe!==!1&&(t.iframe||L)?t.closeKeepAlive?e.get(t.closeKeepAlive,function(){A=s(v)}):A=s(v):A=(w||D)&&k?o(v):e.ajax(t),f.removeData("jqxhr").data("jqxhr",A);for(var E=0;E<h.length;E++)h[E]=null;return this.trigger("form-submit-notify",[this,t]),this},e.fn.ajaxForm=function(n){if(n=n||{},n.delegation=n.delegation&&e.isFunction(e.fn.on),!n.delegation&&0===this.length){var i={s:this.selector,c:this.context};return!e.isReady&&i.s?(a("DOM not ready, queuing ajaxForm"),e(function(){e(i.s,i.c).ajaxForm(n)}),this):(a("terminating; zero elements found by selector"+(e.isReady?"":" (DOM not ready)")),this)}return n.delegation?(e(document).off("submit.form-plugin",this.selector,t).off("click.form-plugin",this.selector,r).on("submit.form-plugin",this.selector,n,t).on("click.form-plugin",this.selector,n,r),this):this.ajaxFormUnbind().bind("submit.form-plugin",n,t).bind("click.form-plugin",n,r)},e.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")},e.fn.formToArray=function(t,r){var a=[];if(0===this.length)return a;var i,o=this[0],s=this.attr("id"),u=t?o.getElementsByTagName("*"):o.elements;if(u&&!/MSIE [678]/.test(navigator.userAgent)&&(u=e(u).get()),s&&(i=e(':input[form="'+s+'"]').get(),i.length&&(u=(u||[]).concat(i))),!u||!u.length)return a;var c,l,f,m,d,p,h;for(c=0,p=u.length;p>c;c++)if(d=u[c],f=d.name,f&&!d.disabled)if(t&&o.clk&&"image"==d.type)o.clk==d&&(a.push({name:f,value:e(d).val(),type:d.type}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}));else if(m=e.fieldValue(d,!0),m&&m.constructor==Array)for(r&&r.push(d),l=0,h=m.length;h>l;l++)a.push({name:f,value:m[l]});else if(n.fileapi&&"file"==d.type){r&&r.push(d);var v=d.files;if(v.length)for(l=0;l<v.length;l++)a.push({name:f,value:v[l],type:d.type});else a.push({name:f,value:"",type:d.type})}else null!==m&&"undefined"!=typeof m&&(r&&r.push(d),a.push({name:f,value:m,type:d.type,required:d.required}));if(!t&&o.clk){var g=e(o.clk),x=g[0];f=x.name,f&&!x.disabled&&"image"==x.type&&(a.push({name:f,value:g.val()}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}))}return a},e.fn.formSerialize=function(t){return e.param(this.formToArray(t))},e.fn.fieldSerialize=function(t){var r=[];return this.each(function(){var a=this.name;if(a){var n=e.fieldValue(this,t);if(n&&n.constructor==Array)for(var i=0,o=n.length;o>i;i++)r.push({name:a,value:n[i]});else null!==n&&"undefined"!=typeof n&&r.push({name:this.name,value:n})}}),e.param(r)},e.fn.fieldValue=function(t){for(var r=[],a=0,n=this.length;n>a;a++){var i=this[a],o=e.fieldValue(i,t);null===o||"undefined"==typeof o||o.constructor==Array&&!o.length||(o.constructor==Array?e.merge(r,o):r.push(o))}return r},e.fieldValue=function(t,r){var a=t.name,n=t.type,i=t.tagName.toLowerCase();if(void 0===r&&(r=!0),r&&(!a||t.disabled||"reset"==n||"button"==n||("checkbox"==n||"radio"==n)&&!t.checked||("submit"==n||"image"==n)&&t.form&&t.form.clk!=t||"select"==i&&-1==t.selectedIndex))return null;if("select"==i){var o=t.selectedIndex;if(0>o)return null;for(var s=[],u=t.options,c="select-one"==n,l=c?o+1:u.length,f=c?o:0;l>f;f++){var m=u[f];if(m.selected){var d=m.value;if(d||(d=m.attributes&&m.attributes.value&&!m.attributes.value.specified?m.text:m.value),c)return d;s.push(d)}}return s}return e(t).val()},e.fn.clearForm=function(t){return this.each(function(){e("input,select,textarea",this).clearFields(t)})},e.fn.clearFields=e.fn.clearInputs=function(t){var r=/^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i;return this.each(function(){var a=this.type,n=this.tagName.toLowerCase();r.test(a)||"textarea"==n?this.value="":"checkbox"==a||"radio"==a?this.checked=!1:"select"==n?this.selectedIndex=-1:"file"==a?/MSIE/.test(navigator.userAgent)?e(this).replaceWith(e(this).clone(!0)):e(this).val(""):t&&(t===!0&&/hidden/.test(a)||"string"==typeof t&&e(this).is(t))&&(this.value="")})},e.fn.resetForm=function(){return this.each(function(){("function"==typeof this.reset||"object"==typeof this.reset&&!this.reset.nodeType)&&this.reset()})},e.fn.enable=function(e){return void 0===e&&(e=!0),this.each(function(){this.disabled=!e})},e.fn.selected=function(t){return void 0===t&&(t=!0),this.each(function(){var r=this.type;if("checkbox"==r||"radio"==r)this.checked=t;else if("option"==this.tagName.toLowerCase()){var a=e(this).parent("select");t&&a[0]&&"select-one"==a[0].type&&a.find("option").selected(!1),this.selected=t}})},e.fn.ajaxSubmit.debug=!1});
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
