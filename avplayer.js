/**
 * The AVPlayer Javascript Interface
 *
 *
 * @author     AlloVince <allo.vince@gmail.com>
 * @copyright  2008-2009 AVE7.NET
 * @license    GNU General Public License v3
 * @link       http://code.google.com/p/tsostplayer/
 */
function AvPlayer(B,_){var G=this;this.dir=B?B:"./";this.id=_?_:"avplayer";this.isIE=(navigator.userAgent.match(/MSIE/i));this.getDocument=function(){return(document.body?document.body:(document.documentElement?document.documentElement:document.getElementsByTagName("div")[0]))};this.container=document.getElementById("avplayer-container")?document.getElementById("avplayer-container"):document.createElement("div");this.melody="";this.lyric={};this.lrcline=0;this.playlist={};this.player=function(){return document.getElementById(G.id)};this._play=function($){G.player().avPlay($)};this._stop=function($){$=$>0?$:0;G.player().avStop($);G.lrcline=0};this._pause=function(){G.player().avPause()};this._status=function(){return G.player().avStatus()};this.playthis=function(A){if(G._status().isPlaying==false)return false;var _=$(A).attr("class");_=_.match(/\d+/);_=_[0];G._stop(_);G._play();$(".avplayLine_hilight").removeClass("avplayLine_hilight");$(A).addClass("avplayLine_hilight");$(".avplayLine:not(.avpLine_"+_+")").addClass("avplayLine_played");$(".avpLine_"+_+" ~ span").removeClass("avplayLine_played")};this.init=function(){if(window.addEventListener){window.addEventListener("load",G.creat,false);window.addEventListener("unload",G.destroy,false)}else if(window.attachEvent){window.attachEvent("onload",G.creat);window.attachEvent("onunload",G.destroy)}};this.creat=function(){var C="<embed name=\""+G.id+"\" id=\""+G.id+"\" src=\""+G.dir+"avplayer.swf\" width=\"100%\" height=\"100%\" quality=\"high\" allowScriptAccess=\"always\" quality=\"high\" bgcolor=\"#ffffff\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\"></embed>",$="<object id=\""+G.id+"\" data=\""+G.dir+"avplayer.swf\" type=\"application/x-shockwave-flash\" width=\"100%\" height=\"100%\"><param name=\"movie\" value=\""+B+"avplayer.swf\" /><param name=\"AllowScriptAccess\" value=\"always\" /><param name=\"quality\" value=\"high\" /><param name=\"bgcolor\" value=\"#ffffff\" /></object>",D=(!G.isIE?C:$),E=document.getElementsByTagName("head")[0],F=document.createElement("link");F.type="text/css";F.rel="stylesheet";F.href=G.dir+"avplayer.css";if(!G.container.id){G.container.id=G.id+"-container";var A={position:"fixed",width:"8px",height:"8px",bottom:"0px",left:"0px",zIndex:-1};for(var H in A)G.container.style[H]=A[H]}try{E.appendChild(F);G.getDocument().appendChild(G.container);G.container.innerHTML=D}catch(_){alert(_)}};this.destroy=function(){};this.addlist=function(){};this.removelist=function(){};this.href2list=function(_){_.addClass("avplayList");_.addClass("avplayList_wait");_.click(function(){var _=G._status();if(_.isPlaying==false&&_.played==0){G._play($(this).attr("href"));$("#"+G.lyric.id+" > span .avpLine_"+G.lyric.main[0].time).addClass("avplayLine_hilight");$(this).removeClass("avplayList_wait");$(this).removeClass("avplayList_pause");$(this).addClass("avplayList_now")}if(_.isPlaying==true&&_.played>0){G._stop(_.played);$(this).removeClass("avplayList_wait");$(this).removeClass("avplayList_now");$(this).addClass("avplayList_pause")}if(_.isPlaying==false&&_.played>0){G._play();$(this).removeClass("avplayList_wait");$(this).removeClass("avplayList_pause");$(this).addClass("avplayList_now")}return false})};function F($){return $.replace(/(^\s*)|(\s*$)/g,"")}function E(C){var A=C.split("."),_=0;try{var B=A[0].split(":");_+=parseInt(B[B.length-1],10)*1000;if(B.length>1)_+=parseInt(B[B.length-2],10)*60000;if(B.length>2)_+=parseInt(B[B.length-3],10)*3600000;if(A.length>1)if(A[1].length==1)_+=parseInt(A[1],10)*100;else if(A[1].length==2)_+=parseInt(A[1],10)*10;else if(A[1].length==3)_+=parseInt(A[1],10)*1;return _}catch($){return 0}}function D($){$=$.match(/^\[([0-9:\.]+)\](.*)$/);return $==null?false:{time:E($[1]),content:$[2]}}function A(B){var _=new Array();B=B.split(/\n/g);for(var I=0;I<4;I++){B[I]=F(B[I]);var C=B[I].match(/\[([(ti)|(ar)|(al)|(by):])(.*)\]/ig);if(C==null)break;else switch(C[0].substr(1,2)){case"ti":var $=C[0].substr(4,C[0].length-5);break;case"ar":var G=C[0].substr(4,C[0].length-5);break;case"al":var A=C[0].substr(4,C[0].length-5);break;case"by":var E=C[0].substr(4,C[0].length-5);break;default:}}var H=0;for(I=0;I<B.length;I++){B[I]=F(B[I]);C=D(B[I]);if(C){_[H]=C;H++}}return{title:$,artist:G,album:A,by:E,main:_}}function C(_){var $="";for(var A=0;A<_.length;A++)$+="<p class=\"avplayLine avpLine_"+_[A].time+"\" onclick=\"avp.playthis(this);\">"+_[A].content+"</p>\n";return $}this.initlrc=function(_){G.lyric=A(_.html());var $="avLrc"+Math.floor(Math.random()*10000);G.lyric.id=$;_.replaceWith("<div id=\""+$+"\" class = \"avplayLrcCase\">"+C(G.lyric.main)+"</div>")};this.addlyc=function(){};this.removelyc=function(){};this.EnterFrame=function(A){var _=false;if(A<G.lyric.main[G.lrcline].time){if(_==false){var B=G.lrcline-1>=0?G.lrcline-1:0;$(".avpLine_"+G.lyric.main[B].time).addClass("avplayLine_hilight");G.lrcline>0?$(".avpLine_"+G.lyric.main[B-1].time).removeClass("avplayLine_hilight").addClass("avplayLine_played"):""}}else{_=true;G.lrcline++}};this.IoError=function(){$(".avplayList_now").removeClass("avplayList_now").addClass("avplayList_error");$(".avplayLine_hilight").removeClass("avplayLine_hilight")};this.PlayComplete=function(){$(".avplayList_now").removeClass("avplayList_now").addClass("avplayList_wait");$(".avplayLine_hilight").removeClass("avplayLine_hilight");$(".avplayLine_played").removeClass("avplayLine_played")};G.init();$("a[href$='.mp3']").each(function(){G.href2list($(this))});$("pre[class='lrc']").each(function(){G.initlrc($(this))})}