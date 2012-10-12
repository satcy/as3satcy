package net.satcy.popforge
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class AudioBufferFP10 extends AudioBuffer
	{
		protected var buff:Sound;
		protected var buffChannel:SoundChannel;
		public function AudioBufferFP10(multiple:uint, channels:uint, bits:uint, rate:uint)
		{
			super(multiple, channels, bits, rate);
		}
		
		
		override public function start():Boolean{
			if( playing ) return false;
			
			buff = new Sound();
			buff.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
    		buffChannel = buff.play();
			
			if( onStart != null )
				onStart( this );
			
			return true;
		}
		
		override public function stop():Boolean{
			buffChannel.stop();
			buffChannel = null;
			buff.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
			buff = null;
			
			return super.stop();
		}
		override public function update(): ByteArray
		{
			return null;
		}
		
		override protected function init(): void
		{
			$isInit = false;
			
			if( multiple == 0 )
				throw new Error( 'Buffer must have a length greater than 0.' );
			
			var i: int;
			
			bytes = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			//-- compute number of bytes
			switch( rate )
			{
				case Audio.RATE44100:
					_numSamples = ( UNIT_SAMPLES_NUM * multiple ) ; break;
				case Audio.RATE22050:
					_numSamples = ( UNIT_SAMPLES_NUM * multiple ) >> 1; break;
				case Audio.RATE11025:
					_numSamples = ( UNIT_SAMPLES_NUM * multiple ) >> 2; break;
				case Audio.RATE5512:
					_numSamples = ( UNIT_SAMPLES_NUM * multiple ) >> 3; break;
			}
			
			//-- compute number of bytes
			_numBytes = _numSamples;
			if( channels == Audio.STEREO ) _numBytes <<= 1;
			if( bits == Audio.BIT16 ) _numBytes <<= 1;

			samples = new Array();
			for( i = 0 ; i < _numSamples ; i++ )
				samples.push( new Sample() );

			//-- create silent bytes for sync sound
			var syncSamples: ByteArray = new ByteArray();
			
			switch( bits )
			{
				case Audio.BIT16:
					syncSamples.length = ( _numSamples - 1 ) << 1; break;
				case Audio.BIT8:
					syncSamples.length = _numSamples - 1;
					for( i = 0 ; i < syncSamples.length ; i++ )
						syncSamples[i] = 128;
					break;
			}
			
			onGenerateSyncSound(null);
			
			playing = false;
		}
		
		public function onSampleDataHandler(event:SampleDataEvent):void
		{
			onComplete( this );
			
		    var i: int;
			var s: Sample;
			var l: Number;
			var r: Number;
		    
		    //trace(channels, bits, _numSamples);
		    
		    switch( channels )
			{
				case Audio.MONO:

					if( bits == Audio.BIT16 )
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = ( s.left + s.right ) / 2;
							
							if( l < -1 ) l = -1;
							else if( l > 1 ) l = 1;
							
							event.data.writeFloat( l );
							event.data.writeFloat( l );
							
							s.left = s.right = 0;
						}
					}
					else
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = ( s.left + s.right ) / 2;
							
							if( l < -1 ) l = -1;
							else if( l > 1 ) l = 1;
							
							event.data.writeFloat( l );
							event.data.writeFloat( l );
							
							s.left = s.right = 0;
						}
					}
					break;
					
				case Audio.STEREO:

					if( bits == Audio.BIT16 )
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							r = s.right;
							
							if( l < -1 ) l = -1;
							else if( l > 1 ) l = 1;
							
							event.data.writeFloat( l );
			
							if( r < -1 ) r = -1;
							else if( r > 1 ) r = 1;
							
							event.data.writeFloat( r );
							
							s.left = s.right = 0;
						}
					}
					else
					{
						for( i = 0 ; i < _numSamples ; i++ )
						{
							s = samples[i];
							l = s.left;
							r = s.right;
							
							if( l < -1 ) l = -1;
							else if( l > 1 ) l = 1;
							event.data.writeFloat( l );
			
							if( r < -1 ) r = -1;
							else if( r > 1 ) r = 1;
							event.data.writeFloat( r );
							
							s.left = s.right = 0;
						}
					}
					break;
			}
		    /*
		    for ( c = 0; c < 4094; c++ ) 
		    {
		        //_readOffset = (_readOffset + 1) % dataLength;
		         
		        event.data.writeFloat(Math.random()-0.5);
		        event.data.writeFloat(Math.random()-0.5);
		    }
		    */
			
		}
	}
}