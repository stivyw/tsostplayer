<!--

function AvPlayer(dir,id){
	var av = this;

	/**
	 * Page Elements
	**/
	this.dir = dir ? dir : './';

	this.id = id ? id : 'avplayer';

	this.isIE = (navigator.userAgent.match(/MSIE/i));

	this.getDocument = function(){
		return (document.body?document.body:(document.documentElement?document.documentElement:document.getElementsByTagName('div')[0]));
	};

	this.container = document.getElementById('avplayer-container')?document.getElementById('avplayer-container'):document.createElement('div');

	/**
	 * Player Objects
	**/

	this.melody = '';

	this.lyric = {};

	this.lrcline = 0;

	this.playlist = {};

	/**
	 * Call flash API
	**/

	this.player = function(){
		return document.getElementById(av.id);
	}

	this._play = function(m){
		av.player().avPlay(m);
	}

	this._stop = function(time){
		time = time > 0 ? time : 0;
		av.player().avStop(time);
		av.lrcline = 0;
	}

	this._pause = function(){
		av.player().avPause();
	}

	this._status = function(){
		return av.player().avStatus();
	}

	this.playthis = function(line){
		if(av._status().isPlaying == false) {
			return false;
		}

		var time = $(line).attr('class');
		time = time.match(/\d+/);
		time = time[0];
		av._stop(time);
		av._play();

		$(".avplayLine_hilight").removeClass("avplayLine_hilight");
		$(line).addClass("avplayLine_hilight");
		$(".avplayLine:not(.avpLine_" + time + ")").addClass("avplayLine_played");
		$(".avpLine_" + time +" ~ span").removeClass("avplayLine_played");
	}

	/**
	 * Page Actions
	 **/ 
	this.init = function(){
		if (window.addEventListener) {
			window.addEventListener('load',av.creat,false);
			window.addEventListener('unload',av.destroy,false);
		} else if (window.attachEvent) {
			window.attachEvent('onload',av.creat);
			window.attachEvent('onunload',av.destroy);
		};
	}

	this.creat = function(){
		var htmlEmbed = '<embed name="'+av.id+'" id="'+av.id+'" src="'+av.dir+'avplayer.swf" width="100%" height="100%" quality="high" allowScriptAccess="always" quality="high" bgcolor="#ffffff" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed>';
		var htmlObject = '<object id="'+av.id+'" data="'+av.dir+'avplayer.swf" type="application/x-shockwave-flash" width="100%" height="100%"><param name="movie" value="'+dir+'avplayer.swf" /><param name="AllowScriptAccess" value="always" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /></object>';
		var html = (!av.isIE?htmlEmbed:htmlObject);
		var head = document.getElementsByTagName("head")[0];
		var css = document.createElement('link');
		css.type = 'text/css';
		css.rel = "stylesheet";
		css.href = av.dir + "avplayer.css";
		
		if(!av.container.id){
			av.container.id = av.id + '-container';
			var container_style = {position: 'fixed',width: '8px',height: '8px',bottom: '0px',left: '0px',zIndex:-1};
			for (var x in container_style) {
				av.container.style[x] = container_style[x];
			}
		}
		try{
			head.appendChild(css);
			av.getDocument().appendChild(av.container);
			av.container.innerHTML = html;
		}
		catch(e){
			alert(e);
		}
	}

	this.destroy = function(){
		//
	}

	/**
	 * PlayList functions
	**/

	this.href2list = function(href){
		href.addClass('avplayList');
		href.addClass('avplayList_wait');
		href.click(function(){
			var s = av._status();
			if(s.isPlaying == false && s.played == 0) {
				av._play($(this).attr('href'));
				$("#" + av.lyric.id + ' > span .avpLine_' + av.lyric.main[0].time).addClass("avplayLine_hilight");
				$(this).removeClass('avplayList_wait');
				$(this).removeClass('avplayList_pause');
				$(this).addClass('avplayList_now');
			}
			if(s.isPlaying == true && s.played > 0) {
				av._stop(s.played);
				$(this).removeClass('avplayList_wait');
				$(this).removeClass('avplayList_now');
				$(this).addClass('avplayList_pause');
			}
			if(s.isPlaying == false && s.played > 0) {
				av._play();
				$(this).removeClass('avplayList_wait');
				$(this).removeClass('avplayList_pause');
				$(this).addClass('avplayList_now');
			}
			return false;
		});
	}

	/**
	 * LRC functions
	**/
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
		str = str.match(/^\[([0-9:\.]+)\](.*)$/);
		return str == null ? false : {time:parseTime(str[1]),content:str[2]};
	}

	function lrc2obj(lrc){
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
		return {title:title,artist:artist,album:album,by:by,main:lyric};
	}

	function printLyric(lyric) {
		var res = '';
		for(var i = 0;i < lyric.length;i++) {
			//res += '<span class="avplayLine avpLine_'+ lyric[i].time +'" onclick="alert(avp);">' + lyric[i].content + "</span>\n";
			res += '<span class="avplayLine avpLine_'+ lyric[i].time +'" onclick="avp.playthis(this);">' + lyric[i].content + "</span>\n";
		}
		return res;
	}

	this.initlrc = function(pre){
		av.lyric = lrc2obj(pre.html());
		var id = "avLrc" + Math.floor(Math.random()*10000);
		av.lyric.id = id;
		pre.replaceWith('<div id="' + id + '" class = "avplayLrcCase">' + printLyric(av.lyric.main) + '</div>');
		//return pre;
	}

	/**
	 * Called by swf
	**/

	this.EnterFrame = function(s){
		var added = false;
		if(s < av.lyric.main[av.lrcline].time) {
			if(added == false) {
				var now = av.lrcline - 1 >= 0 ? av.lrcline - 1 : 0;
				//$('.avpLine_' + avLyric.lyric[now].time).addClass("avplayLine_hilight").highlightFade({speed:1000});
				//$("#"+ avLyric.id).scrollTo($('.avpLine_' + avLyric.lyric[now].time),{offset:-150});
				$('.avpLine_' + av.lyric.main[now].time).addClass("avplayLine_hilight");
				av.lrcline > 0 ? $('.avpLine_' + av.lyric.main[now - 1].time).removeClass("avplayLine_hilight").addClass("avplayLine_played") : '';
			}
		}
		else {
			added = true;
			av.lrcline++;
		}
	}

	this.IoError = function(){
		$('.avplayList_now').removeClass("avplayList_now").addClass("avplayList_error");
		$('.avplayLine_hilight').removeClass("avplayLine_hilight");
	}

	this.PlayComplete = function(){
		$('.avplayList_now').removeClass("avplayList_now").addClass('avplayList_wait');
		$('.avplayLine_hilight').removeClass("avplayLine_hilight");
		$('.avplayLine_played').removeClass("avplayLine_played");
	}

	/**
	 * constractor
	 **/
	av.init();
	$("a[href$='.mp3']").each(function(){
		av.href2list($(this));
	});
	$("pre[class='lrc']").each(function(){
		av.initlrc($(this));
	});

}

-->
