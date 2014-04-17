package net.satcy.bitmap
{
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class MatrixTransfomableBitmapDataSprite extends Sprite
	{
		private var _m:Matrix;
		
		public var matrixScaleX:Number = 1;
		public var matrixScaleY:Number = 1;
		public var matrixSkewX:Number = 0;
		public var matrixSkewY:Number = 0;
		public var matrixTranslateX:Number = 0;
		public var matrixTranslateY:Number = 0;
		public var matrixRotate:Number = 0;
		
		private var _bitmapdata:BitmapData;
		public function get bitmapdata():BitmapData { return _bitmapdata; }
		public function set bitmapdata(bmp:BitmapData):void{
			_bitmapdata = bmp;
			if ( !_bitmapdata ) return;
			_bitmapdata.encode(_bitmapdata.rect, new JPEGEncoderOptions(), _ba_src);
			
			_headerSize = 417;
			var byte : uint;
			while(_ba_src.bytesAvailable){
				byte = _ba_src.readUnsignedByte();
				if(byte == 0xFF){
					byte = _ba_src.readUnsignedByte();
					if(byte == 0xDA){
						_headerSize = _ba_src.position + _ba_src.readShort();
						break;
					}
					_ba_src.position--;
				}
			}
		}
		
		public static const NULL_BYTE : int = 0;
		
		//private var _ba_loader : Loader = new Loader();
		
		private var _ba_src:ByteArray;
		private var _ba_dst:ByteArray;
		private var _headerSize:int = 417;
		
		private var _seed : Number = 1.0;
		private var _maxIterations : int = 512;
		private var _glitchiness:Number = 0;
		
		
		public function MatrixTransfomableBitmapDataSprite(bmp:BitmapData = null)
		{
			super();
			_ba_src = new ByteArray();
			_ba_dst = new ByteArray();
			bitmapdata = bmp;
		}
		
		public function get glitchiness() : Number
		{
			return _glitchiness;
		}

		public function set glitchiness(value : Number) : void
		{
			_glitchiness = value < 0.0 ? 0.0 : value > 1.0 ? 1.0 : value;
			glitch();
		}

		public function get maxIterations() : int
		{
			return _maxIterations;
		}

		public function set maxIterations(value : int) : void
		{
			_maxIterations = value;
			glitch();
		}

		public function get seed() : Number
		{
			return _seed;
		}

		public function set seed(value : Number) : void
		{
			_seed = value;
			glitch();
		}
		
		public function destroy():void{
			
			//_ba_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			//_ba_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			//_ba_loader = null;
			
			if ( _ba_src ) _ba_src.clear();
			_ba_src = null;
			
			if ( _ba_dst ) _ba_dst.clear();
			_ba_dst = null;
			
			if ( _bitmapdata ) _bitmapdata.dispose();
			_bitmapdata = null;
		}

		public function redraw():void{
			if ( !_m ) _m = new Matrix();
			_m.identity();
			_m.a = matrixScaleX;
			_m.b = matrixSkewX;
			_m.c = matrixSkewY;
			_m.d = matrixScaleY;
			_m.tx = matrixTranslateX;
			_m.ty = matrixTranslateY;
			_m.rotate(matrixRotate);
			
			if ( _bitmapdata ) {
				this.graphics.clear();
				this.graphics.beginBitmapFill(_bitmapdata, _m);
				this.graphics.drawRect(0,0,_bitmapdata.width,_bitmapdata.height);
			}
		}	
		
		private function glitch():void{
		
			if(!_ba_src) return;
			//_ba_loader.unload();
			_ba_src.position = 0;
			
			_ba_dst.length = 0;
			_ba_dst.writeBytes(_ba_src, 0, _ba_src.bytesAvailable);
			
			if(_glitchiness > 0.0) {
				var length : int = _ba_dst.length - _headerSize - 2;
				var amount : int = int(_glitchiness * _maxIterations);
				var random : Number = _seed;
				
				for (var i : int = 0;i < amount;i++)
				{
					random = ( random * 16807 ) % 2147483647;
					
					_ba_dst.position = _headerSize + int(length * random * 4.656612875245797e-10);
					_ba_dst.writeByte(NULL_BYTE);
				}
			}
			
			var ld:Loader = new Loader();
			//ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			//ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onBytesLoaded);
			ld.loadBytes(_ba_dst);
			
		}
		
		private function onBytesLoadError(event : IOErrorEvent) : void {
			
		}

		private function onBytesLoaded(event : Event) : void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onBytesLoadError);
			
			if ( !_ba_src ) return;
			if ( _bitmapdata ) _bitmapdata.dispose();
			_bitmapdata = event.target.content['bitmapData'];
			
			redraw();
			
		}
	}
}