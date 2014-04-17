package net.satcy.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class Mosaic extends Bitmap
	{
		private var _rate:Number = 1;
		private var _original:BitmapData;
		public function Mosaic(bmp:BitmapData = null)
		{
			super();
			if ( bmp ) {
				original = bmp;
			}
		}
		
		public function set original(bmp:BitmapData):void{
			_original = bmp.clone();
			bitmapData = bmp.clone();
		}
		
		public function get original():BitmapData{
			return _original;
		}
		
		public function set rate(num:Number):void{
			_rate = num;
			var bmp:BitmapData = new BitmapData(_original.width*_rate, _original.height*_rate, true, 0);
			var mat:Matrix = new Matrix(_rate, 0, 0, _rate);
			bmp.draw(_original, mat);
			this.bitmapData.fillRect(this.bitmapData.rect, 0);
			mat = new Matrix(1/_rate, 0, 0, 1/_rate);
			this.bitmapData.draw(bmp, mat);
		}
		
		public function get rate():Number{
			return _rate;
		}

	}
}