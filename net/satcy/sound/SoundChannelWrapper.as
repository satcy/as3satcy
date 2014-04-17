package net.satcy.sound
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundChannelWrapper
	{
		private var _sc:SoundChannel;
		private var _vol:Number = 1;
		private var _internalVolume:Number = 1;
		public function set internalVolume(val:Number):void {
			_internalVolume = val;
			volume = _vol;
		}
		private var _pan:Number = 0;
		public function SoundChannelWrapper(sc:SoundChannel)
		{
			_sc= sc;
			super();
		}
		
		public function set volume(vol:Number):void{
			_vol = vol;
			_sc.soundTransform = new SoundTransform(_vol*_internalVolume, _pan);
		}
		
		public function get volume():Number{
			return _vol;
		}
		
		public function set pan(p:Number):void{
			_pan = p;
			_sc.soundTransform = new SoundTransform(_vol*_internalVolume, _pan);
		}
		
		public function get pan():Number{
			return _pan;
		}
		
		public function get position():Number{
			return _sc.position;
		}
	}
}