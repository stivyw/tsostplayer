<!--



function avpInit(dir){
	var isIE = (navigator.userAgent.match(/MSIE/i));
	var id = 'avplayer';

    var htmlEmbed = '<embed name="'+id+'" id="'+id+'" src="'+dir+'avplayer.swf" width="100%" height="100%" quality="high" allowScriptAccess="always" quality="high" bgcolor="#ffffff" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>';
    var htmlObject = '<object id="'+id+'" data="'+dir+'avplayer.swf" type="application/x-shockwave-flash" width="100%" height="100%"><param name="movie" value="'+dir+'avplayer.swf" /><param name="AllowScriptAccess" value="always" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /></object>';
    var html = (!isIE?htmlEmbed:htmlObject);
	var head = document.getElementsByTagName("head")[0];
	var css = document.createElement('link');
	css.type = 'text/css';
	css.rel = "stylesheet";
	css.href = dir + "avplayer.css";
	
	var getDocument = function(){
		return (document.body?document.body:(document.documentElement?document.documentElement:document.getElementsByTagName('div')[0]));
	};

	var container = document.getElementById('avplayer-container')?document.getElementById('avplayer-container'):document.createElement('div');


	var avpCreat = function(){
		if(!container.id){
			container.id = 'avplayer-container';
			var container_style = {position: 'fixed',width: '8px',height: '8px',bottom: '0px',left: '0px',zIndex:-1};
			for (var x in container_style) {
				container.style[x] = container_style[x];
			}
		}
		try{
			head.appendChild(css);
			getDocument().appendChild(container);
			container.innerHTML = html;
		}
		catch(e){
			alert(e);
		}
	}
	
	var avpDestroy = function(){
		Player().avReset();
		//document.getElementById("avplayer-container").removeChild(document.getElementById("avplayer"));
	}
	
	if (window.addEventListener) {
		window.addEventListener('load',avpCreat,false);
		window.addEventListener('unload',avpDestroy,false);
	} else if (window.attachEvent) {
		window.attachEvent('onload',avpCreat);
		window.attachEvent('onunload',avpDestroy);
	};
}

function destroy(){
	document.getElementById("avplayer-container").removeChild(document.getElementById("avplayer"));
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

function avMelody(){
	return Player().avMelody();
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

function trim(s){
	return s.replace(/(^\s*)|(\s*$)/g, "");
}

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
		lrc[i] = trim(lrc[i]);
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
		lrc[i] = trim(lrc[i]);
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
			
			//$('.avpLine_' + avLyric.lyric[now].time).addClass("avplayLine_hilight").highlightFade({speed:1000});
			//$("#"+ avLyric.id).scrollTo($('.avpLine_' + avLyric.lyric[now].time),{offset:-150});
			$('.avpLine_' + avLyric.lyric[now].time).addClass("avplayLine_hilight");
			avLine > 0 ? $('.avpLine_' + avLyric.lyric[now - 1].time).removeClass("avplayLine_hilight").addClass("avplayLine_played") : '';
		}
	}
	else {
		added = true;
		avLine++;
	}
}

function AvplayerIoError(error){
	$('.avplayList_now').removeClass("avplayList_now").addClass("avplayList_error");
	$('.avplayLine_hilight').removeClass("avplayLine_hilight");
}

function AvplayerPlayComplete(){
	$('.avplayList_now').removeClass("avplayList_now").addClass('avplayList_wait');
	$('.avplayLine_hilight').removeClass("avplayLine_hilight");
	$('.avplayLine_played').removeClass("avplayLine_played");
}
-->
