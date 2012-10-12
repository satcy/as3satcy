package net.satcy.util{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Fps extends Sprite{
		public static var ms:Number = 0;
		public static var multiply:Number = 1;
		
		private var timer:Timer;
		private var maxFrameCount:Number;
		//private var onFpsFunc:Function;
		private var frame_count:Number = 0;
		
		public function Fps(){
			//onFpsFunc = _fn;
		}
		
		public function start():void{
			timer = new Timer(1000, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			EnterFrame.add(this, onEnterFrameHandler);
			timer.start();
			frame_count = 0;
		}
		public function stop():void{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
			EnterFrame.remove(this);
		}
		public function destroy():void{
			stop();
			//onFpsFunc = null;
			timer = null;
		}
		private function onEnterFrameHandler(e:Event):void{
			//trace(frame_count);
			frame_count++;
		}
		private function onTimerHandler(e:TimerEvent):void{
			Fps.ms = 1000.0/frame_count;
			Fps.multiply = Fps.ms/33.33333333;
			//onFpsFunc((frame_count==0)? 1 : frame_count);
			frame_count = 0;
		}
	}
}