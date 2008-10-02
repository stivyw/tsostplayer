package AvPlayer {
	import flash.utils.Timer;
	import flash.events.*;
	
	public class Showtimer{
		public var timerPlay:Timer = new Timer(1000,int.MAX_VALUE);
		public var timeStatus = {
			length:0,
			start:0,
			played:"00:00:00",
			playedseconds:0,
			remain:"00:00:00",
			remainseconds:0
		}

		public function startTimer(start,length = 0) {
			this.timeStatus.length = length > 0 ? length : int.MAX_VALUE;
			this.timeStatus.start = start;
			this.timeStatus.playedseconds = start;
			this.timeStatus.remainseconds = length - start;
			
			//同步 点击事件触发的瞬间
			timeStatus.played = second2time(this.timeStatus.playedseconds);
			timeStatus.remain = second2time(this.timeStatus.remainseconds);

			timerPlay.addEventListener(TimerEvent.TIMER, onTick);
			timerPlay.start();
		
		}
		
		public function stopTimer(position) {
			//trace("Timer Stoped");
			//position = 0时清零
			if(position <= 0) {
				this.timeStatus = {
					length:0,
					start:0,
					played:"00:00:00",
					playedseconds:0,
					remain:"00:00:00",
					remainseconds:0
				}
			}
			timerPlay.stop();
			
		}
		
		private function onTick(event:TimerEvent):void {

			this.timeStatus.playedseconds = this.timeStatus.start + event.target.currentCount * 1000;
			this.timeStatus.remainseconds = this.timeStatus.length - this.timeStatus.start - event.target.currentCount * 1000;
			//trace(this.timeStatus.playedseconds);
			
			timeStatus.played = second2time(this.timeStatus.playedseconds);
			timeStatus.remain = second2time(this.timeStatus.remainseconds);
		}
		
		private function second2time(s:Number):String {
			s = s <= 0 ? 0 : s/1000;
			var hour:int = Math.floor(s/3600);
			var res = hour < 10 ? '0' + String(hour) + ':' : String(hour) + ':';
			var minute:int = Math.floor((s - 3600*hour)/60);
			res = minute < 10 ? res + '0' + String(minute) + ':' : res + String(minute) + ':';
			s = Math.ceil((s - 3600*hour)%60);
			res = s < 10 ? res + '0' + String(s) : res + String(s);
			return res;
		}
		// 构造函数
		public function Showtimer() {
		}
		
	}
	
}