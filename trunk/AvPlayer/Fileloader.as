package AvPlayer{
	import flash.net.*;
	import flash.events.*;
	
	public class Fileloader {
		public var xmlDate:XML;
		private var xmlLoader:URLLoader;
		public var runFunc:Function;
		
		public function Loadxml(file:String,func:Function) {
			var xmlurl:URLRequest = new URLRequest(file);
			xmlLoader:URLLoader = new URLLoader(xmlurl);
			xmlLoader.addEventListener(Event.COMPLETE, this.XmlLoaded);
		}
		
		public function XmlLoaded(event:Event):void {
			xmlDate = new XML();
			xmlDate = XML(xmlLoader.data);
		}
		
		public function Fileloader() {

		}
	}
}