/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
window.CKEDITOR||(window.CKEDITOR=function(){var e={timestamp:"",version:"3.6.4",revision:"7575",rnd:Math.floor(900*Math.random())+100,_:{},status:"unloaded",basePath:function(){var e=window.CKEDITOR_BASEPATH||"";if(!e)for(var t=document.getElementsByTagName("script"),i=0;i<t.length;i++){var n=t[i].src.match(/(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/i);if(n){e=n[1];break}}if(-1==e.indexOf(":/")&&(e=0===e.indexOf("/")?location.href.match(/^.*?:\/\/[^\/]*/)[0]+e:location.href.match(/^[^\?]*\/(?:)/)[0]+e),!e)throw'The CKEditor installation path could not be automatically detected. Please set the global variable "CKEDITOR_BASEPATH" before creating editor instances.';return e}(),getUrl:function(e){return-1==e.indexOf(":/")&&0!==e.indexOf("/")&&(e=this.basePath+e),this.timestamp&&"/"!=e.charAt(e.length-1)&&!/[&?]t=/.test(e)&&(e+=(e.indexOf("?")>=0?"&":"?")+"t="+this.timestamp),e}},t=window.CKEDITOR_GETURL;if(t){var i=e.getUrl;e.getUrl=function(n){return t.call(e,n)||i.call(e,n)}}return e}()),CKEDITOR._autoLoad="core/ckeditor_basic",document.write('<script type="text/javascript" src="'+CKEDITOR.getUrl("_source/core/loader.js")+'"></script>');