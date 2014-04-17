package net.satcy.sound
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import net.satcy.event.WindowEvent;
	
	public class SoundVolume
	{
		static private var _pan:Number = 0;
		static private var _volume:Number = 1;
		static private var _window_blur_adjust:Number = 1;
		static public function set volume(num:Number):void{
			_volume = num;
			SoundMixer.soundTransform = new SoundTransform(_volume*_window_blur_adjust, _pan);
		} 
		static public function get volume():Number{
			return _volume;
		} 
		
		static public function set pan(num:Number):void{
			_pan = num;
			SoundMixer.soundTransform = new SoundTransform(_volume*_window_blur_adjust, _pan);
		} 
		static public function get pan():Number{
			return _pan;
		} 
		
		static public function enableAutoAdjust():void{
			disableAutoAdjust();
			WindowEvent.addEventListener(WindowEvent.BLUR, onBlurHandler);
			WindowEvent.addEventListener(WindowEvent.FOCUS, onFocusHandler);
		}
		
		static public function disableAutoAdjust():void{
			WindowEvent.removeEventListener(WindowEvent.BLUR, onBlurHandler);
			WindowEvent.removeEventListener(WindowEvent.FOCUS, onFocusHandler);
		}
		
		private static function onBlurHandler(e:Event):void{
			_window_blur_adjust = 0;
			volume = volume;
		}
		
		private static function onFocusHandler(e:Event):void{
			_window_blur_adjust = 1;
			volume = volume;
		}
	}
}