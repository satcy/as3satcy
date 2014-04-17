package net.satcy.popforge
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.processor.fl909.voices.Voice;
	
	import flash.media.Sound;
	
	public class EasyPopforge
	{
		private var buffer:AudioBuffer;
		private var _audio:SimpleAudio;
		private var _onBuffer:Function;
		private var _waves:Object;
		
		public function EasyPopforge(onBuffer:Function = null)
		{
			buffer = new AudioBufferFP10(1, Audio.STEREO, Audio.BIT16, Audio.RATE44100);
			buffer.onComplete = onAudioBufferComplete;
			buffer.start();
			_audio = new SimpleAudio();
			_onBuffer = onBuffer;
		}
		
		public function registerSound(_name:String, _snd:Sound):void{
			if ( _waves == null ) _waves = {};
			_waves[_name] = PopforgeUtil.sound2WavFormat(_snd, 2, (_snd.length/1000)*Audio.RATE44100);
		}
		
		public function playSound(_name:String):void{
			if ( _waves[_name] == null ) return;
			new Voice(0, 1);
		}
		
		private function onAudioBufferComplete(buffer:AudioBuffer):void{
			var samples:Array = buffer.getSamples();
			if ( _audio ) _audio.processAudio(samples);
			if ( _onBuffer != null ) _onBuffer(samples);
			buffer.update();
		}
		
		
	}
}