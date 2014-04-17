package net.satcy.ui{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	public class MouseWheel extends EventDispatcher {
		public function MouseWheel() {
			if (!ExternalInterface.available) return;
			ExternalInterface.addCallback('handleMouseWheel', handleMouseWheel);
			ExternalInterface.call(
				'function() {' + 
					'var obj = document.getElementById("' + ExternalInterface.objectID + '");' +  
					'var wheel = function(event) {' +  
						'if (!event) event = window.event;' + 
						'var delta = event.wheelDelta?' +
	        				'(event.wheelDelta > 0 ? 1 : -1) : (event.detail > 0 ? -1 : 1);' + 
						'if (delta) obj.handleMouseWheel(delta);' +  
						'if (event.preventDefault) event.preventDefault();' + 
						'else event.returnValue = false;' + 
					'};' + 
					'obj.onmouseover = function() {' + 
						'if (window.addEventListener) window.addEventListener("DOMMouseScroll", wheel, false);' + 
						'this.onmousewheel = wheel;' +
					'};' +
					'obj.onmousemove = function() {' + 
						'this.onmouseover();' + 
						'this.onmousemove = null;' + 
					'};' +
					'obj.onmouseout = function() {' + 
						'if (window.addEventListener) window.removeEventListener("DOMMouseScroll", wheel, false);' + 
						'this.onmousewheel = null;' +
					'};' +
				'}'
			);
		}
		
		public function destroy():void{
			if (!ExternalInterface.available) return;
			ExternalInterface.call(
				'function() {' + 
					'var obj = document.getElementById("' + ExternalInterface.objectID + '");' +
					'obj.onmouseout();' +
				'}'
			);
		}
		
		private function handleMouseWheel(delta:Number):void {
			dispatchEvent(
				new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, 0, 0, null, false, false, false, false, delta)
			);
		}
	}
}