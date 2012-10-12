package net.satcy.util{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Satoshi HORII
	 *	@since  10.08.2008
	 */
	public class EnterFrame {
		private static var _movieclip:Sprite = new Sprite();
		private static var isRun:Boolean = false;
		private static var dict:Dictionary = new Dictionary(true);
		private static var cancel_dict:Dictionary = new Dictionary(true);
		private static var remain:int = 0;
		private static var _frameCount:uint = 0;
		public static function get frameCount():uint{ return _frameCount; }
		
		public static function add(__mc:*, __handler:Function, _groupId:int = 0):void{
			if ( dict[__mc] != undefined ){
				remove(__mc);
			}
			dict[__mc] = __handler;
			remain++;
			if ( remain > 0 ) start();
		}
		
		public static function remove(__mc:*):void{
			if( dict[__mc] == undefined ) return;
			remain--;
			delete dict[__mc];
			if ( remain < 1 ) stop();
		}
		
		public static function pause(__mc:*):void{
			if( dict[__mc] == undefined ) return;
			cancel_dict[__mc] = dict[__mc];
			remain--;
			delete dict[__mc];
		}
		
		
		public static function resume(__mc:*):void{
			if( cancel_dict[__mc] == undefined ) return;
			dict[__mc] = cancel_dict[__mc];
			remain++;
			delete cancel_dict[__mc];
		}
		
		
		public static function pauseAll():void{
			for(var i:* in dict){
				pause(i);
			}
			stop();
		}
		
		public static function resumeAll():void{
			for(var i:* in cancel_dict){
				resume(i);
			}
			start();
		}
		
		private static function start():void{
			if ( isRun ) return;
			isRun = true;
			_movieclip.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			_movieclip.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
		}
		
		private static function stop():void{
			if ( !isRun ) return;
			isRun = false;
			_movieclip.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private static function onEnterFrameHandler(e:Event):void{
			_frameCount++;
			var fn:Function;
			var arg:Array = [e];
			var cnt:int = 0;
			for(var i:* in dict){
				cnt++;
				fn = dict[i];
				fn.apply( i, arg );
			}
			if ( cnt < 1 ) stop();
		}
	}
	
}
