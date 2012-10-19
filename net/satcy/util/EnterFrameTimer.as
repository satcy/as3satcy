package net.satcy.util{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	public class EnterFrameTimer extends EventDispatcher{
		
		private var fn:Function;
		private var time:Number = 0;
		private var p_timer:Number = 0;
		private var _auto:Boolean = true;
		
		public function EnterFrameTimer(_fn:Function, _duration:Number, _auto_start:Boolean = true){
			super();
			fn = _fn;
			time = _duration;
			_auto = _auto_start;
			if ( _auto_start ) {
				p_timer = flash.utils.getTimer();
				EnterFrame.add(this, onEnterFrameHandler);
			}
		}
		
		public function destroy():void{
			EnterFrame.remove(this);
			fn = null;
		}
		
		public function set duration(_num:Number):void{ time = _num; }
		public function get duration():Number{ return time; }
		
		public function update(_time:Number):void{
			if ( _auto ) return;
			var n_timer:Number = _time;
			var d_timer:Number = n_timer - p_timer;
			if ( d_timer >= time ) {
				fn();
				while ( n_timer - p_timer >= time ) p_timer += time;
			} else if ( d_timer < 0 ) {
				p_timer = 0;
			}
		}
		
		private function onEnterFrameHandler(e:Event):void{
			var n_timer:Number = flash.utils.getTimer();
			var d_timer:Number = n_timer - p_timer;
			if ( d_timer >= time ) {
				fn();
				while ( n_timer - p_timer >= time ) p_timer += time;
				//p_timer = n_timer;
			}
		}
		
	}
}