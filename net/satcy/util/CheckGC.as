/*
The MIT License

Copyright (c) 2007- Satoshi HORII/rhisomztiks co.,ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package net.satcy.util {
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class CheckGC {
		private static var dict:Dictionary = new Dictionary(true);
		private static var timer:Timer;
		public static var isRunning:Boolean = false;
		public static function init():void{
			stop();
			isRunning = false;
			dict = new Dictionary(true);
		}
		
		public static function add( o:* ):void{
			dict[o] = 0;
		}
		
		public static function start(_interval:Number = 500):void{
			timer = new Timer(_interval, 0);
			timer.addEventListener(TimerEvent.TIMER, check);
			timer.start();
			isRunning = true;
		}
		
		public static function stop():void{
			timer.removeEventListener(TimerEvent.TIMER, check);
			timer.stop();	
			timer = null;
		}
		
		private static function check(e:TimerEvent):void{
			trace( "++++++CheckGC : hold object num: " + DictionaryUtil.getLength( dict ) );
		}
	}
}
