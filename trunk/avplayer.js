<!--
String.prototype.trim= function(){  
	return this.replace(/(^\s*)|(\s*$)/g, "");  
}

function avpInit(dir){
	var swfobject=function(){var b="undefined",Q="object",n="Shockwave Flash",p="ShockwaveFlash.ShockwaveFlash",P="application/x-shockwave-flash",m="SWFObjectExprInst",j=window,K=document,T=navigator,o=[],N=[],i=[],d=[],J,Z=null,M=null,l=null,e=false,A=false;var h=function(){var v=typeof K.getElementById!=b&&typeof K.getElementsByTagName!=b&&typeof K.createElement!=b,AC=[0,0,0],x=null;if(typeof T.plugins!=b&&typeof T.plugins[n]==Q){x=T.plugins[n].description;if(x&&!(typeof T.mimeTypes!=b&&T.mimeTypes[P]&&!T.mimeTypes[P].enabledPlugin)){x=x.replace(/^.*\s+(\S+\s+\S+$)/,"$1");AC[0]=parseInt(x.replace(/^(.*)\..*$/,"$1"),10);AC[1]=parseInt(x.replace(/^.*\.(.*)\s.*$/,"$1"),10);AC[2]=/r/.test(x)?parseInt(x.replace(/^.*r(.*)$/,"$1"),10):0}}else{if(typeof j.ActiveXObject!=b){var y=null,AB=false;try{y=new ActiveXObject(p+".7")}catch(t){try{y=new ActiveXObject(p+".6");AC=[6,0,21];y.AllowScriptAccess="always"}catch(t){if(AC[0]==6){AB=true}}if(!AB){try{y=new ActiveXObject(p)}catch(t){}}}if(!AB&&y){try{x=y.GetVariable("$version");if(x){x=x.split(" ")[1].split(",");AC=[parseInt(x[0],10),parseInt(x[1],10),parseInt(x[2],10)]}}catch(t){}}}}var AD=T.userAgent.toLowerCase(),r=T.platform.toLowerCase(),AA=/webkit/.test(AD)?parseFloat(AD.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")):false,q=false,z=r?/win/.test(r):/win/.test(AD),w=r?/mac/.test(r):/mac/.test(AD);/*@cc_on q=true;@if(@_win32)z=true;@elif(@_mac)w=true;@end@*/return{w3cdom:v,pv:AC,webkit:AA,ie:q,win:z,mac:w}}();var L=function(){if(!h.w3cdom){return }f(H);if(h.ie&&h.win){try{K.write("<script id=__ie_ondomload defer=true src=//:><\/script>");J=C("__ie_ondomload");if(J){I(J,"onreadystatechange",S)}}catch(q){}}if(h.webkit&&typeof K.readyState!=b){Z=setInterval(function(){if(/loaded|complete/.test(K.readyState)){E()}},10)}if(typeof K.addEventListener!=b){K.addEventListener("DOMContentLoaded",E,null)}R(E)}();function S(){if(J.readyState=="complete"){J.parentNode.removeChild(J);E()}}function E(){if(e){return }if(h.ie&&h.win){var v=a("span");try{var u=K.getElementsByTagName("body")[0].appendChild(v);u.parentNode.removeChild(u)}catch(w){return }}e=true;if(Z){clearInterval(Z);Z=null}var q=o.length;for(var r=0;r<q;r++){o[r]()}}function f(q){if(e){q()}else{o[o.length]=q}}function R(r){if(typeof j.addEventListener!=b){j.addEventListener("load",r,false)}else{if(typeof K.addEventListener!=b){K.addEventListener("load",r,false)}else{if(typeof j.attachEvent!=b){I(j,"onload",r)}else{if(typeof j.onload=="function"){var q=j.onload;j.onload=function(){q();r()}}else{j.onload=r}}}}}function H(){var t=N.length;for(var q=0;q<t;q++){var u=N[q].id;if(h.pv[0]>0){var r=C(u);if(r){N[q].width=r.getAttribute("width")?r.getAttribute("width"):"0";N[q].height=r.getAttribute("height")?r.getAttribute("height"):"0";if(c(N[q].swfVersion)){if(h.webkit&&h.webkit<312){Y(r)}W(u,true)}else{if(N[q].expressInstall&&!A&&c("6.0.65")&&(h.win||h.mac)){k(N[q])}else{O(r)}}}}else{W(u,true)}}}function Y(t){var q=t.getElementsByTagName(Q)[0];if(q){var w=a("embed"),y=q.attributes;if(y){var v=y.length;for(var u=0;u<v;u++){if(y[u].nodeName=="DATA"){w.setAttribute("src",y[u].nodeValue)}else{w.setAttribute(y[u].nodeName,y[u].nodeValue)}}}var x=q.childNodes;if(x){var z=x.length;for(var r=0;r<z;r++){if(x[r].nodeType==1&&x[r].nodeName=="PARAM"){w.setAttribute(x[r].getAttribute("name"),x[r].getAttribute("value"))}}}t.parentNode.replaceChild(w,t)}}function k(w){A=true;var u=C(w.id);if(u){if(w.altContentId){var y=C(w.altContentId);if(y){M=y;l=w.altContentId}}else{M=G(u)}if(!(/%$/.test(w.width))&&parseInt(w.width,10)<310){w.width="310"}if(!(/%$/.test(w.height))&&parseInt(w.height,10)<137){w.height="137"}K.title=K.title.slice(0,47)+" - Flash Player Installation";var z=h.ie&&h.win?"ActiveX":"PlugIn",q=K.title,r="MMredirectURL="+j.location+"&MMplayerType="+z+"&MMdoctitle="+q,x=w.id;if(h.ie&&h.win&&u.readyState!=4){var t=a("div");x+="SWFObjectNew";t.setAttribute("id",x);u.parentNode.insertBefore(t,u);u.style.display="none";var v=function(){u.parentNode.removeChild(u)};I(j,"onload",v)}U({data:w.expressInstall,id:m,width:w.width,height:w.height},{flashvars:r},x)}}function O(t){if(h.ie&&h.win&&t.readyState!=4){var r=a("div");t.parentNode.insertBefore(r,t);r.parentNode.replaceChild(G(t),r);t.style.display="none";var q=function(){t.parentNode.removeChild(t)};I(j,"onload",q)}else{t.parentNode.replaceChild(G(t),t)}}function G(v){var u=a("div");if(h.win&&h.ie){u.innerHTML=v.innerHTML}else{var r=v.getElementsByTagName(Q)[0];if(r){var w=r.childNodes;if(w){var q=w.length;for(var t=0;t<q;t++){if(!(w[t].nodeType==1&&w[t].nodeName=="PARAM")&&!(w[t].nodeType==8)){u.appendChild(w[t].cloneNode(true))}}}}}return u}function U(AG,AE,t){var q,v=C(t);if(v){if(typeof AG.id==b){AG.id=t}if(h.ie&&h.win){var AF="";for(var AB in AG){if(AG[AB]!=Object.prototype[AB]){if(AB.toLowerCase()=="data"){AE.movie=AG[AB]}else{if(AB.toLowerCase()=="styleclass"){AF+=' class="'+AG[AB]+'"'}else{if(AB.toLowerCase()!="classid"){AF+=" "+AB+'="'+AG[AB]+'"'}}}}}var AD="";for(var AA in AE){if(AE[AA]!=Object.prototype[AA]){AD+='<param name="'+AA+'" value="'+AE[AA]+'" />'}}v.outerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'+AF+">"+AD+"</object>";i[i.length]=AG.id;q=C(AG.id)}else{if(h.webkit&&h.webkit<312){var AC=a("embed");AC.setAttribute("type",P);for(var z in AG){if(AG[z]!=Object.prototype[z]){if(z.toLowerCase()=="data"){AC.setAttribute("src",AG[z])}else{if(z.toLowerCase()=="styleclass"){AC.setAttribute("class",AG[z])}else{if(z.toLowerCase()!="classid"){AC.setAttribute(z,AG[z])}}}}}for(var y in AE){if(AE[y]!=Object.prototype[y]){if(y.toLowerCase()!="movie"){AC.setAttribute(y,AE[y])}}}v.parentNode.replaceChild(AC,v);q=AC}else{var u=a(Q);u.setAttribute("type",P);for(var x in AG){if(AG[x]!=Object.prototype[x]){if(x.toLowerCase()=="styleclass"){u.setAttribute("class",AG[x])}else{if(x.toLowerCase()!="classid"){u.setAttribute(x,AG[x])}}}}for(var w in AE){if(AE[w]!=Object.prototype[w]&&w.toLowerCase()!="movie"){F(u,w,AE[w])}}v.parentNode.replaceChild(u,v);q=u}}}return q}function F(t,q,r){var u=a("param");u.setAttribute("name",q);u.setAttribute("value",r);t.appendChild(u)}function X(r){var q=C(r);if(q&&(q.nodeName=="OBJECT"||q.nodeName=="EMBED")){if(h.ie&&h.win){if(q.readyState==4){B(r)}else{j.attachEvent("onload",function(){B(r)})}}else{q.parentNode.removeChild(q)}}}function B(t){var r=C(t);if(r){for(var q in r){if(typeof r[q]=="function"){r[q]=null}}r.parentNode.removeChild(r)}}function C(t){var q=null;try{q=K.getElementById(t)}catch(r){}return q}function a(q){return K.createElement(q)}function I(t,q,r){t.attachEvent(q,r);d[d.length]=[t,q,r]}function c(t){var r=h.pv,q=t.split(".");q[0]=parseInt(q[0],10);q[1]=parseInt(q[1],10)||0;q[2]=parseInt(q[2],10)||0;return(r[0]>q[0]||(r[0]==q[0]&&r[1]>q[1])||(r[0]==q[0]&&r[1]==q[1]&&r[2]>=q[2]))?true:false}function V(v,r){if(h.ie&&h.mac){return }var u=K.getElementsByTagName("head")[0],t=a("style");t.setAttribute("type","text/css");t.setAttribute("media","screen");if(!(h.ie&&h.win)&&typeof K.createTextNode!=b){t.appendChild(K.createTextNode(v+" {"+r+"}"))}u.appendChild(t);if(h.ie&&h.win&&typeof K.styleSheets!=b&&K.styleSheets.length>0){var q=K.styleSheets[K.styleSheets.length-1];if(typeof q.addRule==Q){q.addRule(v,r)}}}function W(t,q){var r=q?"visible":"hidden";if(e&&C(t)){C(t).style.visibility=r}else{V("#"+t,"visibility:"+r)}}function g(s){var r=/[\\\"<>\.;]/;var q=r.exec(s)!=null;return q?encodeURIComponent(s):s}var D=function(){if(h.ie&&h.win){window.attachEvent("onunload",function(){var w=d.length;for(var v=0;v<w;v++){d[v][0].detachEvent(d[v][1],d[v][2])}var t=i.length;for(var u=0;u<t;u++){X(i[u])}for(var r in h){h[r]=null}h=null;for(var q in swfobject){swfobject[q]=null}swfobject=null})}}();return{registerObject:function(u,q,t){if(!h.w3cdom||!u||!q){return }var r={};r.id=u;r.swfVersion=q;r.expressInstall=t?t:false;N[N.length]=r;W(u,false)},getObjectById:function(v){var q=null;if(h.w3cdom){var t=C(v);if(t){var u=t.getElementsByTagName(Q)[0];if(!u||(u&&typeof t.SetVariable!=b)){q=t}else{if(typeof u.SetVariable!=b){q=u}}}}return q},embedSWF:function(x,AE,AB,AD,q,w,r,z,AC){if(!h.w3cdom||!x||!AE||!AB||!AD||!q){return }AB+="";AD+="";if(c(q)){W(AE,false);var AA={};if(AC&&typeof AC===Q){for(var v in AC){if(AC[v]!=Object.prototype[v]){AA[v]=AC[v]}}}AA.data=x;AA.width=AB;AA.height=AD;var y={};if(z&&typeof z===Q){for(var u in z){if(z[u]!=Object.prototype[u]){y[u]=z[u]}}}if(r&&typeof r===Q){for(var t in r){if(r[t]!=Object.prototype[t]){if(typeof y.flashvars!=b){y.flashvars+="&"+t+"="+r[t]}else{y.flashvars=t+"="+r[t]}}}}f(function(){U(AA,y,AE);if(AA.id==AE){W(AE,true)}})}else{if(w&&!A&&c("6.0.65")&&(h.win||h.mac)){A=true;W(AE,false);f(function(){var AF={};AF.id=AF.altContentId=AE;AF.width=AB;AF.height=AD;AF.expressInstall=w;k(AF)})}}},getFlashPlayerVersion:function(){return{major:h.pv[0],minor:h.pv[1],release:h.pv[2]}},hasFlashPlayerVersion:c,createSWF:function(t,r,q){if(h.w3cdom){return U(t,r,q)}else{return undefined}},removeSWF:function(q){if(h.w3cdom){X(q)}},createCSS:function(r,q){if(h.w3cdom){V(r,q)}},addDomLoadEvent:f,addLoadEvent:R,getQueryParamValue:function(v){var u=K.location.search||K.location.hash;if(v==null){return g(u)}if(u){var t=u.substring(1).split("&");for(var r=0;r<t.length;r++){if(t[r].substring(0,t[r].indexOf("="))==v){return g(t[r].substring((t[r].indexOf("=")+1)))}}}return""},expressInstallCallback:function(){if(A&&M){var q=C(m);if(q){q.parentNode.replaceChild(M,q);if(l){W(l,true);if(h.ie&&h.win){M.style.display="block"}}M=null;l=null;A=false}}}}}();
	var id = 'avplayer';
	$('head').append('<link rel="stylesheet" type="text/css" media="screen" href="' + String(dir) +'avplayer.css" />');
	swfobject.embedSWF(dir + "avplayer.swf", id , "1", "1", "9.0.0", dir + "expressInstall.swf");
	//$('#avplayer').replaceWith('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="1" height="1" id="'+ id + '"><param name="allowScriptAccess" value="sameDomain" /><param name="allowFullScreen" value="false" /><param name="movie" value="' + dir + 'avplayer.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><!--[if IE]><embed src="' + dir + 'avplayer.swf" quality="high" bgcolor="#ffffff" width="1" height="1" name="' + id + '" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /><![endif]--></object>');
	//$('body').append('<div id="' + id + '"></div>');
}

function avpInitList(list){
	list.addClass('avplayList');
	list.addClass('avplayList_wait');
	list.click(function(){
		var av_status = avStatus();

		if(av_status.isPlaying == false && av_status.played == 0) {
			avPlay($(this).attr('href'));
			$("#" + avLyric.id + ' > span .avpLine_' + avLyric.lyric[0].time).addClass("avplayLine_hilight");
			$(this).removeClass('avplayList_wait');
			$(this).removeClass('avplayList_pause');
			$(this).addClass('avplayList_now');
		}
		if(av_status.isPlaying == true && av_status.played > 0) {
			avStop(av_status.played);
			$(this).removeClass('avplayList_wait');
			$(this).removeClass('avplayList_now');
			$(this).addClass('avplayList_pause');
		}
		if(av_status.isPlaying == false && av_status.played > 0) {
			avPlay();
			$(this).removeClass('avplayList_wait');
			$(this).removeClass('avplayList_pause');
			$(this).addClass('avplayList_now');

		}
		return false;
	});
}

function Player(){
	return document.getElementById("avplayer");
}

function avPlay(melody){
	Player().avPlay(melody);
}
function avPause(){
	Player().avPause();
}
function avStop(time){
	time = time > 0 ? time : 0;
	Player().avStop(time);
	avLine = 0;
}

function avStatus(){
	return Player().avStatus();
}

function avThisLine(line){
	var av_status = avStatus();
	if(av_status.isPlaying == false) {
		return false;
	}
	var time = $(line).attr('class');
	time = time.match(/\d+/);
	time = time[0];
	avStop(time);
	avPlay();

	$(".avplayLine_hilight").removeClass("avplayLine_hilight");
	$(line).addClass("avplayLine_hilight");
	$(".avplayLine:not(.avpLine_" + time + ")").addClass("avplayLine_played");
	$(".avpLine_" + time +" ~ span").removeClass("avplayLine_played");
}

/**
 * LRC
 *
*/

var avLyric;
var avLine = 0;
function parseTime(x) {
	var l = x.split('.');
	var t = 0;
	try {
		var j = l[0].split(':');
		t += parseInt(j[j.length - 1], 10) * 1000;
		if (j.length > 1) {
			t += parseInt(j[j.length - 2], 10) * 60000;
		}
		if (j.length > 2) {
			t += parseInt(j[j.length - 3], 10) * 3600000;
		}
		if (l.length > 1) {
			if (l[1].length == 1) {
				t += parseInt(l[1], 10) * 100;
			} else if (l[1].length == 2) {
				t += parseInt(l[1], 10) * 10;
			} else if (l[1].length == 3) {
				t += parseInt(l[1], 10) * 1;
			}
		}
		return t;
	} catch (e) {
		return 0;
	}
}

function parseLRC(str) {
	//var re = /(\[\d{2,2}:\d{2,2}\.\d{2,2}\])+?/g;
	str = str.match(/^\[([0-9:\.]+)\](.*)$/);
	return str == null ? false : {time:parseTime(str[1]),content:str[2]};
}

function getLyric(lrc){
	var lyric = new Array();
	lrc = lrc.split(/\n/g);
	for(var i = 0;i < 4;i++){
		lrc[i] = lrc[i].trim();
		var tmp = lrc[i].match(/\[([(ti)|(ar)|(al)|(by):])(.*)\]/ig);
		if(tmp == null) {
			break;
		}
		else{
			switch (tmp[0].substr(1,2)){
				case 'ti':
					var title = tmp[0].substr(4,tmp[0].length - 5);
				break;
				case 'ar':
					var artist = tmp[0].substr(4,tmp[0].length - 5);
				break;
				case 'al':
					var album = tmp[0].substr(4,tmp[0].length - 5);
				break;
				case 'by':
					var by = tmp[0].substr(4,tmp[0].length - 5);
				break;
				default:;
			}
		}
	}
	var j = 0;
	for (i = 0; i < lrc.length; i ++) {
		lrc[i] = lrc[i].trim();
		tmp =  parseLRC(lrc[i]);
		if(tmp) {
			lyric[j] = tmp;
			j++;
		}
	}
	return {title:title,artist:artist,album:album,by:by,lyric:lyric};
}

function printLyric(lyric) {
	var res = '';
	for(var i = 0;i < lyric.length;i++) {
		res += '<span class="avplayLine avpLine_'+ lyric[i].time +'" onclick="avThisLine(this);">' + lyric[i].content + "</span>\n";
	}
	return res;
}

function avpInitLrc(pre){
	avLyric = getLyric(pre.html());
	var id = "avLrc" + Math.floor(Math.random()*10000);
	avLyric.id = id;
	pre.replaceWith('<div id="' + id + '" class = "avplayLrcCase">' + printLyric(avLyric.lyric) + '</div>');
	return pre;
}

function linkTo(pre){

}

/**
 * Called by swf
 *
*/

function AvplayerEnterFrame(s){
	var added = false;
	if(s < avLyric.lyric[avLine].time) {
		if(added == false) {
			var now = avLine - 1 >= 0 ? avLine - 1 : 0;
			$('.avpLine_' + avLyric.lyric[now].time).addClass("avplayLine_hilight");
			avLine > 0 ? $('.avpLine_' + avLyric.lyric[now - 1].time).removeClass("avplayLine_hilight").addClass("avplayLine_played") : '';
		}
	}
	else {
		added = true;
		avLine++;
	}
}
-->
