package net.satcy.popforge
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.Sample;
	import de.popforge.format.wav.WavFormat;
	
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	public class PopforgeUtil
	{
		public static function sound2WavFormat(src:Sound, dstChannelCount:int=1, length:int=1048576, startPosition:int=0):WavFormat{
			var wave:ByteArray = new ByteArray(), i:int, imax:int;
            src.extract(wave, length, startPosition);
            wave.position = 0;
            var dst:Array = [];
            var s:Sample;
            if (dstChannelCount == 2) {
                // stereo
                imax = wave.length >> 3;
                dst.length = imax;
                for (i=0; i<imax; i++) {
                	s = new Sample();
                	s.left = wave.readFloat();
                	s.right = wave.readFloat();
                    dst[i] = s;
                }
            } else {
                // monoral
                imax = wave.length >> 3;
                dst.length = imax;
                for (i=0; i<imax; i++) {
                	s = new Sample();
                	s.left = (wave.readFloat() + wave.readFloat()) * 0.6;
                    dst[i] = s;
                }
            }
            return WavFormat.decode(WavFormat.encode(dst, dstChannelCount, Audio.BIT16, Audio.RATE44100) );
		}

	}
}