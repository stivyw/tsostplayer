package AvPlayer{
	import flash.net.*;
	import flash.events.*;
	
	public class Lyric {
		/**
		 * 歌词原文备份
		 * @access public
		 */
		private var lrcBak:String;
		
		/**
		 * 时间轴
		 * @access public
		 */
		public var timeLine:Array = new Array();
		
		public var lrcObj:Array = new Array();
		
		/**
		 * 解析歌词获得的基本信息
		 * @access public
		 */
		public var lrcInfo:Object = {
			title:'',
			album:'',
			artist:'',
			by:''
		}

		/**
		 * 解析函数
		 * @param  line:String
		 * @return false or Object
		 * @access private
		 */
		public function Parse(lrc:String):void {
			this.lrcBak = lrc;
			var lines = lrc.split("\n");
			var line = '';
			var isHeader = true;
			for(var i in lines) {
				//1.判别header
				line = Trim(lines[i]);
				isHeader === true ? isHeader = this.GetHeader(line) : '';
				
				if(isHeader === false) {
					//2.分离时间轴
					this.GetTimeLine(line);
					
				}
				
			}
			//3.数组按时间轴排序
			//FIXME : 相同时间的元素
			this.timeLine.sort(Array.NUMERIC);
			this.lrcObj.sortOn("t",Array.NUMERIC);
		}
		
		/**
		 * 根据时间找到该行歌词的位置和具体信息
		 * @param  t:Number
		 * @return false or Object
		 * @access private
		 */
		public function Find(t:Number) {
			var index = 0;
			if(t < this.timeLine[0]) {
				
			}
			else if(t > this.timeLine[this.timeLine.length - 1]) {
				index = -1;
			}
			else {
				while (t > this.timeLine[index]) {
					index++;
				}
			}

			//FIXME 歌词小于3行的情况
			switch(index) {
				case -1 : 
					return false;
				case 0 : 
					return {
						prevIndex : false,
						prevTime : false,
						prevLyric : false,
						thisIndex : index,
						thisTime : this.lrcObj[index].t,
						thisLyric : this.lrcObj[index].l,
						nextIndex : index + 1,
						nextTime : this.lrcObj[index + 1].t,
						nextLyric : this.lrcObj[index + 1].l
					}
				case this.timeLine.length - 1 :
					return {
						prevIndex : index - 1,
						prevTime : this.lrcObj[index - 1].t,
						prevLyric : this.lrcObj[index - 1].l,
						thisIndex : index,
						thisTime : this.lrcObj[index].t,
						thisLyric : this.lrcObj[index].l,
						nextIndex : false,
						nextTime : false,
						nextLyric : false
					}
				default : 
					return {
						prevIndex : index - 1,
						prevTime : this.lrcObj[index - 1].t,
						prevLyric : this.lrcObj[index - 1].l,
						thisIndex : index,
						thisTime : this.lrcObj[index].t,
						thisLyric : this.lrcObj[index].l,
						nextIndex : index + 1,
						nextTime : this.lrcObj[index + 1].t,
						nextLyric : this.lrcObj[index + 1].l
					}
			}
		}
		
		/**
		 * 将单行歌词分解为形如
			lyric : 明日天気に．．．
			timeLine : 
				0 : 1590
				1 : 1200
				2 : 1210
				3 : 1220
			格式的对象
		 * @param  line:String
		 * @return false or Object
		 * @access private
		 */
		private function GetTimeLine(line:String){
			if(!line) return false;
			
			var spl:Array = line.split(/(\[\d{2}:\d{2}\.\d{2}\])/gi);
			var lrcUnit:Object = {
				timeLine:[],
				lyric:''
			}
			var correctParse = false;
			//spl[0] == '' 即有一个时间标签在开头
			if(spl[0] == '') {
				//所有时间入栈
				for(var i = 1; i < spl.length - 1; i++) {
					var time = parseTime(spl[i]);
					if(time) {
						
						lrcUnit.timeLine.push(time);
						
						this.lrcObj.push({t:time,l:spl[spl.length - 1]});
						//索引用
						this.timeLine.push(time);
						
						correctParse = true;
					}
				}
				//歌词部分
				correctParse === true ? lrcUnit.lyric = spl[spl.length - 1] : '';
			}
			return correctParse === true ? lrcUnit : false;
		}
		
		/**
		 * 将形如[00:29.06]的时间解析为以毫秒为单位的数字
		 * 
		 * @param  x:String
		 * @return false or Number
		 * @access private
		 */
		private function parseTime(x:String) {
			if(!x) return false;
			if(x.length != 10) return false;
			if(x.charAt(0) != '[' || x.charAt(x.length - 1) != ']') return false;
			x = x.substr(1,8);
			var l:Array = x.split('.');
			var t:Number = 0;
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
				return false;
			}
		}
		
		/**
		 * 判断是否为歌词头部分，如果是歌词头部分，填充lrcInfo
		 * 
		 * @param  line:String
		 * @return Boolean
		 * @access private
		 */
		private function GetHeader(line:String):Boolean{
			if(line.charAt(0) == '[' && line.charAt(line.length - 1) == ']') {
				var type = line.charAt(3) == ':' ? line.charAt(1) + line.charAt(2) : '';
				switch(type) {
					case 'ti' : 
						this.lrcInfo.title = line.substring(4,line.length - 2);
						break;
					case 'al' :
						this.lrcInfo.album = line.substring(4,line.length - 2);
						break;
					case 'ar' :
						this.lrcInfo.artist = line.substring(4,line.length - 2);
						break;
					case 'by' :
						this.lrcInfo.by = line.substring(4,line.length - 2);
						break;
					default : ''
				}
				return true;
			}
			else{
				return false;
			}
		}


		public function Lyric(lrc) {
			this.Parse(lrc);
		}
		
		//去左右空格;
		private function Trim(char:String):String{
			if(char == null){
				return null;
			}
			return LTrim(RTrim(char));
		}
		
		private function LTrim(s : String):String{
			var i : Number = 0;
			while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 || s.charCodeAt(i) == 9){
				i++;
			}
			return s.substring(i,s.length);
		}
		
		
		private function RTrim(s : String):String{
			var i : Number = s.length - 1;
			while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 ||s.charCodeAt(i) == 9) {
				i--;
			}
			return s.substring(0,i+1);
		}
	}
}