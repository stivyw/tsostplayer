package AvPlayer {
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	
	public class Progress{
		public var loadbar:Shape = new Shape();
		public var playbar:Shape = new Shape();
		
		public var pointerArea:Sprite = new Sprite();
		public var pointer;
		public var playthis:Function;
		
		private var UI;	
		
		public function initProgress() {
			var bar:Shape = new Shape();
			bar.graphics.beginFill(UI.initBar.bg);
			bar.graphics.drawRect(UI.initBar.posx, UI.initBar.posy, UI.initBar.width, UI.initBar.height);
			bar.graphics.endFill();
			return bar;
		}
		
		public function playProgress(bar:Shape,loader:Object,percent:Number) {
			//trace(percent);
			bar.graphics.clear();
			bar.graphics.beginFill(loader.bg);
			bar.graphics.drawRect(loader.posx, loader.posy, loader.width * percent, loader.height);
			bar.graphics.endFill();
			return bar;
		}

		public function clearProgress() {
			playbar.graphics.clear();
			return playbar;
		}
		
		//初始化游标 点击游标后的动作函数作为参数
		public function initPointer(playthis) {
			this.playthis = playthis;
			
			pointer = new Sprite();
			pointer.graphics.beginFill(UI.pointer.color);
			pointer.graphics.drawCircle(UI.pointer.x,UI.pointer.y,UI.pointer.radius);
			pointer.graphics.endFill();
			pointer.alpha = 0;
			pointer.buttonMode = true;
			
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = UI.pointer.color;
			glow.alpha = 1;
			glow.blurX = UI.pointer.blur;
			glow.blurY = UI.pointer.blur;
			glow.quality = BitmapFilterQuality.HIGH;
			pointer.filters = [glow];
			
			//鼠标感应区
			pointerArea.graphics.beginFill(0xFFFFFF);
			pointerArea.graphics.drawRect(UI.pointer.areaX - pointer.width/2, UI.pointer.areaY, UI.pointer.areaWidth + 2, UI.pointer.areaHeigth);
			pointerArea.alpha = 0;
			pointerArea.buttonMode = true;
			
			pointerArea.addEventListener(MouseEvent.MOUSE_OUT,onPointerOut);
			pointerArea.addEventListener(MouseEvent.MOUSE_MOVE,onPointerMove);
			pointer.addEventListener(MouseEvent.MOUSE_UP,onPointerUp);
			pointerArea.addEventListener(MouseEvent.MOUSE_UP,onPointerUp);
			return pointerArea;
		}
		
		function onPointerMove(event:MouseEvent):void{
			pointer.alpha = UI.pointer.alpha;
			pointer.x = pointerArea.mouseX - UI.pointer.x;
		}
		
		function onPointerOut(event:MouseEvent):void{
			pointer.alpha = 0;
		}
		
		function onPointerUp(event:MouseEvent):void{
			var pesent = (pointerArea.mouseX - UI.pointer.areaX + pointer.width/2) / (UI.pointer.areaWidth + 2);
			this.playthis(pesent);
		}

		// 构造函数
		public function Progress(_UI) {
			this.UI = _UI;
		}
		
	}
	
}