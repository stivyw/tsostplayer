/**
 * The AVPlayer package
 *
 * @package    AvPlayer
 * @author     AlloVince <allo.vince@gmail.com>
 * @copyright  2008-2009 AVE7.NET
 * @license    GNU General Public License v3
 * @link       http://code.google.com/p/tsostplayer/
 */
package {
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.display.*;
	import flash.errors.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	//import flash.net.URLRequest;
	import flash.net.*;
	//JS Interface
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	//import com.adobe.serialization.json.*;
	import AvPlayer.*;
	
	/**
	 * The AVPlayer Core Class
	 *
	 * @version    0.11
	 */
	public class AvPlayer extends MovieClip{

		//Player全局设置
		private var _options = {
			debug : true, //Debug Mode
			jsName : 'AvPlayer', // Js new Class Name
			autoStart : false, //自动开始播放
			autoNext : false, //自动播放下一首
			shuffle : false, //乱序播放
			loop : false, //循环播放
			lyricOn : true, //歌词开启
			delay : -1000 //歌词过渡的提前显示间隔，单位ms
		}

		
		//曲目播放状态
		private var _status = {
			hasLoaded:false, //已经将链接读入
			loadComplete:false, //已经读取完毕
			isPlaying:false, //正在播放
			pausePosition:0, //暂停位置
			loadLength:0, //已经读取的长度
			length:0, //曲目全长
			played:0, //已经播放长度
			volume:0.7, //音量
			listIndex:0, //播放列表位置
			continuPlay:false, //从中断处再开
			jumpPlay:false, //跳转播放
			listReady:false, //播放列表已经设置完毕
			lrcReady:false, //歌词已经正确解析
			jsReady : false,
			lyric : {}
		}
		
		//UI设置
		private var _UI = {
			initBar: {
				width:140,
				height:14,
				posx:58,
				posy:3.5,
				bg:"0xFFFFFF",
				round:5
			},
			loadedBar:{
				width:140,
				height:14,
				posx:58,
				posy:3.5,
				bg:"0xEFEFEF",
				round:5
			},
			playedBar:{
				width:140,
				height:14,
				posx:58,
				posy:3.5,
				bg:"0xCFE8FF",
				round:5
			},
			pointer:{
				x:58,
				y:5,
				radius:2,
				areaX:60,
				areaY:10,
				areaWidth:140,
				areaHeigth:12,
				blur:6,
				color:"0x677FA5",
				alpha:0
			},
			playerTimer : {
				x:60,
				y:0.5,
				size:9,
				textColor:"0x000000",
				mouseEnabled:false
			}
		};
		
		//当前播放媒体
		private var _melody:Object = {
			title:'',
			artist:'',
			album:'',
			link:'',
			year:'',
			track:'',
			comment:'',
			lyric:''
		};
		

		private var _sound:Sound = new Sound();
		private var _req:URLRequest;
		private var _channel:SoundChannel;
		
		//生成List用
		private var _melodySample:Object;
		
		//播放列表
		private var _playlist:Array = new Array();
		//播放列表URL
		private var _playlistUrl:String = "";
		private var _playlistXML:XML = new XML();
		private var _playlistLoader:URLLoader;
		
		private var _streamPlay:SoundLoaderContext = new SoundLoaderContext(8000, true);
		//声道
		private var _trans:SoundTransform = new SoundTransform(_status.volume, 0);
		
		//Flash vars
		private var _param:Object = LoaderInfo(root.loaderInfo).parameters;
		
		//计时器
		private var _showtimer;
		//计时器的文字栏
		private var _timerText:TextField = new TextField();
		//歌词相关
		private var _showLyric;
		//进度条
		public var _progressBar;
		

		
		//public var _error = false;
		
		/** ----------------------------
		 * 
		 * Function Series actionXXX
		 * 对外部公开的函数，可供Js调用
		 * 全部为public
		 * 
		 *  ----------------------------*/
		 
		/**
		 * 播放曲目
		 *
		 * @param  melody String or Object
		 * @return void
		 * @access public
		 */
		public function actionPlay(url = null){
			var same = url ? actionSetMelody(url) : true;
			
			if(!_melody.link) {
				return p('no media input');
			}
			
			//已经开始播放且为同一首歌
			if(_status.isPlaying == true && same == true){
				return p("has played");
			}
			
			//要更改播放曲目，首先停止当前音乐，
			if(same == false) {
				actionStop();
			}
			
			//p(_melody);
			
			//未被读入,重新初始化Sound对象
			if (_status.hasLoaded == false) {
				try{
					_sound = new Sound();
					_req = new URLRequest(_melody.link);
					//Load error hander
					_sound.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
					_sound.load(_req,_streamPlay);
				}
				catch(e:Error){
					p('actionPlay Load Error' + e);
				}
			}
			try{
					//设置状态
					_status.hasLoaded = true;

					//监控读取过程
					_sound.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
					_sound..addEventListener(Event.ID3, this.onGetID3Info);
					//增加读取完毕事件
					_sound.addEventListener(Event.COMPLETE, this.onSoundLoaded);
					
					//播放实时监控
					addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
					
					//开始播放
					
					_channel = _sound.play(_status.pausePosition,1,_trans);
					
					//音量
					_channel.soundTransform = _trans;
					
					//初始化暂停位置
					_status.pausePosition = 0;
					_status.isPlaying = true;
					
					//游标初始化
					_progressBar.initPointer(this.onDropPointer);
					this.addChild(_progressBar.pointerArea);
					this.addChild(_progressBar.pointer);
					
					//增加完成监听
					_channel.addEventListener(Event.SOUND_COMPLETE, this.onPlayComplete);
					
			}
			catch(e:Error){
				p('startplay error' + e);
			}
		}

		/**
		 * 重置操作，清除曲目状态，解除事件绑定
		 *
		 * @param  void
		 * @return void
		 * @access public
		 */
		public function actionReset(){
			//重置曲目播放状态
			_status.hasLoaded = false;
			_status.isPlaying = false;
			_status.continuPlay = false;
			_status.jumpPlay = false;
			_status.lrcReady = false;
			
			//解除时间绑定
			removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			removeEventListener(Event.SOUND_COMPLETE, this.onPlayComplete);
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			removeEventListener(Event.COMPLETE, this.onSoundLoaded);
			
			//读取过程中关闭声音需要配合close来结束sound类
			_sound.close();
			_sound = null;
		}
		
		/**
		 * 暂停操作
		 *
		 * @param  void
		 * @return void
		 * @access public
		 */
		public function actionPause(){
			//如果正在播放，记录曲目位置并停止
			if (_status.pausePosition == 0 && _status.isPlaying == true) {
				this.actionStop(_channel.position);
			}
			//如果未播放且之前有暂停记录，则恢复播放
			else if (_status.pausePosition > 0 && _status.isPlaying == false) {
				this.actionPlay();
			}
			else {
				p("Nothing to Pause");
			}
		}
		
		/**
		 * 停止操作
		 *
		 * @param  position
		 *         position = 0 进行完全停止操作，恢复曲目状态，并解除事件绑定
		 *         position != 0 仅停止声音播放
		 * @return void
		 * @access public
		 */
		public function actionStop(position:Number = 0):void{
			//还没有读入
			if(!_status.hasLoaded) {
				return;
			}
			
			try {
				//停止播放
				_channel.stop();
				//停止计时器
				_showtimer.stopTimer(position);
				//记录停止位置
				_status.pausePosition = position;
				_status.isPlaying = false;
			}
			catch(e:Error) {
				p('actionStop Error' + e);
			}
			
			//完全停止
			if(position == 0){
				
				//在读取过程中中止，需要用close关闭sound
				if(_status.loadComplete == false) {
					removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
					_sound.close();
				}
				
				
				//取消监听
				removeEventListener(Event.SOUND_COMPLETE, this.onPlayComplete);
				removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
				removeEventListener(Event.COMPLETE, this.onSoundLoaded);
				
				
				//恢复状态
				_status.hasLoaded = false;
				_status.played = 0;
				
				
				//重置进度条
				this.removeChild(_progressBar.loadbar);
				this.removeChild(_progressBar.playbar);
				
				
				//时间显示
				_timerText.text = '';
			}
		}
		
		/**
		 * 取得当前播放状态
		 *
		 * @param  void
		 * @return _status:Object
		 * @access public
		 */
		public function actionStatus(){
			return _status;
		}
		
		/**
		 * 设置当前曲目
		 *
		 * @param  melody:Object
		 * @return void
		 * @access public
		 */
		public function actionSetMelody(melody){
			//p(melody);
			if(!melody) {
				p('Nothing to SetMelody');
				return false;
			}
			else if(melody is String) {
				melody = {link:melody}
			}
			else if(melody is Object) {
				melody = melody;
			}
			else {
				p('SetMelody Error')
				return false;
			}
			var same = melody.link == _melody.link ? true : false;
			_melody = same == true ? _melody : melody;
			return same;
		}
		
		/**
		 * 设置当前曲目列表
		 *
		 * @param  list:Object
		 * @return void
		 * @access public
		 */
		public function actionSetList(url){
			var list_url:URLRequest = new URLRequest(url);
			_playlistLoader = new URLLoader();
			_playlistLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			_playlistLoader.addEventListener("complete", onListLoaded);
			try{
				_playlistLoader.load(list_url);
			}
			catch(e:Error){
				p(e);
			}
		}
		
		/**
		 * 获得当前曲目列表
		 *
		 * @param  void
		 * @return _playlist or false
		 * @access public
		 */
		public function actionGetList(){
			return _status.listReady ? _playlist : false;
		}
		
		/**
		 * 传入歌词并解析
		 *
		 * @param lrc:String
		 * @return void
		 * @access public
		 */
		public function actionSetLyric(lrc:String){
			_melody.lyric = lrc;
			_showLyric = new Lyric();
			if(_options.delay != 0) {
				_showLyric.SetOptions({delay:_options.delay});
			}
			_showLyric.Parse(_melody.lyric);
			_status.lyric = _showLyric.Find(0);
			
			_status.lrcReady = true;
		}
		
		/**
		 * 获得解析後的歌词
		 *
		 * @param  void
		 * @return _showLyric or false
		 * @access public
		 */
		public function actionGetLyric(){
			return _showLyric is Lyric ? _showLyric.lrcObj : false;
		}
		/**
		 * 播放下一首
		 *
		 * @param  url:String 下一首的Url
		 * @return void
		 * @access public
		 */
		public function actionNext(url = ''){
			
			//未播放状态点击Next是否开始播放
			if(_status.isPlaying == false) {
				//return p("not played yet");
			}
			
			//顺序播放
			if(!_options.shuffle) {
				
				//最后一首
				if(_status.listIndex == _playlist.length - 1) {
					//回到第一首
					_status.listIndex = 0;
					//return p('this is the last one');
				}
				else {
					//下一首
					_status.listIndex < _playlist.length ? _status.listIndex++ : '';
				}
			}
			//乱序播放
			else {
				//产生播放列表范围内的随机数
				_status.listIndex = Math.floor(Math.random()* _playlist.length);
			}


			for(var i in _playlist) {
				if(i == _status.listIndex) {
					actionSetMelody(_playlist[i]);
					actionStop();
					actionPlay(url);
					break;
				}
			}
		}
		
		/**
		 * 播放上一首
		 *
		 * @param  url:String 上一首的Url
		 * @return void
		 * @access public
		 */
		public function actionPrev(url = ''){
			if(_status.isPlaying == false) {
				//return p("not played yet");
			}
			
			//顺序播放
			if(!_options.shuffle) {
				
				//第一首
				if(_status.listIndex == 0) {
					//回到最后一首
					_status.listIndex = _playlist.length - 1;
				}
				else {
					//上一首
					_status.listIndex > 0 ? _status.listIndex-- : '';
				}
			}
			//乱序播放
			else {
				//产生播放列表范围内的随机数
				_status.listIndex = Math.floor(Math.random()* _playlist.length);
			}
			
			for(var i in _playlist) {
				if(i == _status.listIndex) {
					actionSetMelody(_playlist[i]);
					actionStop();
					actionPlay(url);
					break;
				}
			}
		}
		
		
		/** ----------------------------
		 * 
		 * Function Series onXXX
		 * 对事件进行绑定的函数
		 * 
		 *  ----------------------------*/
		 
		/**
		 * 被绑定的播放事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onPlay(event:MouseEvent):void {
			this.actionPlay();
			ExternalInterface.call(_options.jsName + ".PlayPlay");
		}
		/**
		 * 被绑定的暂停事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onPause(event:MouseEvent):void {
			this.actionPause();
			ExternalInterface.call(_options.jsName + ".PlayPause");
		}
		/**
		 * 被绑定的停止事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onStop(event:MouseEvent):void {
			this.actionStop();
			ExternalInterface.call(_options.jsName + ".PlayStop");
		}
		/**
		 * 被绑定的下一首事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onNext(event:MouseEvent):void {
			this.actionNext();
			ExternalInterface.call(_options.jsName + ".PlayNext");
		}
		/**
		 * 被绑定的上一首事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onPrev(event:MouseEvent):void {
			this.actionPrev();
			ExternalInterface.call(_options.jsName + ".PlayPrev");
		}

		
		/**
		 * 被绑定的读取进度事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onLoadProgress(event:ProgressEvent):void {
			if(_sound.length > 0) {
				try{
					//读取过程中动态计算全长
					_status.length = _sound.length / (_sound.bytesLoaded / _sound.bytesTotal);
					//动态计算已经读取的长度
					_status.loadLength = _status.length * (_sound.bytesLoaded / _sound.bytesTotal);

					//读取进度条
					_progressBar.playProgress(_progressBar.loadbar,_UI.loadedBar,_sound.bytesLoaded / _sound.bytesTotal);
					this.addChild(_progressBar.loadbar);
				}
				catch(e:Error) {
					p("LoadProgress Error" + e);
				}
			}
		}
		
		/**
		 * 被绑定的读取完成事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onSoundLoaded(event:Event):void {
			//加载完毕后启用实际长度，取消监听,启用游标
			removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			_status.loadComplete = true;
			_status.length = _sound.length;
			ExternalInterface.call(_options.jsName + ".PlaySoundLoaded");
		}
		

		/**
		 * 被绑定的播放完成事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onPlayComplete(event:Event) {
			this.actionStop();
			
			//有播放列表 and 自动连续播放
			if(_playlist.length > 0 && _options.autoNext) {
				
				if(!_options.shuffle && !_options.loop && _status.listIndex == _playlist.length - 1) {
					//顺序播放且不循环,在最后一首停止
				}
				else {
					this.actionNext();
					this.actionPlay();
				}
			}
			
			ExternalInterface.call(_options.jsName + ".PlayComplete");
		}
		
		/**
		 * 被绑定的获取ID3 Tag事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onGetID3Info(event:Event) {
			//
			//var id3 = event.target.id3;
			//p(id3);
		}
		
		/**
		 * 被绑定的播放列表读取事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onListLoaded(event:Event):void {
			
			_playlistXML = XML(_playlistLoader.data);
			
			var tmp:Object = new Object;
			
			//有link,将link作为播放列表的第一条入栈
			if(_param.link) {
				tmp = cloneObj(_melodySample);
				tmp.link = _param.link;
				_playlist.push(tmp);
			}

			for(var i in _playlistXML.channel.item) {
				//每回创建一个新的Obj
				tmp = cloneObj(_melodySample);
				tmp.title = _playlistXML.channel.item[i].title;
				tmp.link = _playlistXML.channel.item[i].link;
				_playlist.push(tmp);
				//p(tmp);
			}
			
			//没有Link参数，将播放列表的第一条作为当前曲目
			if(!_param.link) {
				this.actionSetMelody(_playlist[0]);
				_options.autoStart == true ? this.actionPlay() : '';
			}
			
			_status.listReady = true;
			ExternalInterface.call(_options.jsName + ".PlayListLoaded",_playlist);
		}
		

		/**
		 * 被绑定的监听事件
		 *
		 * @param  event:Event
		 * @return void
		 * @access private
		 */
		private function onEnterFrame(event:Event):void {
			//开始播放
			if(_channel.position > 0) {
				try{
					//开始计时器
					_showtimer.startTimer(_channel.position,_status.length);
				
					//显示计数
					_timerText.text = _showtimer.timeStatus.played;
					_status.played = _channel.position;
					

					
					//当前播放百分比
					var pesent = _channel.position / _status.length;
					pesent = pesent > 0 ? pesent : 0; //修正参数类型
	
					//进度条
					_progressBar.playProgress(_progressBar.playbar,_UI.playedBar, pesent);
					this.addChild(_progressBar.playbar);
					
					this.addChild(_timerText);
	
					//ExternalInterface.call(_options.jsName + ".EnterFrame",_status.played);
					
					this.onShowLyric(_channel.position);
					
				}
				catch(e:Error) {
					p("EnterFrame Error : " + e);
				}
			}
		}
		
		private function onShowLyric(t){
			if(_status.lrcReady === false || !_options.lyricOn || t < _status.lyric.thisTime) return;
			_status.lyric = _showLyric.Find(t);
			ExternalInterface.call(_options.jsName + ".PlayShowLyric",_status.lyric);
		}
		
		/**
		 * 点击游标
		 *
		 * @param  pesent 播放位置的百分比
		 * @return void
		 * @access private
		 */
		private function onDropPointer(pesent) {
			if(_status.isPlaying == true){
				//点击位置超过了当前读取量
				if(_status.pausePosition >= _status.loadLength) {
					p('this Position is not loaded yet');
				}
				_status.pausePosition = _status.length * pesent;
				this.actionStop(_status.pausePosition);
				this.actionPlay();
				_status.jumpPlay = true;
			}
			else {
				p("Nothing is Playing");
			}
			ExternalInterface.call(_options.jsName + ".PlayDropPointer",_status.pausePosition);

		}

		/**
		 * 读取过程中的出错处理
		 *
		 * @param  e:IOErrorEvent
		 * @return void
		 * @access private
		 */
		private function ioErrorHandler(e:IOErrorEvent)	{
			trace(e);
			_status.isPlaying ? this.actionReset() : '';
			ExternalInterface.call(_options.jsName + ".PlayIoError");
			//ExternalInterface.call('console.log',"[%s]",e); //如果loading过程中退出，此处的参数传递在errorhandler中无法响应,所以不能直接用ExternalInterface.call
		}
		
		/**
		 * 打印信息
		 *
		 * @param  m 所要打印的信息
		 * @return void
		 * @access private
		 */
		private function p(m,level = 0){
			if(!_options.debug) return false;
			var type = typeof(m);
			if(type == 'object') {
				for(var i in m) {
					var s = i + ' : ';
					if(typeof(m[i]) == 'object') {
						trace(s);
						ExternalInterface.call('console.log',"[%s]",s);
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
						trace(s);
						ExternalInterface.call('console.log',"[%s]",s);
					}
				}
				
			}
			else {
				trace(m);
				ExternalInterface.call('console.log',"[%s]",m);
			}

		}
		
		/**
		 * 根据Flash Vars初始化内部参数
		 *
		 * @param  void
		 * @return void
		 * @access private
		 */
		private function initParam(){

			for(var i in _param){
				_options[i] = _param[i];
			}
			
			if(_param.list) {
				_melodySample = cloneObj(_melody);
				this.actionSetList(_param.list);
			}
			else {
				//没有播放列表，自动隐藏按钮
				this.removeChild(buttPrev);
				this.removeChild(buttNext);
			}
			
			if(_param.link) {
				this.actionSetMelody(_param.link);
				//自动开始播放
				_options.autoStart == true ? this.actionPlay() : '';
			}
			

		}
		
		/**
		 * 初始化计时器
		 *
		 * @param  void
		 * @return void
		 * @access private
		 */
		private function initTimer(){
			//时间显示初始化
			_showtimer = new Showtimer();

			_timerText.x = _UI.playerTimer.x;
			_timerText.y = _UI.playerTimer.y;
			//_timerText.size = _UI.playerTimer.size;
			_timerText.mouseEnabled = _UI.playerTimer.mouseEnabled;
			_timerText.textColor = _UI.playerTimer.textColor;
		}
		
		private function initLyric(){

		}
		
		/**
		 * 初始化播放器
		 *
		 * @param  void
		 * @return void
		 * @access private
		 */
		private function initPlayer(){
			//进度条初始化
			_progressBar = new Progress(_UI);
			this.addChild(_progressBar.initProgress());
			
			//计时器初始化
			initTimer();
			
			//如果有参数，初始化参数
			//_param.link = "http://xhh4bw.bay.livefilestore.com/y1pf3AUkJcahV3yOst5P9N7F5L3zeue8PnEgz4K0ZYJSsEOElDPfJVJZn1jbj45peOvSs_xN-BgkDhVbCFNFusFXQ/ashita_no_tenki.mp3";
			//_param.list = "Demos/list.xml";
			initParam();
			
			//_options.lyricOn ? initLyric() : '';
					
			//对元素绑定事件
			buttPlay.addEventListener(MouseEvent.CLICK,onPlay);			
			buttPause.addEventListener(MouseEvent.CLICK,onPause);
			buttStop.addEventListener(MouseEvent.CLICK,onStop);
			
			buttPrev.addEventListener(MouseEvent.CLICK,onPrev);
			buttNext.addEventListener(MouseEvent.CLICK,onNext);
			
			//公开所有对外函数
			ExternalInterface.addCallback("avStop", actionStop);
			ExternalInterface.addCallback("avPlay", actionPlay);
			ExternalInterface.addCallback("avPause", actionPause);
			ExternalInterface.addCallback("avNext", actionNext);
			ExternalInterface.addCallback("avPrev", actionPrev);
			ExternalInterface.addCallback("avReset", actionReset);
			ExternalInterface.addCallback("avStatus", actionStatus);
			ExternalInterface.addCallback("avSetMelody", actionSetMelody);
			ExternalInterface.addCallback("avSetList", actionSetList);
			ExternalInterface.addCallback("avGetLyric", actionGetLyric);
			ExternalInterface.addCallback("avSetLyric", actionSetLyric);
		}

		/**
		 * 构造函数
		 *
		 * @param  void
		 * @return void
		 * @access public
		 */
		public function AvPlayer() {
			initPlayer();
			loaderInfo.addEventListener(Event.COMPLETE, selfLoadComplete);
		}
		
		private function selfLoadComplete(event:Event):void {
			IsReady();
		}
		
		private function IsReady(){
			if (ExternalInterface.available){
				try {
					var containerReady:Boolean = isContainerReady();
					if (containerReady){
						ExternalInterface.call(_options.jsName + ".ready.SetReady");
					}
					else{
						var readyTimer:Timer = new Timer(100);
						readyTimer.addEventListener(TimerEvent.TIMER,readyTimerHandler);
						readyTimer.start();
					}
				}
				catch(e) {
					p(e)
				}
			}
			else {
				p("External interface is not available for this container.");
			}
		}
		
		private function isContainerReady():Boolean{
			_status.jsReady = ExternalInterface.call(_options.jsName + ".ready.getready");
			//p("call GetReady : " +  _status.jsReady);
			return _status.jsReady;
		}
		
		private function readyTimerHandler(event:TimerEvent){
			if (isContainerReady()){
				Timer(event.target).stop();
				//p("Timer Stoped");
			}
		}

		/**
		 * 复制一个对象而不是引用
		 *
		 * @param source:Object 所要复制的对象
		 * @return Object
		 * @access private
		 */
		private function cloneObj(source:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return(copier.readObject());
		}
	}
	
}