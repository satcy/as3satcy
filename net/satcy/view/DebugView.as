package net.satcy.view{
	import flash.text.TextField;

	public class DebugView extends TextField{
		private static var instance:Object = new Object();
		
		public static function writeAdd(_id:uint, _str:String):void{
			if ( !instance[_id] ) return;
			var txt:String = instance[_id].text;
			instance[_id].text = _str + "\n"+txt;
		}
		
		public static function write(_id:uint, _str:String):void{
			if ( !instance[_id] ) return;
			instance[_id].text = _str;
		}
		
		public static function remove(_id:uint):void{
			if ( !instance[_id] ) return;
			var tf:TextField = instance[_id];
			if ( tf.parent ) tf.parent.removeChild( tf );
			delete instance[_id];
		}
		
		public function DebugView(_id:uint = 0, _width:Number = 100, _height:Number = 100){
			super();
			instance[_id] = this;
			this.textColor = 0x00FFFF;
			this.background = true;
			this.backgroundColor = 0;
			this.border = true;
			this.width = _width;
			this.height = _height;
		}
		
		
	}
}