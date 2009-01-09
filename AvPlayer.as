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
	
	import flash.net.URLRequest;
	//JS Interface
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import com.adobe.serialization.json.*;
	import AvPlayer.*;
	
	/**
	 * The AVPlayer Core Class
	 *
	 * @version    0.07
	 */
	public class AvPlayer extends MovieClip{

		private var _sound:Sound = new Sound();
		private var _req:URLRequest;
		private var _channel:SoundChannel;
		
		private var _status = {
			hasLoaded:false, //已经将链接读入
			loadComplete:false, //已经读取完毕
			isPlaying:false, //正在播放
			pausePosition:0, //暂停位置
			loadLength:0, //已经读取的长度
			length:0, //曲目全长
			played:0, //已经播放长度
			volume:0.7 //音量
		}
		
		private var _UI = {
			initBar: {
				width:140,
				height:14,
				posx:60,
				posy:3,
				bg:"0xEFEFEF",
				round:5
			},
			loadedBar:{
				width:140,
				height:14,
				posx:60,
				posy:3,
				bg:"0xEAEAEA",
				round:5
			},
			playedBar:{
				width:140,
				height:14,
				posx:60,
				posy:3,
				bg:"0xCFE8FF",
				round:5
			},
			pointer:{
				x:60,
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
				x:57,
				y:2,
				size:9,
				textColor:"0x000000",
				mouseEnabled:false
			}
		};
		
		private var _playlist:Object;
		private var _playlistUrl:String = "";
		private var _playlistXML:XML = new XML();
		
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
		
		private var _streamPlay:SoundLoaderContext = new SoundLoaderContext(8000, true);
		private var _trans:SoundTransform = new SoundTransform(_status.volume, 0);
		
		private var _param:Object = LoaderInfo(root.loaderInfo).parameters;
		
		public var _showtimer;
		public var _progressBar;
		
		public var _debug = true;
		public var _error = false;
		public var _jsName = 'avp';
		
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
				showTimer.text = '';
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
		public function actionSetList(list){
			_playlist = list;
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
		}
		/**
		 * 被绑定的下一首事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onNext(event:MouseEvent):void {
			ExternalInterface.call(_jsName + ".PlayNext");
		}
		/**
		 * 被绑定的上一首事件
		 *
		 * @param  event:MouseEvent
		 * @return void
		 * @access private
		 */
		private function onPrev(event:MouseEvent):void {
			ExternalInterface.call(_jsName + ".PlayPrev");
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
					showTimer.text = _showtimer.timeStatus.played;
					_status.played = _channel.position;
				
					//当前播放百分比
					var pesent = _channel.position / _status.length;
					pesent = pesent > 0 ? pesent : 0; //修正参数类型
	
					//进度条
					_progressBar.playProgress(_progressBar.playbar,_UI.playedBar, pesent);
					this.addChild(_progressBar.playbar);
					
					this.addChild(showTimer);
	
					ExternalInterface.call(_jsName + ".EnterFrame",_status.played);
				}
				catch(e:Error) {
					p("EnterFrame Error" + e);
				}
			}
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
			
			//游标初始化
			_progressBar.initPointer(this.onDropPointer);
			this.addChild(_progressBar.pointerArea);
			this.addChild(_progressBar.pointer);
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
			ExternalInterface.call(_jsName + ".PlayComplete");
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
			}
			else {
				p("Nothing is Playing");
			}

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
			actionReset();
			ExternalInterface.call(_jsName + ".IoError");
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
			if(!_debug) return false;
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
		
		private function initTimer(){
			//时间显示初始化
			_showtimer = new Showtimer();
			showTimer.x = _UI.playerTimer.x;
			showTimer.y = _UI.playerTimer.y;
			//showTimer.size = _UI.playerTimer.size;
			showTimer.mouseEnabled = _UI.playerTimer.mouseEnabled;
			showTimer.textColor = _UI.playerTimer.textColor;
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
			
			//当前播放曲目初始化
			initTimer();
			
			//this.actionSetMelody(_param.link);
			this.actionSetMelody('http://mediaplayer.yahoo.com/example1.mp3');

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
			ExternalInterface.addCallback("avReset", actionReset);
			ExternalInterface.addCallback("avStatus", actionStatus);
			ExternalInterface.addCallback("avMelody", actionSetMelody);
			ExternalInterface.addCallback("avList", actionSetList);
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
			
		}
		
	}
	
}