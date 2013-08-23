package net.satcy.util
{
	public class Color
	{
		private var _r:Number = 0;
		private var _g:Number = 0;//0-255
		private var _b:Number = 0;
		private var _hue:Number = 0;//0-1
		private var _saturation:Number = 0;//0-1
		private var _brightness:Number = 0;//0-1
		private var _alpha:Number = 1;//0-1
		private var _hex:uint = 0;
		private var _hexWithAlpha:uint = 0;
		public function set r(_num:Number):void{
			_r = _num;
			calcRgb2Hsb();
			calcHex();
		}
		public function get r():Number{ return _r; }
		public function set g(_num:Number):void{
			_g = _num;
			calcRgb2Hsb();
			calcHex();
		}
		public function get g():Number{ return _g; }
		public function set b(_num:Number):void{
			_b = _num;
			calcRgb2Hsb();
			calcHex();
		}
		public function get b():Number{ return _b; }

		public function set hue(_num:Number):void{
			_hue = _num;
			calcHsb2Rgb();
			calcHex();
		}
		public function get hue():Number{ return _hue; }
		public function set saturation(_num:Number):void{
			_saturation = _num;
			calcHsb2Rgb();
			calcHex();
		}
		public function get saturation():Number{ return _saturation; }
		public function set brightness(_num:Number):void{
			_brightness = _num;
			calcHsb2Rgb();
			calcHex();
		}
		public function get brightness():Number{ return _brightness; }
		
		
		
		
		public function set hex(_num:uint):void{
			_hex = _num;
			calcHex2Rgb();
			calcRgb2Hsb();
			calcHex();
		}
		public function get hex():uint{ return _hex; }
		
		public function set hexWithAlpha(_num:uint):void{
			_hexWithAlpha = _num;
			calcHex2Rgb();
			calcRgb2Hsb();
			calcHex();
		}
		public function get hexWithAlpha():uint{ return _hexWithAlpha; }
		
		
		public function Color(red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 1)
		{
				_alpha = alpha;
				_r = red;
				_g = green;
				this.b = blue;
		}
		
		private function calcHex():void{
			var _a:uint = _alpha*255;
			var __r:uint = _r;
			var __g:uint = _g;
			var __b:uint = _b;
			_hex = __r << 16 | __g << 8 | __b;
			_hexWithAlpha = _a << 24 | __r << 16 | __g << 8 | __b;
		}
		
		private function calcRgb2Hsb():void{
			var _hsb:Array = ColorUtil.RGBtoHSB(int(_r), int(_g), int(_b));
			_hue = _hsb[0];
			_saturation = _hsb[1];
			_brightness = _hsb[1];
		}
		
		private function calcHsb2Rgb():void{
			var _rgb:uint = ColorUtil.HSBtoRGB(_hue, _saturation, _brightness);
			_r = _rgb >> 16 & 0xFF;
			_g = _rgb >> 8 & 0xFF;
			_b = _rgb & 0xFF;
		}
		
		private function calcHex2Rgb():void{
			var _rgb:uint = _hex;
			_r = _rgb >> 16 & 0xFF;
			_g = _rgb >> 8 & 0xFF;
			_b = _rgb & 0xFF;
		}
	}
}