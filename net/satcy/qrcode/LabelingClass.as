package net.satcy.qrcode {
    import flash.display.*;
    import flash.geom.*;
    
    public class LabelingClass extends Object{
    	private var startColor:uint;

        private var pickedColor:Array;

        private var bmp:BitmapData;

        private var pickedRects:Array;

        private var minSize:uint;
        
        public function LabelingClass()
        {
            pickedRects = [];
            pickedColor = [];
            super();
            return;
        }

        

        private function _paintNextLabel(_bmp:BitmapData, _color:uint, _fili_color:uint):Boolean
        {
            var _color_rect:Rectangle;
            var _a_bmp:BitmapData;
            var _a_rect:Rectangle;

            
            _color_rect = _bmp.getColorBoundsRect(4294967295, _color);
            
            if (_color_rect.width > 0 && _color_rect.height > 0)
            {
                _a_bmp = new BitmapData(_color_rect.width, 1);
                _a_bmp.copyPixels(_bmp, new Rectangle(_color_rect.topLeft.x, _color_rect.topLeft.y, _color_rect.width, 1), new Point(0, 0));
                _a_rect = _a_bmp.getColorBoundsRect(4294967295, _color);
                _bmp.floodFill(_a_rect.topLeft.x + _color_rect.topLeft.x, _a_rect.topLeft.y + _color_rect.topLeft.y, _fili_color);
                return true;
            }
            return false;
        }

        public function Labeling(arg1:BitmapData, arg2:uint=10, arg3:uint=4294967295, arg4:Boolean=true):void
        {
            minSize = arg2;
            startColor = arg3;
            if (arg4)
            {
                bmp = arg1;
            }
            else 
            {
                bmp = arg1.clone();
            }
            process();
            return;
        }

        public function getColors():Array
        {
            return pickedColor;
        }

        private function process():void
        {
            var loc1:uint;
            var loc2:Rectangle;
            var loc3:Rectangle;

            loc1 = startColor;
            while (_paintNextLabel(bmp, 4278190080, loc1)) 
            {
                loc2 = bmp.getColorBoundsRect(4294967295, loc1);
                if (loc2.width > minSize && loc2.height > minSize)
                {
                    loc3 = loc2.clone();
                    pickedRects.push(loc3);
                    pickedColor.push(loc1);
                }
                loc1 = (loc1 - 1);
            }
            return;
        }

        public function getRects():Array
        {
            return pickedRects;
        }

        
    }
}

