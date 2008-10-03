package {
	import flash.events.*;
	import flash.media.*;
	import flash.display.*;
	import flash.errors.*;
	
	import flash.net.URLRequest;
	//JS Interface
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import com.adobe.serialization.json.*;
	import AvPlayer.*;

	
	public class AvPlayer extends MovieClip{
		
		private var _sound:Sound = new Sound();
		private var _req:URLRequest;
		private var _channel:SoundChannel;
		
		public var _status = {
			firstClick:false,
			loadComplete:false,
			isPlaying:false,
			pausePosition:0,
			length:0,
			played:0,
			volume:0.7
		}
		
		public var _UI = {
			initBar: {
				width:140,
				height:1,
				posx:60,
				posy:5,
				bg:"0xD6F0FF"
			},
			loadedBar:{
				width:140,
				height:1,
				posx:60,
				posy:5,
				bg:"0x677FA5"
			},
			playedBar:{
				width:140,
				height:2,
				posx:60,
				posy:4.5,
				bg:"0x677FA5"
			},
			pointer:{
				x:60,
				y:5,
				radius:2,
				areaX:60,
				areaY:2,
				areaWidth:140,
				areaHeigth:12,
				blur:6,
				color:"0x677FA5",
				alpha:0.7
			}
		};

		public var _playlistUrl:String = "list.xml";
		public var _playlist:XML = new XML();
		
		
		private var _melody:Object = {
			title:'',
			artist:'',
			album:'',
			link:'',
			year:'',
			track:'',
			comment:''
		};
		private var _streamPlay:SoundLoaderContext = new SoundLoaderContext(8000, true);
		private var _trans:SoundTransform = new SoundTransform(_status.volume, 0);
		
		public var _showtimer;
		public var _progressBar;
		
		public function actionPlay(melody = null){
			var same = true;

			if(melody) {
				melody = melody is String ? {link:melody} : melody;
				same = melody.link == _melody.link ? true : false;
				_melody = same == true ? _melody : melody;
			}
			
			
			
			//已经开始播放且为同一首歌
			if(_status.isPlaying == true && same == true){
				return false;
			}
			
			//要更改播放曲目，首先停止当前音乐，
			if(same == false) {
				actionStop();
			}
			
			//首次点击,重新初始化Sound对象
			if (_status.firstClick == false) {
				_sound = new Sound();
				_req = new URLRequest(_melody.link);
				_sound.load(_req,_streamPlay);
				_status.firstClick = true;
			}
			
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
			_channel.addEventListener(Event.SOUND_COMPLETE, this.onPlaybackComplete);

			return _status;

		}
		
		public function actionPause(){
			if (_status.pausePosition == 0 && _status.isPlaying == true) {
				this.actionStop(_channel.position);
			}
			else if (_status.pausePosition > 0 && _status.isPlaying == false) {
				this.actionPlay();
			}
			else {
				trace("Nothing to Pause");
			}
			return _status; 
		}
		
		public function actionStop(position:Number = 0):void{
			if(_status.firstClick == true) {
				//停止播放
				_channel.stop();
				//停止计时器
				_showtimer.stopTimer(position);
				//记录停止位置
				_status.pausePosition = position;
				_status.isPlaying = false;
				
				//完全停止
				if(position == 0){
					
					//在读取过程中中止，需要用close关闭sound
					if(_status.loadComplete == false) {
						removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
						_sound.close();
					}
					
					
					//取消监听
					removeEventListener(Event.SOUND_COMPLETE, this.onPlaybackComplete);
					removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
					removeEventListener(Event.COMPLETE, this.onSoundLoaded);
					
					
					//恢复状态
					_status.firstClick = false;
					_status.played = 0;
					
					
					//重置进度条
					this.removeChild(_progressBar.loadbar);
					this.removeChild(_progressBar.playbar);
					
					
					//时间显示
					showTimer.text = '';
				}
			}
			else{
				trace("Nothing to stop");
			}
			//return _status;

		}
		
		private function onPlay(event:MouseEvent):void {
			this.actionPlay();
			
		}
		
		private function onPause(event:MouseEvent):void {
			this.actionPause();
		}
		
		private function onStop(event:MouseEvent):void {
			this.actionStop();
		}
		private function onNext(event:MouseEvent):void {
			this.actionPlay("http://mediaplayer.yahoo.com/example1.mp3");
		}
		private function onPrev(event:MouseEvent):void {
			this.actionPlay("http://mediaplayer.yahoo.com/example2.mp3");
		}
		
		private function onEnterFrame(event:Event):void {
			
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
			
			ExternalInterface.call("AvplayerEnterFrame",_status.played);
		}
		
		
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
		
		private function onLoadProgress(event:ProgressEvent):void {
			//读取过程中动态计算全长
			_status.length = _sound.length / (_sound.bytesLoaded / _sound.bytesTotal);
			//读取进度条
			_progressBar.playProgress(_progressBar.loadbar,_UI.loadedBar,_sound.bytesLoaded / _sound.bytesTotal);
			this.addChild(_progressBar.loadbar);
		}
		
		private function onPlaybackComplete(event:Event) {
			this.actionStop();
		}
		
		private function onDropPointer(pesent) {
			if(_status.isPlaying == true){
				_status.pausePosition = _status.length * pesent;
				this.actionStop(_status.pausePosition);
				this.actionPlay();
			}
			else {
				trace("Nothing is Playing");
			}

		}
		
		private function initPlayer(){
			_showtimer = new Showtimer();
			_progressBar = new Progress(_UI);
			
			showTimer.mouseEnabled = false;
			//进度条初始化
			this.addChild(_progressBar.initProgress());
			
			//http://comicer.hzcnc.com/music/yjj/tenkonagala1001.mp3
			_melody = {link:"test.mp3"}
			
			
			buttPlay.addEventListener(MouseEvent.CLICK,onPlay);			
			buttPause.addEventListener(MouseEvent.CLICK,onPause);
			buttStop.addEventListener(MouseEvent.CLICK,onStop);
			buttPrev.addEventListener(MouseEvent.CLICK,onPrev);
			buttNext.addEventListener(MouseEvent.CLICK,onNext);
			
			
			ExternalInterface.addCallback("avStop", actionStop);
			ExternalInterface.addCallback("avPlay", actionPlay);
			ExternalInterface.addCallback("avPause", actionPause);
			
			
		}
		

		public function AvPlayer() {
			initPlayer();
		}
		
	}
	
}