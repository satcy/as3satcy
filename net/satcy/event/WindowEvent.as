package net.satcy.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import net.satcy.util.LayOutUtil;
	
	public class WindowEvent
	{
		private static var d:EventDispatcher;
		
		public static const FOCUS:String = "window_focus";
		public static const BLUR:String = "window_blur";
		
		
		public static function addEventListener(type:String, func:Function):void{
			if ( !d ) init();
			removeEventListener(type, func);
			d.addEventListener(type, func);
		}
		
		public static function removeEventListener(type:String, func:Function):void{
			if ( !d ) init();
			d.removeEventListener(type, func);
		}
		
		private static function init():void{
			if ( d ) return;
			d = new EventDispatcher();
			if ( LayOutUtil.stage ) {
				LayOutUtil.stage.addEventListener(Event.ACTIVATE, onFocusHandler);
				LayOutUtil.stage.addEventListener(Event.DEACTIVATE, onBlurHandler);
			}
			if (!ExternalInterface.available) return;
			ExternalInterface.addCallback('handleOnBlur', handleOnBlur);
			ExternalInterface.addCallback('handleOnFocus', handleOnFocus);
			
			ExternalInterface.call(
				'function() {' + 
					'var obj = document.getElementById("' + ExternalInterface.objectID + '");' + 
					'if (/*@cc_on!@*/false) {' +
					'document.onfocusout = function() {obj.handleOnBlur();};' + 
					'document.onfocusin = function() {obj.handleOnFocus();};' + 
					'} else {' + 
					'window.onblur = function() {obj.handleOnBlur();};' + 
					'window.onfocus = function() {obj.handleOnFocus();};' + 
					'}' +
				'}'
//				'function() {' + 
//					'var obj = document.getElementById("' + ExternalInterface.objectID + '");' + 
//					'window.onblur = function() {obj.handleOnBlur();};' + 
//					'window.onfocus = function() {obj.handleOnFocus();};' +
//				'}'
			);
			
		}
		private static function onFocusHandler(e:Event):void{
			handleOnFocus();
		}
		private static function onBlurHandler(e:Event):void{
			handleOnBlur();
		}
		
		private static function handleOnBlur():void {
			d.dispatchEvent(new Event(WindowEvent.BLUR, true, true));
		}
		
		private static function handleOnFocus():void{
			d.dispatchEvent(new Event(WindowEvent.FOCUS, true, true));
		}
	}
}