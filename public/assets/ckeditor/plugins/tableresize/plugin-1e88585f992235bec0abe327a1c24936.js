/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){function e(e){return CKEDITOR.env.ie?e.$.clientWidth:parseInt(e.getComputedStyle("width"),10)}function t(e,t){var i=e.getComputedStyle("border-"+t+"-width"),a={thin:"0px",medium:"1px",thick:"2px"};return i.indexOf("px")<0&&(i=i in a&&"none"!=e.getComputedStyle("border-style")?a[i]:0),parseInt(i,10)}function i(e){for(var t,i,a,n=e.$.rows,o=0,r=0,s=n.length;s>r;r++)a=n[r],t=a.cells.length,t>o&&(o=t,i=a);return i}function a(e){for(var a=[],n=-1,o="rtl"==e.getComputedStyle("direction"),r=i(e),s=new CKEDITOR.dom.element(e.$.tBodies[0]),l=s.getDocumentPosition(),d=0,c=r.cells.length;c>d;d++){var u=new CKEDITOR.dom.element(r.cells[d]),h=r.cells[d+1]&&new CKEDITOR.dom.element(r.cells[d+1]);n+=u.$.colSpan||1;var p,m,g,f=u.getDocumentPosition().x;o?m=f+t(u,"left"):p=f+u.$.offsetWidth-t(u,"right"),h?(f=h.getDocumentPosition().x,o?p=f+h.$.offsetWidth-t(h,"right"):m=f+t(h,"left")):(f=e.getDocumentPosition().x,o?p=f:m=f+e.$.offsetWidth),g=Math.max(m-p,3),a.push({table:e,index:n,x:p,y:l.y,width:g,height:s.$.offsetHeight,rtl:o})}return a}function n(e,t){for(var i=0,a=e.length;a>i;i++){var n=e[i];if(t>=n.x&&t<=n.x+n.width)return n}return null}function o(e){(e.data||e).preventDefault()}function r(i){function a(){p=null,b=0,f=0,m.removeListener("mouseup",u),g.removeListener("mousedown",c),g.removeListener("mousemove",h),m.getBody().setStyle("cursor","auto"),d?g.remove():g.hide()}function n(){for(var t=p.index,i=CKEDITOR.tools.buildTableMap(p.table),a=[],n=[],r=Number.MAX_VALUE,s=r,l=p.rtl,d=0,c=i.length;c>d;d++){var u=i[d],T=u[t+(l?1:0)],S=u[t+(l?0:1)];T=T&&new CKEDITOR.dom.element(T),S=S&&new CKEDITOR.dom.element(S),T&&S&&T.equals(S)||(T&&(r=Math.min(r,e(T))),S&&(s=Math.min(s,e(S))),a.push(T),n.push(S))}y=a,k=n,w=p.x-r,C=p.x+s,g.setOpacity(.5),v=parseInt(g.getStyle("left"),10),b=0,f=1,g.on("mousemove",h),m.on("dragstart",o)}function r(){f=0,g.setOpacity(0),b&&s();var e=p.table;setTimeout(function(){e.removeCustomData("_cke_table_pillars")},0),m.removeListener("dragstart",o)}function s(){for(var i=p.rtl,a=i?k.length:y.length,n=0;a>n;n++){var o=y[n],r=k[n],s=p.table;CKEDITOR.tools.setTimeout(function(e,t,a,n,o,r){e&&e.setStyle("width",l(Math.max(t+r,0))),a&&a.setStyle("width",l(Math.max(n-r,0))),o&&s.setStyle("width",l(o+r*(i?-1:1)))},0,this,[o,o&&e(o),r,r&&e(r),(!o||!r)&&e(s)+t(s,"left")+t(s,"right"),b])}}function c(e){o(e),n(),m.on("mouseup",u,this)}function u(e){e.removeListener(),r()}function h(e){T(e.data.$.clientX)}var p,m,g,f,v,b,y,k,w,C;m=i.document,g=CKEDITOR.dom.element.createFromHtml('<div data-cke-temp=1 contenteditable=false unselectable=on style="position:absolute;cursor:col-resize;filter:alpha(opacity=0);opacity:0;padding:0;background-color:#004;background-image:none;border:0px none;z-index:10"></div>',m),d||m.getDocumentElement().append(g),this.attachTo=function(e){f||(d&&(m.getBody().append(g),b=0),p=e,g.setStyles({width:l(e.width),height:l(e.height),left:l(e.x),top:l(e.y)}),d&&g.setOpacity(.25),g.on("mousedown",c,this),m.getBody().setStyle("cursor","col-resize"),g.show())};var T=this.move=function(e){if(!p)return 0;if(!f&&(e<p.x||e>p.x+p.width))return a(),0;var t=e-Math.round(g.$.offsetWidth/2);if(f){if(t==w||t==C)return 1;t=Math.max(t,w),t=Math.min(t,C),b=t-v}return g.setStyle("left",l(t)),1}}function s(e){var t=e.data.getTarget();if("mouseout"==e.name){if(!t.is("table"))return;for(var i=new CKEDITOR.dom.element(e.data.$.relatedTarget||e.data.$.toElement);i&&i.$&&!i.equals(t)&&!i.is("body");)i=i.getParent();if(!i||i.equals(t))return}t.getAscendant("table",1).removeCustomData("_cke_table_pillars"),e.removeListener()}var l=CKEDITOR.tools.cssLength,d=CKEDITOR.env.ie&&(CKEDITOR.env.ie7Compat||CKEDITOR.env.quirks||CKEDITOR.env.version<7);CKEDITOR.plugins.add("tableresize",{requires:["tabletools"],init:function(e){e.on("contentDom",function(){var t;e.document.getBody().on("mousemove",function(i){if(i=i.data,t&&t.move(i.$.clientX))return o(i),void 0;var l,d,c=i.getTarget();if(c.is("table")||c.getAscendant("tbody",1)){l=c.getAscendant("table",1),(d=l.getCustomData("_cke_table_pillars"))||(l.setCustomData("_cke_table_pillars",d=a(l)),l.on("mouseout",s),l.on("mousedown",s));var u=n(d,i.$.clientX);u&&(!t&&(t=new r(e)),t.attachTo(u))}})})}})}();