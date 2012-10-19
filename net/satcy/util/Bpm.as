package net.satcy.util{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Bpm{
		private static var dsp:EventDispatcher;
		private static var tm:EnterFrameTimer;
		public static var mills:Number;
		public static var bpm:Number;
		private static var _cnt:int = 0;
		private static var _auto:Boolean = true;
		public static function get cnt():int{
			return _cnt;
		}
		public static function init(_bpm:Number, _auto:Boolean = true):void{
			if ( dsp ) return;
			Bpm._auto = _auto;
			dsp = new EventDispatcher();
			setBpm(_bpm);
		}
		
		public static function setBpm(_bpm:Number):void{
			if ( tm ) tm.destroy();
			bpm = _bpm;
			mills = 60000/_bpm;
			tm = new EnterFrameTimer(dispatch, mills, _auto);
		}
		
		public static function update(_elapsedTime:Number):void{
			if ( _auto ) return;
			tm.update(_elapsedTime);
		}
		
		public static function addEventListener(_fn:Function):void{
			if ( !dsp ) return;
			dsp.removeEventListener(Event.CHANGE, _fn);
			dsp.addEventListener(Event.CHANGE, _fn);
		}
		
		public static function removeEventListener(_fn:Function):void{
			if ( !dsp ) return;
			dsp.removeEventListener(Event.CHANGE, _fn);
		}
		
		private static function dispatch():void{
			_cnt++;
			if ( _cnt > 31 ) _cnt = 0;
			dsp.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}