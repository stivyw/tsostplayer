<!--
/**
 * The AvPlayer Javascript Interface Core
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

_attachEvent = function(evt, callback){
	if (window.addEventListener) {
		window.addEventListener(evt, callback, false);
	}
	else if (window.attachEvent) {
		window.attachEvent("on" + evt, callback);
	}
},

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
				debug(m[i],level + 1);
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
		ready : false,
		jsready : false,
		swfready : false,
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
		//Domready不可用，只能绑定在onload事件上
		_attachEvent('load',AvPlayer.creat);
		//AvPlayer.domready(AvPlayer.creat);
	},

	setup : function(op){
		for(var i in op){
			AvPlayer.option[i] = op[i];
		}
	},

	creat : function(){
		var htmlEmbed = '<embed name="'+AvPlayer.option.id+'" id="'+AvPlayer.option.id+'" src="'+AvPlayer.option.dir+'avplayer.swf" allowScriptAccess="always" width="100%" height="100%"></embed>';
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
			AvPlayer.player = document.getElementById(AvPlayer.option.id);
			AvPlayer.info.jsready = true;
		}
		catch(e){
			debug(e);
		}
	},

	play : function(url){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		url = url || null;
		AvPlayer.player.avPlay(url);
		return this;
	},

	stop : function(time){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		//确保入口参数正确
		time = type(time) == 'Number' ? time : 0;
		AvPlayer.player.avStop(time);
		return this;
	},

	pause : function(){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		AvPlayer.player.avPause();
		return this;
	},
	
	next : function(){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		AvPlayer.player.avNext();
		return this;
	},
	
	prev : function(){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		AvPlayer.player.avPrev();
		return this;
	},
	
	reset : function(){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		AvPlayer.player.avReset();
		return this;
	},

	status : function(){
		return AvPlayer.player.avStatus();
		return this;
	},
	
	melody : function(){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		AvPlayer.player.avSetMelody();
		return this;
	},

	list : function(url){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		if(url === undefined)
			return AvPlayer.player.avGetList()
		AvPlayer.player.avSetList(url);
		return this;
	},
	
	lyric : function(lrc){
		if(AvPlayer.info.ready === false)
			return debug('Player is not Ready');
		if(lrc === undefined)
			return AvPlayer.player.avGetLyric()
		AvPlayer.player.avSetLyric(lrc);
		return this;
	},

	ready : function(fn){
		if (AvPlayer.info.ready === true) return fn();
		
		if (AvPlayer.ready.timer) {
			AvPlayer.ready.funcs.push(fn);
		}
		else {
			AvPlayer.ready.funcs = [fn];
			AvPlayer.ready.timer = window.setInterval("AvPlayer.ready.isready()",100);

		}

		AvPlayer.ready.getready = function() {
			return AvPlayer.info.jsready;
		}

		AvPlayer.ready.SetReady = function() {
			//swf读取完毕后不能立即响应，这里必须设置延迟
			setTimeout(function(){
				AvPlayer.info.swfready = true;
			},500);
		}

		AvPlayer.ready.isready = function(){
			if (AvPlayer.info.jsready === false || AvPlayer.info.swfready === false) return false;
			if (AvPlayer.info.jsready === true && AvPlayer.info.swfready === true) {
				AvPlayer.ready.clear(AvPlayer.ready.timer);
				debug("all ready");
				AvPlayer.info.ready = true;
				for(var i in AvPlayer.ready.funcs) {
					AvPlayer.ready.funcs[i]();
				}
				AvPlayer.ready.timer = null;
				AvPlayer.ready.funcs = null;
			}
		}
		AvPlayer.ready.clear = function(timer) {
			window.clearInterval(timer);
		}
	}

/*	,
	domready : function(fn){
		if (AvPlayer.info.ready) return;
		if (document.addEventListener){
			document.addEventListener("DOMContentLoaded", function(){
				document.removeEventListener( "DOMContentLoaded", arguments.callee, false );
				fn();
			}, false );
		} else if ( document.attachEvent ) {
			document.attachEvent("onreadystatechange", function(){
				if (document.readyState === "complete" ) {
					document.detachEvent( "onreadystatechange", arguments.callee );
					fn();
				}
			});
			if ( document.documentElement.doScroll && !window.frameElement ) (function(){
				
				try {
					document.documentElement.doScroll("left");
				} catch( error ) {
					setTimeout( arguments.callee, 0 );
					return;
				}
				fn();
			})();
		}
		_attachEvent("load",fn);
	}
*/	


};

})();






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
