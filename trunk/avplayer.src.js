<!--
/**
 * The AVPlayer Javascript Interface
 *
 *
 * @author     AlloVince <allo.vince@gmail.com>
 * @copyright  2008-2009 AVE7.NET
 * @license    GNU General Public License v3
 * @link       http://code.google.com/p/tsostplayer/
 */
(function(){

var 

window = this,

undefined ,

isIE = (navigator.userAgent.match(/MSIE/i)) ,

type = function (obj) {
	if (obj === null) {
		return 'Null';
	}
	if (obj === undefined) {
		return 'Undefined';
	}
	return Object.prototype.toString.call(obj).match(/\s(.+)\]$/)[1];
},

debug = function (m,level){
	level == undefined ? 0 : level;
	var type = typeof(m);
	if(type == 'object') {
		for(var i in m) {
			var s = i + ' : ';
			if(typeof(m[i]) == 'object') {
				console.log("Js debug : [%s]",s);
				s = '';
				p(m[i],level + 1);
			}
			else {
				s = i + ' : ' + m[i];

			}
			for(var j = 0; j < level; j++) {
				s = "\t" + s;
			}
			if(s) {
				console.log("Js debug : [%s]",s);
			}
		}

	}
	else {
		console.log("Js debug : [%s]",m);
	}
},


AvPlayer = window.AvPlayer = {
	
	info: {
		loaded : false,
		version : '0.10'
	},


	option : {
		id : 'avplayer',
		dir : './',
		swf : 'avplayer.swf',
		css : 'avplayer.css',
		debug : true
	},

	container : document.getElementById('avplayer-container')?document.getElementById('avplayer-container'):document.createElement('div'),
	
	getDocument : document.body?document.body:(document.documentElement?document.documentElement:document.getElementsByTagName('div')[0]),

	init : function(dir){
		AvPlayer.option.dir = dir || AvPlayer.option.dir;
		if (window.addEventListener) {
			window.addEventListener('load',AvPlayer.creat,false);
			//window.addEventListener('unload',AvPlayer.destroy,false);
		} else if (window.attachEvent) {
			window.attachEvent('onload',AvPlayer.creat);
			//window.attachEvent('onunload',AvPlayer.destroy);
		};
	},

	setup : function(op){
		for(var i in op){
			AvPlayer.option[i] = op[i];
		}
	},

	creat : function(){
		var htmlEmbed = '<embed name="'+AvPlayer.option.id+'" id="'+AvPlayer.option.id+'" src="'+AvPlayer.option.dir+'avplayer.swf" width="100%" height="100%"></embed>';
		var htmlObject = '<object id="'+AvPlayer.option.id+'" data="'+AvPlayer.option.dir+'avplayer.swf" type="application/x-shockwave-flash" width="100%" height="100%"><param name="movie" value="'+AvPlayer.option.dir+'avplayer.swf" /></object>';
		var html = !isIE ? htmlEmbed : htmlObject;
		/*
		var head = document.getElementsByTagName("head")[0];
		var css = document.createElement('link');
		css.type = 'text/css';
		css.rel = "stylesheet";
		css.href = AvPlayer.option.dir + AvPlayer.option.css;
		*/
		if(!AvPlayer.container.id){
			AvPlayer.container.id = AvPlayer.option.id + '-container';
			var container_style = {position: 'fixed',width: '8px',height: '8px',bottom: '0px',left: '0px',zIndex:-1};
			for (var x in container_style) {
				AvPlayer.container.style[x] = container_style[x];
			}
		}
		try{
			//head.appendChild(css);
			AvPlayer.getDocument.appendChild(AvPlayer.container);
			AvPlayer.container.innerHTML = html;
			AvPlayer.info.loaded = true;
			AvPlayer.player = document.getElementById(AvPlayer.option.id);
		}
		catch(e){
			debug(e);
		}
	},

	play : function(url){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		url = url || null;
		AvPlayer.player.avPlay(url);	
	},

	stop : function(time){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		//确保入口参数正确
		time = type(time) == 'Number' ? time : 0;
		AvPlayer.player.avStop(time);
	},

	pause : function(){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		AvPlayer.player.avPause();
	},
	
	next : function(){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		AvPlayer.player.avNext();
	},
	
	prev : function(){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		AvPlayer.player.avPrev();
	},
	
	reset : function(){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		AvPlayer.player.avReset();
	},

	status : function(){
		return AvPlayer.player.avStatus();
	},
	
	melody : function(){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		AvPlayer.player.avSetMelody();
	},

	list : function(url){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		if(url === undefined)
			return AvPlayer.player.avGetList()
		AvPlayer.player.avSetList(url);
	},
	
	lyric : function(lrc){
		if(AvPlayer.info.loaded === false)
			return debug('Player is not Ready');
		if(lrc === undefined)
			return AvPlayer.player.avGetLyric()
		AvPlayer.player.avSetLyric(lrc);
	},
	
	PlayComplete : function(){
				   
	},
	
	PlayShowLyric : function(l) {
		//p(l.prevLyric);
	}


};

})();



AvPlayer.init('../');


function p(m,level){
	level == undefined ? 0 : level;
	var type = typeof(m);
	if(type == 'object') {
		for(var i in m) {
			var s = i + ' : ';
			if(typeof(m[i]) == 'object') {
				console.log("Js debug : [%s]",s);
				s = '';
				p(m[i],level + 1);
			}
			else {
				s = i + ' : ' + m[i];

			}
			for(var j = 0; j < level; j++) {
				s = "\t" + s;
			}
			if(s) {
				console.log("Js debug : [%s]",s);
			}
		}

	}
	else {
		console.log("Js debug : [%s]",m);
	}
}



-->
