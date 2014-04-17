package net.satcy.ui
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	public class MouseUpOutSide extends EventDispatcher
	{
		private static var stage:Stage;
		public static function init(_stage:Stage):void
		{
			if (!ExternalInterface.available) return;
			stage = _stage;
			ExternalInterface.addCallback('handleMouseUpOutSide', handleMouseUpOutSide);
			ExternalInterface.call(
				'function() {' + 
					'var obj2 = document.getElementById("' + ExternalInterface.objectID + '");' +  
					'var onup = function(event) {' +  
						'obj2.handleMouseUpOutSide();console.log("mouseup")' +  
					'};' + 
					'obj2.onmouseover = function() {' + 
						'if (document.addEventListener) document.removeEventListener("mouseup", onup, true);' + 
						'this.onmouseup = null;' +
					'};' +
					'obj2.onmouseout = function() {' + 
						'if (document.addEventListener) document.addEventListener("mouseup", onup, true);' + 
						'this.onmouseup = onup;' +
					'};' +
				'}'
			);
		}
		
		private static function handleMouseUpOutSide():void {
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0));
		}
		
	}
}