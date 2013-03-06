package net.satcy.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.satcy.util.ArrayUtil;
	import net.satcy.util.EnterFrame;
	import net.satcy.util.LayOutUtil;
	
	public class OnStageNotifier
	{
		public static const INTO:String = "on_stage_into";
		
		private static const DISP:EventDispatcher = new EventDispatcher();
		
		private static var arr:Array = [];
		
		public static function addTarget(_target:DisplayObject, _fn:Function):void{
			arr.push(_target);
			_target.removeEventListener(INTO, _fn);
			_target.addEventListener(INTO, _fn);
			if ( arr.length > 0 ) {
				EnterFrame.add(OnStageNotifier, onEnterFrameHandler);
			}
		}
		
		public static function removeTarget(_target:DisplayObject, _fn:Function):void{
			arr = ArrayUtil.deleteItems(arr, _target);
			_target.removeEventListener(INTO, _fn);
			if ( arr.length == 0 ) {
				EnterFrame.remove(OnStageNotifier);
			}
		}
		
		private static function onEnterFrameHandler(e:Event):void{
			var _rect:Rectangle = new Rectangle(0,0,LayOutUtil.sw,LayOutUtil.sh);
			var _pt:Point;
			var _pt2:Point = new Point();
			var _dels:Array = [];
			for each ( var d:DisplayObject in arr ) {
				if ( d.parent ) {
					_pt2.x = d.x;
					_pt2.y = d.y;
					_pt = d.parent.localToGlobal(_pt2);
					if ( _rect.containsPoint(_pt) ) {
						_dels.push(d);
						d.dispatchEvent(new Event(INTO, false, false));
					}
				}
			} 
			arr = ArrayUtil.deleteItemsByArray(arr, _dels);
		}

	}
}