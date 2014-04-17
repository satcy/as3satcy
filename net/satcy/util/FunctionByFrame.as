package net.satcy.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class FunctionByFrame extends EventDispatcher{
		private var arr:Array;
		public function FunctionByFrame()
		{
		}
		public function exec():void{
			EnterFrame.add(this, onEnterFrameHandler);
			onEnterFrameHandler(null);
		}
		public function stop():void{
			EnterFrame.remove(this);
			arr = [];
			arr = null;
		}
		public function pause():void{
			EnterFrame.pause(this);
		}
		public function resume():void{
			EnterFrame.resume(this);
		}
		
		public function push(_fn:Function):void{
			if ( !arr ) arr = [];
			arr.push(_fn);
		}
		
		private function onEnterFrameHandler(e:Event):void{
			if ( arr == null || arr.length == 0 ){
				this.dispatchEvent(new Event(Event.COMPLETE, false));
				stop();
			}else{
				var fn:Function = arr[0];
				fn();
				arr.shift();
			}
		}
	}
}