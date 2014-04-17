package net.satcy.popforge
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.voices.Voice;
	import de.popforge.format.wav.WavFormat;

	public class VoiceSE extends Voice
	{
		private var _wav:WavFormat;
		public function VoiceSE(_wav:WavFormat, start:int, volume:Number=0)
		{
			super(start, volume);
			_wav = wav;
			this.monophone = (_wav.channels>1) ? false : true;
			length = _wav.samples.length;
		}
		
		override public function processAudioAdd(samples:Array):Boolean{
			var n:int = samples.length;
			
			var sample:Sample;
			var input:Sample;
			
			var levelValue:Number = volume;
			
			var tunePos:Number;
			var tunePosInt:int;
			
			for ( var i:int = start; i < n; i++ ) {
				if ( i>= stop ) return true;
				
				sample = samples[i];
				tunePos = position++;
				tunePosInt = tunePos;
				
				if ( tunePosInt >= length - 1 ) return true;
				
				input = _wav.samples[tunePosInt];
				sample.left += input.left*levelValue;
				sample.right += input.right*levelValue;
			}
			
			start = 0;
			
			return false;
		}
		
		public function set _volume(_num:Number):void{
			volume = _num;
		}
		
		public function get _volume():Number{
			return volume;
		}
		
		override public function getChannel():int{
			return _wav.channels;
		}
		
	}
}