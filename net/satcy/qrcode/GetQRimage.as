package net.satcy.qrcode{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;
    
    import net.satcy.qrcode.event.*;
    
    import org.papervision3d.core.render.sort.NullSorter;
    
    public class GetQRimage extends Sprite{
    	private const _defPoint:Point=new Point(0, 0);

        private var _bmp_data:BitmapData;

        private var _minVersion:uint=1;

        private var _tempMC:Sprite;

        private var rects:Array;

        private var _wid:uint=320;

        private var _hgt:uint=240;

        private var test:Number=1.125;
        //private var test:Number=1;

        private var defD:int=100;

        private var conRed:Array;

        private var _maxVersion:uint=10;

        private var _results:Array;

        private var _resultArray:Array;

        private var _resultImage:BitmapData;
        
        private var _debug_bm:Bitmap;
        
        
        public function GetQRimage(arg1:Sprite)
        {
            _resultImage = new BitmapData(1, 1);
            _resultArray = [];
            _results = [new BitmapData(1, 1), new Array(1)];
            conRed = [1, 0, 0];
            rects = new Array();
            super();
            _tempMC = arg1;
            _wid = _tempMC.width;
            _hgt = _tempMC.height;
            _bmp_data = new BitmapData(_wid, _hgt, true, 4294967295);
            
            _debug_bm = new Bitmap(null);
            this.addChild( _debug_bm );
            return;
        }

        

        private function _getBorderPoints(arg1:BitmapData, arg2:Rectangle, arg3:uint, arg4:uint):Array
        {
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;

            loc5 = 0;
            loc6 = 0;
            loc9 = null;
            loc10 = null;
            loc7 = new BitmapData(arg2.width, 1);
            loc8 = new BitmapData(1, arg2.height);
            loc11 = arg4;
            loc12 = new Array();
            loc13 = 0;
            while (loc13 <= loc11) 
            {
                loc5 = (arg2.width - 1) * loc13 / loc11 + arg2.topLeft.x;
                loc6 = (arg2.height - 1) * loc13 / loc11 + arg2.topLeft.y;
                loc7.copyPixels(arg1, new Rectangle(arg2.topLeft.x, loc6, arg2.width, 1), new Point(0, (0)));
                loc8.copyPixels(arg1, new Rectangle(loc5, arg2.topLeft.y, 1, arg2.height), new Point(0, (0)));
                loc9 = loc8.getColorBoundsRect(4294967295, arg3);
                loc10 = new Point(loc5 + loc9.topLeft.x, arg2.topLeft.y + loc9.topLeft.y);
                loc12.push(loc10);
                loc10 = new Point(loc5 + loc9.topLeft.x + loc9.width, arg2.topLeft.y + loc9.topLeft.y + loc9.height);
                loc12.push(loc10);
                loc9 = loc7.getColorBoundsRect(4294967295, arg3);
                loc10 = new Point(arg2.topLeft.x + loc9.topLeft.x, loc6 + loc9.topLeft.y);
                loc12.push(loc10);
                loc10 = new Point(arg2.topLeft.x + loc9.topLeft.x + loc9.width, loc6 + loc9.topLeft.y + loc9.height);
                loc12.push(loc10);
                loc13 = (loc13 + 1);
            }
            return loc12;
        }

        private function toGray(arg1:BitmapData, arg2:BitmapData, arg3:Rectangle, arg4:Point, arg5:Number=2.5):void
        {
            var loc6:*;
            var loc7:*;
            

            loc6 = [arg5 * 0.298912, arg5 * 0.586611, arg5 * 0.114478];
            loc7 = new ColorMatrixFilter([loc6[0], loc6[1], loc6[2], 0, 0, loc6[0], loc6[1], loc6[2], 0, 0, loc6[0], loc6[1], loc6[2], 0, 0, 0, 0, 0, 0, 255]);
            arg2.applyFilter(arg1, arg3, arg4, loc7);
            
            //_debug_bm.bitmapData = arg2.clone();
            
            return;
        }

        private function Binalization(arg1:BitmapData, arg2:uint=4294967295):void{
        	//trace(Number(4278190080).toString(16));
        	trace(Number(arg2).toString(16));
        	
            arg1.threshold(arg1, arg1.rect, new Point(0, 0), "<", arg2, 4278190080, 4294967295);
            arg1.threshold(arg1, arg1.rect, new Point(0, 0), ">=", arg2, 4294967295, 4294967295);
            
            _debug_bm.bitmapData = arg1;
            
            return;
        }

        private function getVersion(arg1:BitmapData):Object
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;

            loc2 = 0;
            loc3 = 0;
            loc9 = 0;
            loc10 = 0;
            loc14 = null;
            loc15 = null;
            loc16 = 0;
            loc17 = 0;
            loc18 = NaN;
            loc19 = 0;
            loc20 = NaN;
            loc21 = 0;
            loc22 = 0;
            arg1.lock();
            loc2 = 10;
            loc3 = 16777215;
            while (loc3 == 16777215) 
            {
                loc2 = (loc2 + 1);
                loc3 = arg1.getPixel(loc2, loc2);
            }
            loc4 = arg1.getColorBoundsRect(4294967295, 4278190080 + loc3);
            loc2 = 10;
            loc3 = 16777215;
            while (loc3 == 16777215) 
            {
                loc2 = (loc2 + 1);
                loc3 = arg1.getPixel(arg1.width - loc2, loc2);
            }
            loc5 = arg1.getColorBoundsRect(4294967295, 4278190080 + loc3);
            loc2 = 10;
            loc3 = 16777215;
            while (loc3 == 16777215) 
            {
                loc2 = (loc2 + 1);
                loc3 = arg1.getPixel(loc2, arg1.height - loc2);
            }
            loc6 = arg1.getColorBoundsRect(4294967295, 4278190080 + loc3);
            loc7 = new Point(13, loc4.topLeft.y + loc4.height);
            loc8 = 0;
            loc11 = 0;
            loc12 = -5;
            while (loc12 <= 0) 
            {
                loc9 = 0;
                loc14 = [];
                loc16 = (loc15 = arg1.getPixels(new Rectangle(loc7.x, loc7.y + loc12, arg1.width - 26, 1)))[1];
                loc17 = loc15[(4 * (arg1.width - 26 - 1) + 1)];
                if (!(loc16 == 255) && !(loc17 == 255))
                {
                    loc10 = loc16;
                    loc2 = 1;
                    while (loc2 < arg1.width - 24) 
                    {
                        if (!((loc22 = loc15[(4 * loc2 + 1)]) == loc10))
                        {
                            loc9 = (loc9 + 1);
                            loc10 = loc22;
                        }
                        if (loc22 != 255)
                        {
                            if (loc11 > 0)
                            {
                                loc14.push([loc11]);
                                loc11 = 0;
                            }
                        }
                        else 
                        {
                            loc11 = (loc11 + 1);
                        }
                        loc2 = (loc2 + 1);
                    }
                    loc18 = 0;
                    loc19 = 0;
                    while (loc19 < loc14.length) 
                    {
                        loc18 = loc18 + Number(loc14[loc19]);
                        loc19 = (loc19 + 1);
                    }
                    loc20 = loc18 / loc14.length;
                    loc21 = 0;
                    loc19 = 0;
                    while (loc19 < loc14.length) 
                    {
                        if (!(loc14[loc19] > loc20 * 0.5 && loc14[loc19] < loc20 * 1.5))
                        {
                            loc21 = (loc21 + 1);
                        }
                        loc19 = (loc19 + 1);
                    }
                    if (loc8 < loc9 && loc21 == 0)
                    {
                        loc8 = loc9;
                    }
                }
                ++loc12;
            }
            loc8 = Math.floor((loc8 - 3 - 6) * 0.25) + 1;
            loc7 = new Point(loc4.topLeft.x + loc4.width, 13);
            loc13 = 0;
            loc11 = 0;
            loc12 = -5;
            while (loc12 <= 0) 
            {
                loc9 = 0;
                loc14 = [];
                loc16 = (loc15 = arg1.getPixels(new Rectangle(loc7.x + loc12, loc7.y, 1, arg1.height - 26)))[1];
                loc17 = loc15[(4 * (arg1.height - 26 - 1) + 1)];
                if (!(loc16 == 255) && !(loc17 == 255))
                {
                    loc10 = loc16;
                    loc2 = 1;
                    while (loc2 < arg1.height - 24) 
                    {
                        if (!((loc22 = loc15[(4 * loc2 + 1)]) == loc10))
                        {
                            loc9 = (loc9 + 1);
                            loc10 = loc22;
                        }
                        if (loc22 != 255)
                        {
                            if (loc11 > 0)
                            {
                                loc14.push([loc11]);
                                loc11 = 0;
                            }
                        }
                        else 
                        {
                            loc11 = (loc11 + 1);
                        }
                        loc2 = (loc2 + 1);
                    }
                    loc18 = 0;
                    loc19 = 0;
                    while (loc19 < loc14.length) 
                    {
                        loc18 = loc18 + Number(loc14[loc19]);
                        loc19 = (loc19 + 1);
                    }
                    loc20 = loc18 / loc14.length;
                    loc21 = 0;
                    loc19 = 0;
                    while (loc19 < loc14.length) 
                    {
                        if (!(loc14[loc19] > loc20 * 0.5 && loc14[loc19] < loc20 * 1.5))
                        {
                            loc21 = (loc21 + 1);
                        }
                        loc19 = (loc19 + 1);
                    }
                    if (loc13 < loc9 && loc21 == 0)
                    {
                        loc13 = loc9;
                    }
                }
                ++loc12;
            }
            loc13 = Math.floor((loc13 - 3 - 6) * 0.25) + 1;
            if (!(loc8 == loc13 && loc8 >= _minVersion && loc8 <= _maxVersion))
            {
                loc8 = 0;
            }
            arg1.unlock();
            return {"cellSize":(loc5.x + loc5.width - loc4.x) / (loc8 * 4 + 17), "version":loc8, "topLeftRect":loc4, "topRightRect":loc5, "bottomLeftRect":loc6};
        }

        private function getThreshold(arg1:BitmapData):int
        {
            var loc2:Rectangle;
            var loc3:BitmapData;
            var loc4:ByteArray;
            var loc5:Number;
            var loc6:Number;

            loc2 = new Rectangle(arg1.width * 0.5, 0, 1, arg1.height);
            loc3 = new BitmapData(1, arg1.height);
            loc3.copyPixels(arg1, loc2, _defPoint);
            loc3.lock();
            loc4 = loc3.getPixels(loc3.rect);
            loc5 = 0;
            loc6 = 0;
            while (loc6 < arg1.height) 
            {
                loc5 += loc4[(4 * loc6 + 3)];
                loc6 ++;
            }
            loc5 = loc5 / arg1.height;
            return Math.round(loc5);
        }

        public function process():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:BitmapData;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:Array;
            var loc12:Array;
            var loc13:*;
            var loc14:LabelingClass;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;
            var loc24:*;
            var loc25:*;
            var loc26:*;
            var loc27:*;
            var loc28:*;
            var loc29:*;
            var loc30:*;
            var loc31:*;
            var loc32:*;
            var loc33:*;
            var loc34:*;
            var loc35:*;
            var loc36:*;
            var loc37:*;
            var loc38:*;
            var loc39:*;
            var loc40:*;

            loc5 = null;
            loc10 = 0;
            loc11 = null;
            loc12 = null;
            loc16 = 0;
            loc17 = NaN;
            loc18 = null;
            loc19 = 0;
            loc20 = 0;
            loc21 = 0;
            loc22 = null;
            loc23 = 0;
            loc24 = null;
            loc25 = null;
            loc26 = null;
            loc27 = NaN;
            loc28 = null;
            loc29 = null;
            loc30 = null;
            loc31 = NaN;
            loc32 = null;
            loc33 = null;
            loc34 = null;
            loc35 = null;
            loc36 = null;
            loc37 = null;
            loc1 = new Rectangle(0, 0, _wid, _hgt);
            loc2 = new Rectangle(_wid * 0.5 - _hgt * 0.5, 0, _hgt, _hgt);
            loc3 = new BitmapData(_hgt, _hgt);
            loc4 = new BitmapData(_hgt, _hgt);
            loc6 = {"d":defD};
            loc7 = {"d":defD};
            loc8 = {"d":defD};
            loc9 = 0;
            loc13 = new Array();
            _bmp_data.draw(_tempMC);
            loc10 = getThreshold(_bmp_data);
            loc10 = 4278190080 + 65793 * Math.round(loc10);
            toGray(_bmp_data, loc3, loc2, _defPoint, test);
            Binalization(loc3, loc10);
            //this.addChild( new Bitmap(loc3.clone()));
            loc14 = new LabelingClass();
            loc14.Labeling(loc3, 10, 0xFF88FFFE, true);//4287168510
            loc11 = loc14.getRects();
            loc12 = loc14.getColors();
            loc14 = null;
            loc15 = 0;
            
           
            while (loc15 < loc11.length) 
            {
                loc16 = 0;
                loc17 = 0;
                loc5 = loc11[loc15];
                if (!(loc12[loc15] == loc3.getPixel(loc11[loc15].topLeft.x + loc11[loc15].width * 0.5, loc11[loc15].topLeft.y + loc11[loc15].height * 0.5)))
                {
                    loc18 = "";
                    loc19 = 0;
                    loc20 = 0;
                    loc21 = -1;
                    loc22 = [0, (0), (0), 0, (0)];
                    loc23 = 0;
                    while (loc23 < loc11[loc15].width) 
                    {
                        loc20 = loc3.getPixel(loc11[loc15].topLeft.x + loc23, loc11[loc15].topLeft.y + loc11[loc15].height * 0.5) != 16777215 ? 1 : 0;
                        if (!(loc21 == -1 && loc20 == 0))
                        {
                            if (!(loc20 == loc19))
                            {
                                ++loc21;
                                loc19 = loc20;
                                if (loc21 >= 5)
                                {
                                    break;
                                }
                            }
                            loc40 = ((loc38 = loc22)[(loc39 = loc21)] + 1);
                            loc38[loc39] = loc40;
                        }
                        loc23 = (loc23 + 1);
                    }
                    loc17 = 0.25 * (loc22[0] + loc22[1] + loc22[3] + loc22[4]);
                }
                if (loc22[2] > loc17 * 2.5 && loc22[2] < loc17 * 3.5)
                {
                    loc13.push({"borderColor":loc12[loc15], "borderRect":loc11[loc15]});
                }
                loc15 = (loc15 + 1);
            }
            if (loc13.length >= 3)
            {
                loc24 = [0, (0), (0), 0];
                loc23 = 0;
                while (loc23 < loc13.length) 
                {
                    loc15 = 0;
                    if (loc13[loc23].borderRect.topLeft.x + loc13[loc23].borderRect.width < _wid * 0.5)
                    {
                        loc15 = loc15 + 2;
                    }
                    if (loc13[loc23].borderRect.topLeft.y + loc13[loc23].borderRect.height < _hgt * 0.5)
                    {
                        loc15 = loc15 + 1;
                    }
                    loc24[loc15] = 1;
                    loc23 = (loc23 + 1);
                }
                if (!(loc24[0] + loc24[1] + loc24[2] + loc24[3] != 3))
                {
                    (loc25 = new Matrix()).translate(-_wid * 0.5, -_hgt * 0.5);
                    loc38 = 0;
                    switch (loc38) 
                    {
                        case loc24[0]:
                            break;
                        case loc24[1]:
                            loc25.rotate(Math.PI * 0.5);
                            break;
                        case loc24[2]:
                            loc25.rotate(-Math.PI * 0.5);
                            break;
                        case loc24[3]:
                            loc25.rotate(Math.PI);
                            break;
                    }
                    loc25.translate(_wid * 0.5, _hgt * 0.5);
                    (loc26 = new BitmapData(_wid, _hgt)).draw(loc3, loc25);
                    loc3.copyPixels(loc26, loc26.rect, new Point(0, (0)));
                    loc13[0].borderRect = loc3.getColorBoundsRect(4294967295, loc13[0].borderColor);
                    loc13[1].borderRect = loc3.getColorBoundsRect(4294967295, loc13[1].borderColor);
                    loc13[2].borderRect = loc3.getColorBoundsRect(4294967295, loc13[2].borderColor);
                }
                loc15 = 0;
                while (loc15 < loc13.length) 
                {
                    if ((loc5 = loc13[loc15].borderRect).topLeft.x + loc5.topLeft.y < loc6.d)
                    {
                        loc6.topleft = new Point(loc5.topLeft.x, loc5.topLeft.y);
                        loc6.d = loc5.topLeft.x + loc5.topLeft.y;
                        loc6.center = new Point(loc5.topLeft.x + 0.5 * loc5.width, loc5.topLeft.y + 0.5 * loc5.height);
                        loc9 = (loc9 & 6) + 1;
                    }
                    else 
                    {
                        if (_hgt - loc5.width - loc5.topLeft.x + loc5.topLeft.y < loc7.d)
                        {
                            loc7.topleft = new Point(loc5.topLeft.x, loc5.topLeft.y);
                            loc7.d = loc5.topLeft.x + loc5.width + loc5.topLeft.y;
                            loc7.center = new Point(loc5.topLeft.x + 0.5 * loc5.width, loc5.topLeft.y + 0.5 * loc5.height);
                            loc9 = (loc9 & 5) + 2;
                        }
                        else 
                        {
                            if (loc5.topLeft.x + _hgt - loc5.height - loc5.topLeft.y < loc8.d)
                            {
                                loc8.topleft = new Point(loc5.topLeft.x, loc5.topLeft.y);
                                loc8.d = loc5.topLeft.x + loc5.topLeft.y + loc5.width + loc5.height;
                                loc8.center = new Point(loc5.topLeft.x + 0.5 * loc5.width, loc5.topLeft.y + 0.5 * loc5.height);
                                loc9 = (loc9 & 3) + 4;
                            }
                        }
                    }
                    loc15 = (loc15 + 1);
                }
            }
            if (!(loc9 != 7))
            {
                loc27 = 0;
                loc28 = loc7.center.subtract(loc6.center);
                loc29 = loc8.center.subtract(loc6.center);
                loc27 = (loc28.x * loc29.x + loc28.y * loc29.y) / (loc28.length * loc29.length);
                if (Math.abs(loc27) <= 0.125)
                {
                    loc30 = new Matrix();
                    loc30.translate(-loc6.topleft.x, -loc6.topleft.y);
                    loc31 = 0;
                    if (!(loc28.x == 0))
                    {
                        loc31 = -Math.atan(loc28.y / loc28.x);
                    }
                    loc30.rotate(loc31);
                    loc30.translate(10, (10));
                    loc32 = new Point(0.5 * (loc7.center.x + loc8.center.x), 0.5 * (loc7.center.y + loc8.center.y));
                    loc34 = (loc33 = new Point(loc6.topleft.x + 2 * (loc32.x - loc6.topleft.x), loc6.topleft.y + 2 * (loc32.y - loc6.topleft.y))).subtract(loc6.topleft);
                    loc35 = new Rectangle(10, 10, Math.ceil(loc34.length / Math.sqrt(2)), Math.ceil(loc34.length / Math.sqrt(2)));
                    loc4 = new BitmapData(loc35.width + 20, loc35.height + 20);
                    loc4.draw(loc3, loc30);
                    loc36 = getVersion(loc4);
                    /*
                    for(var ii:* in loc36){
                    	trace(ii+"::"+loc36[ii]);
                    }
                    */
                    
                    if (loc31 < 10 && loc31 > -10 && loc36.version > 0)
                    {
                        _results = getGrid(loc4, loc36);
                        _resultImage = _results[0];
                        _resultArray = _results[1];
                        //trace(_resultArray);
                        //this.addChild(new Bitmap(loc4));
                        //this.addChild(new Bitmap(_resultImage));
                        loc37 = new BitmapData(_resultImage.width, _resultImage.height);
                        loc37.applyFilter(_resultImage, _resultImage.rect, _defPoint, new ConvolutionFilter(7, 7, [1, (1), (1), 1, (1), (1), 1, (1), 0, (0), (0), 0, (0), 1, (1), 0, 1, (1), (1), 0, 1, (1), 0, 1, (1), (1), 0, 1, (1), 0, 1, (1), (1), 0, 1, (1), 0, (0), (0), 0, (0), 1, (1), (1), 1, (1), (1), 1, (1)], 33));
                        //trace(loc37.getPixel(7, 7) ,loc37.getPixel(loc37.width-8, 7) , loc37.getPixel(7, loc37.height-8))
                        //trace(loc37.width-8, loc37.height);
                        if (loc37.getPixel(7, 7) == 0 && loc37.getPixel(loc37.width - 8, 7) == 0 && loc37.getPixel(7, loc37.height - 8) == 0)
                        {
                        	trace("success");
                            dispatchEvent(new QRreaderEvent(QRreaderEvent.QR_IMAGE_READ_COMPLETE, _resultImage, _resultArray));
                        }
                        else 
                        {
                        	//(loc37 as BitmapData).setPixel(loc37.width-8, 7, 0x00FFFF);
                        	//this.addChild(new Bitmap(loc37));
                        	trace("ggggg?");
                            _results = [new BitmapData(1, (1)), new Array(1)];
                        }
                    }
                }
            }
            return;
        }

        private function getGrid(arg1:BitmapData, arg2:Object):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;
            var loc24:*;
            var loc25:*;
            var loc26:*;
            var loc27:*;
            var loc28:*;
            var loc29:*;
            var loc30:*;
            var loc31:*;
            var loc32:*;
            var loc33:*;
            var loc34:*;
            var loc35:*;
            var loc36:*;
            var loc37:*;
            var loc38:*;

            loc5 = 0;
            loc6 = 0;
            loc36 = NaN;
            loc37 = NaN;
            loc38 = NaN;
            loc3 = new BitmapData(8 + arg2.version * 4 + 17, 8 + arg2.version * 4 + 17, false, 0xff0000);
            loc4 = new Array(arg2.version * 4 + 17);
            loc7 = {"x":arg2.topLeftRect.topLeft.x + 0.5 * arg2.topLeftRect.width, "y":arg2.topLeftRect.topLeft.y + 0.5 * arg2.topLeftRect.height};
            loc8 = {"x":arg2.topRightRect.topLeft.x + 0.5 * arg2.topRightRect.width, "y":arg2.topRightRect.topLeft.y + 0.5 * arg2.topRightRect.height};
            loc9 = {"x":arg2.bottomLeftRect.topLeft.x + 0.5 * arg2.bottomLeftRect.width, "y":arg2.bottomLeftRect.topLeft.y + 0.5 * arg2.bottomLeftRect.height};
            loc5 = 0;
            while (loc5 < arg2.version * 4 + 17) 
            {
                loc4[loc5] = new Array(arg2.version * 4 + 17);
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            loc6 = 0;
            while (loc6 != 16777215) 
            {
                loc5 = (loc5 + 1);
                loc6 = arg1.getPixel(arg2.topRightRect.topLeft.x + loc5, arg2.bottomLeftRect.topLeft.y + loc5);
            }
            arg1.floodFill(arg2.topRightRect.topLeft.x + loc5, arg2.bottomLeftRect.topLeft.y + loc5, 4291624959);
            loc10 = arg1.getColorBoundsRect(4294967295, 4291624959);
            arg1.floodFill(arg2.topRightRect.topLeft.x + loc5, arg2.bottomLeftRect.topLeft.y + loc5, 4294967295);
            loc11 = {"x":loc10.topLeft.x + 0.5 * loc10.width, "y":loc10.topLeft.y + 0.5 * loc10.height};
            if (!(arg2.version != 1))
            {
                loc11.x = loc9.x + (loc8.x - loc7.x) * 11 / 14;
                loc11.y = loc8.y + (loc9.y - loc7.y) * 11 / 14;
            }
            loc12 = arg2.version * 4 + 17 - 10;
            loc13 = arg2.version * 4 + 17 - 7;
            loc14 = {"x":arg2.bottomLeftRect.topLeft.x + arg2.bottomLeftRect.width * 0.5, "y":arg2.bottomLeftRect.topLeft.y + arg2.bottomLeftRect.height / 14};
            loc15 = {"x":arg2.topRightRect.topLeft.x + arg2.topRightRect.width / 14, "y":arg2.topRightRect.topLeft.y + arg2.topRightRect.height * 0.5};
            loc16 = 0;
            loc17 = 0;
            loc5 = loc14.y - arg2.cellSize;
            while (loc5 <= loc14.y + arg2.cellSize) 
            {
                if (!(arg1.getPixel(loc14.x, loc5) == 16777215))
                {
                    loc16 = loc16 + loc5;
                    loc17 = (loc17 + 1);
                }
                loc5 = (loc5 + 1);
            }
            loc14.y = 0.5 * (loc14.y + loc16 / loc17);
            loc18 = (loc7.y - loc15.y) / (loc7.x - loc15.x);
            loc19 = (loc14.y - loc11.y) / (loc14.x - loc11.x);
            loc20 = loc15.y - loc18 * loc15.x;
            loc21 = loc11.y - loc19 * loc11.x;
            loc22 = loc7.x + (loc15.x - loc7.x) * -3 / loc12;
            loc23 = loc14.x + (loc11.x - loc14.x) * -3 / loc12;
            loc24 = loc7.y + (loc15.y - loc7.y) * -3 / loc12;
            loc25 = loc14.y + (loc11.y - loc14.y) * -3 / loc12;
            loc26 = loc15.x + (loc15.x - loc7.x) * 6 / loc12;
            loc27 = loc11.x + (loc11.x - loc14.x) * 6 / loc12;
            loc28 = loc3.width - 8 - 1 + 1;
            loc29 = loc28-1;
            loc30 = new Array(loc28);
            loc31 = new Array(loc28);
            loc32 = new Array(loc28);
            loc33 = new Array(loc28);
            loc34 = new Array(loc28);
            loc5 = 0;
            while (loc5 < loc28) 
            {
                loc30[loc5] = (loc19 - loc18) / loc12 * (loc5 - 3) + loc18;
                loc32[loc5] = (loc23 - loc22) / loc12 * (loc5 - 3) + loc22;
                loc33[loc5] = (loc25 - loc24) / loc12 * (loc5 - 3) + loc24;
                loc34[loc5] = (loc27 - loc26) / loc12 * (loc5 - 3) + loc26;
                loc31[loc5] = loc33[loc5] - loc30[loc5] * loc32[loc5];
                loc5++;
            }
            //trace(loc28, loc29);
            loc35 = 0;
            while (loc35 < loc28) 
            {
                loc36 = loc35 - 3;
                loc37 = 0;
                while (loc37 < loc28) 
                {
                    loc38 = loc37 - 3;
                    var _x:Number = (loc32[loc35] + (loc34[loc35] - loc32[loc35]) * loc37 / loc29);
                    var _y:Number = (loc30[loc35] * (loc32[loc35] + (loc34[loc35] - loc32[loc35]) * loc37 / loc29) + loc31[loc35]);
                    //trace(_x, _y, arg1.width, arg1.height );
                    if ((arg1.getPixel(_x,_y) & 16711680) < 16711680)
                    {
                    	//trace(loc37, loc35);
                        loc3.setPixel(4 + loc37, 4 + loc35, 0);
                        loc4[loc35][loc37] = 1;
                    }
                    loc37 = (loc37 + 1);
                }
                loc35 = (loc35 + 1);
            }
            return [loc3, loc4];
        }

        
    }
}

