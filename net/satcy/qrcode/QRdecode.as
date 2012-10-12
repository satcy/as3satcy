package net.satcy.qrcode{
    import net.satcy.qrcode.event.*;
    import flash.display.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class QRdecode extends Sprite
    {
    	private var _qr:Array;

        private var textObj:TextField;

        private var _xorPattern:Array;

        private var _fixed:Array;

        private var _qrVersion:uint=5;
        
        public function QRdecode()
        {
            _xorPattern = [1, 0, 1, 0, 1, 0, (0), (0), 0, (0), 1, 0, (0), 1, 0];
            textObj = new TextField();
            super();
            return;
        }

        

        private function _readNnumber(arg1:Array, arg2:uint):uint
        {
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc4 = 0;
            loc3 = 0;
            while (loc3 < arg2) 
            {
                loc4 = (loc4 = loc4 << 1) + arg1[0];
                arg1.shift();
                loc3 = (loc3 + 1);
            }
            return loc4;
        }

        public function setQR(arg1:Array):void
        {
            _qr = arg1;
            _qrVersion = (arg1.length - 17) * 0.25;
            return;
        }

        private function _RS8bit(arg1:Array, arg2:uint, arg3:uint, arg4:uint):void
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
            var loc14:*;
            var loc15:*;

            loc5 = 0;
            loc6 = 0;
            loc7 = 0;
            loc10 = null;
            loc11 = null;
            loc14 = null;
            loc15 = null;
            loc8 = arg1.length;
            loc9 = arg3;
            loc12 = new Array(loc9);
            loc13 = new Array(arg4);
            loc6 = 0;
            while (loc6 < loc9) 
            {
                loc12[loc6] = new G8Num(-1);
                loc6 = (loc6 + 1);
            }
            loc5 = 0;
            while (loc5 < loc8) 
            {
                (loc14 = new G8Num(0)).setVector(arg1[((loc8 - 1) - loc5)]);
                loc6 = 0;
                while (loc6 < loc9) 
                {
                    loc12[loc6] = loc12[loc6].plus(loc14.multiply(new G8Num(loc5 * loc6)));
                    loc6 = (loc6 + 1);
                }
                loc5 = (loc5 + 1);
            }
            loc6 = 0;
            loc5 = 0;
            while (loc5 < loc9) 
            {
                if (!(loc12[loc5].getPower() == -1))
                {
                    loc6 = (loc6 + 1);
                }
                loc5 = (loc5 + 1);
            }
            if (!(loc6 != 0))
            {
                return;
            }
            loc5 = arg4;
            while (loc5 > 0) 
            {
                if (!(_calcDet(loc12, loc5) == 0))
                {
                    break;
                }
                loc5 = (loc5 - 1);
            }
            arg4 = loc5;
            loc10 = new Array(arg4);
            loc5 = 0;
            while (loc5 < arg4) 
            {
                loc10[loc5] = new Array(arg4 + 1);
                loc6 = 0;
                while (loc6 <= arg4) 
                {
                    loc10[loc5][loc6] = new G8Num(loc12[(loc5 + loc6)].getPower());
                    loc6 = (loc6 + 1);
                }
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            while (loc5 < arg4) 
            {
                _reduceToLU(loc10, loc5);
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            while (loc5 < arg4) 
            {
                loc6 = 0;
                while (loc6 < arg4) 
                {
                    if (!(loc10[loc5][loc6].getPower() == -1))
                    {
                        loc13[((arg4 - 1) - loc6)] = loc10[loc5][arg4];
                    }
                    loc6 = (loc6 + 1);
                }
                loc5 = (loc5 + 1);
            }
            loc11 = new Array(arg4);
            loc7 = 0;
            loc5 = 0;
            while (loc5 < loc8) 
            {
                loc14 = new G8Num(loc5 * arg4);
                loc6 = (arg4 - 1);
                while (loc6 >= 1) 
                {
                    loc15 = new G8Num(loc5 * loc6);
                    loc14 = loc14.plus(loc15.multiply(loc13[((arg4 - 1) - loc6)]));
                    loc6 = (loc6 - 1);
                }
                if ((loc14 = loc14.plus(loc13[(arg4 - 1)])).getPower() < 0)
                {
                    loc11[loc7] = (loc8 - 1) - loc5;
                    loc6 = 0;
                    while (loc6 < arg4) 
                    {
                        loc10[loc6][loc7] = new G8Num(loc5 * loc6);
                        loc6 = (loc6 + 1);
                    }
                    loc10[loc7][arg4] = new G8Num(loc12[loc7].getPower());
                    loc7 = (loc7 + 1);
                }
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            while (loc5 < arg4) 
            {
                _reduceToLU(loc10, loc5);
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            while (loc5 < arg4) 
            {
                loc6 = 0;
                while (loc6 < arg4) 
                {
                    if (!(loc10[loc5][loc6].getPower() != 0))
                    {
                        arg1[loc11[loc6]] = arg1[loc11[loc6]] ^ loc10[loc5][arg4].getVector();
                    }
                    loc6 = (loc6 + 1);
                }
                loc5 = (loc5 + 1);
            }
            return;
        }

        private function _calcDet(arg1:Array, arg2:uint):int
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            loc8 = null;
            loc6 = 0;
            loc7 = new G8Num(0);
            loc9 = new Array(arg2);
            loc10 = new Array(arg2);
            loc4 = 0;
            while (loc4 < arg2) 
            {
                loc9[loc4] = 1;
                loc10[loc4] = new Array(arg2);
                loc3 = 0;
                while (loc3 < arg2) 
                {
                    loc10[loc4][loc3] = new G8Num(arg1[(loc3 + loc4)].getPower());
                    loc3 = (loc3 + 1);
                }
                loc4 = (loc4 + 1);
            }
            while (loc6 < arg2) 
            {
                loc3 = 0;
                while (loc3 < arg2) 
                {
                    if (!(loc9[loc3] != 1))
                    {
                        if (loc10[loc3][loc6].getPower() >= 0)
                        {
                            loc7.multiply(loc10[loc3][loc6]);
                            loc8 = loc10[loc3][loc6].inverse();
                            loc4 = loc6;
                            while (loc4 < arg2) 
                            {
                                loc10[loc3][loc4] = loc10[loc3][loc4].multiply(loc8);
                                loc4 = (loc4 + 1);
                            }
                            loc5 = 0;
                            while (loc5 < arg2) 
                            {
                                if (!(loc5 == loc3) && loc9[loc5] == 1 && loc10[loc5][loc6].getPower() >= 0)
                                {
                                    loc8 = new G8Num(loc10[loc5][loc6].getPower());
                                    loc4 = loc6;
                                    while (loc4 < arg2) 
                                    {
                                        loc10[loc5][loc4] = loc10[loc5][loc4].plus(loc8.multiply(loc10[loc3][loc4]));
                                        loc4 = (loc4 + 1);
                                    }
                                }
                                loc5 = (loc5 + 1);
                            }
                            loc9[loc3] = 0;
                            break;
                        }
                    }
                    loc3 = (loc3 + 1);
                }
                if (!(loc3 != arg2))
                {
                    return 0;
                }
                loc6 = (loc6 + 1);
            }
            return loc7.getVector();
        }

        private function _decode15_5():Array
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc3 = 0;
            loc4 = 0;
            loc7 = null;
            loc8 = null;
            loc1 = new Array(15);
            loc2 = new Array(15);
            loc5 = new Array(5);
            loc6 = new Array(3);
            loc9 = new Array(5);
            loc10 = new Array(15);
            loc4 = 0;
            while (loc4 < 5) 
            {
                loc5[loc4] = new G4Num(-1);
                loc4++;
            }
            loc3 = 0;
            while (loc3 <= 5) 
            {
                loc1[loc3] = _getQR(8, loc3);
                loc3 = (loc3 + 1);
            }
            loc1[6] = _getQR(8, 7);
            loc1[7] = _getQR(8, (8));
            loc1[8] = _getQR(7, 8);
            loc3 = 0;
            while (loc3 <= 5) 
            {
                loc1[(loc3 + 9)] = _getQR(5 - loc3, 8);
                loc3 = (loc3 + 1);
            }
            loc3 = 0;
            while (loc3 <= 7) 
            {
                loc2[loc3] = _getQR(_qrVersion * 4 + 16 - loc3, 8);
                loc3 = (loc3 + 1);
            }
            loc3 = 0;
            while (loc3 <= 6) 
            {
                loc2[(8 + loc3)] = _getQR(8, _qrVersion * 4 + 10 + loc3);
                loc3 = (loc3 + 1);
            }
            loc3 = 0;
            while (loc3 < 15) 
            {
                loc10[loc3] = loc1[(14 - loc3)] ^ _xorPattern[loc3];
                loc3 = (loc3 + 1);
            }
            loc3 = 0;
            while (loc3 < 15) 
            {
                if (loc10[loc3])
                {
                    loc4 = 0;
                    while (loc4 < 5) 
                    {
                        loc5[loc4] = loc5[loc4].plus(new G4Num(loc3 * (loc4 + 1)));
                        loc4 = loc4 + 2;
                    }
                }
                loc3 = (loc3 + 1);
            }
            loc5[1] = loc5[0].multiply(loc5[0]);
            loc5[3] = loc5[1].multiply(loc5[1]);
            loc6[0] = new G4Num(loc5[0].getPower());
            loc7 = loc5[4].plus(loc5[1].multiply(loc5[2]));
            loc8 = loc5[2].plus(loc5[0].multiply(loc5[1]));
            if (loc7.getPower() < 0 || loc8.getPower() < 0)
            {
                loc6[1] = new G4Num(-1);
            }
            else 
            {
                loc6[1] = new G4Num(loc7.getPower() - loc8.getPower() + 15);
            }
            loc7 = loc5[1].multiply(loc6[0]);
            loc8 = loc5[0].multiply(loc6[1]);
            loc6[2] = loc5[2].plus(loc7.plus(loc8));
            loc3 = 0;
            while (loc3 < 5) 
            {
                loc7 = new G4Num(loc3 * 3);
                loc8 = new G4Num(loc3 * 2);
                loc7 = loc7.plus(loc8.multiply(loc6[0]));
                loc8 = new G4Num(loc3);
                if ((loc7 = (loc7 = loc7.plus(loc8.multiply(loc6[1]))).plus(loc6[2])).getPower() < 0)
                {
                    loc9[loc3] = loc10[loc3] ^ 1;
                }
                else 
                {
                    loc9[loc3] = loc10[loc3];
                }
                loc3 = (loc3 + 1);
            }
            return loc9;
        }

        private function _getQR(arg1:uint, arg2:uint):uint
        {
            return _qr[arg2][arg1];
        }

        private function _getWords(arg1:Array):Array
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

            loc5 = 0;
            loc9 = 0;
            loc2 = [];
            loc3 = [26, 44, 70, 100, 134, 172, 196, 242, 292, 346, 404, 466, 532, 581, 655, 733, 815, 901, 991, 1085, 1156, 1258, 1364, 1474, 1588, 1706, 1828, 1921, 2051, 2185, 2323, 2465, 2611, 2761, 2876, 3034, 3196, 3362, 3532, 3706];
            loc6 = (loc4 = new Array(loc3[(_qrVersion - 1)])).length;
            loc7 = _qrVersion * 4 + 16;
            loc8 = _qrVersion * 4 + 16;
            loc10 = 1;
            loc11 = 1;
            loc12 = 0;
            loc5 = 0;
            while (loc5 < loc6) 
            {
                loc4[loc5] = new Array(8);
                loc2[loc5] = new Array(8);
                loc5 = (loc5 + 1);
            }
            loc5 = 0;
            while (loc5 < loc6) 
            {
                loc9 = 0;
                while (loc9 < 8) 
                {
                    while (_isFixed(loc7, loc8)) 
                    {
                        if (!(loc7 != 6))
                        {
                            loc7 = (loc7 - 1);
                        }
                        if (loc11)
                        {
                            loc7 = (loc7 - 1);
                            loc11 = 0;
                            continue;
                        }
                        loc11 = 1;
                        if (loc10)
                        {
                            if (loc8 != 0)
                            {
                                loc7 = (loc7 + 1);
                                loc8 = (loc8 - 1);
                            }
                            else 
                            {
                                loc7 = (loc7 - 1);
                                loc10 = 0;
                            }
                            continue;
                        }
                        if (!(loc8 != _qrVersion * 4 + 16))
                        {
                            loc7 = (loc7 - 1);
                            loc10 = 1;
                            continue;
                        }
                        loc7 = (loc7 + 1);
                        loc8 = (loc8 + 1);
                    }
                    _fixed[loc8][loc7] = 1;
                    loc4[loc12][loc9] = arg1[loc8][loc7];
                    loc2[loc12][loc9] = [loc7, loc8];
                    loc9 = (loc9 + 1);
                }
                loc12 = (loc12 + 1);
                loc5 = (loc5 + 1);
            }
            dispatchEvent(new QRdecoderEvent(QRdecoderEvent.QR_DECODE_CODE_CHECK, "", loc2));
            return loc4;
        }

        private function _readNstr(arg1:Array, arg2:uint):String
        {
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc4 = "";
            if (arg1.length < arg2)
            {
                arg2 = arg1.length;
            }
            loc3 = 0;
            while (loc3 < arg2) 
            {
                loc4 = loc4 + (!arg1[0] ? "0" : "1");
                arg1.shift();
                loc3++;
            }
            return loc4;
        }

        private function _unmask(arg1:Array):Array
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;

            loc4 = 0;
            loc5 = 0;
            loc2 = _qrVersion * 4 + 17;
            loc3 = new Array(loc2);
            loc5 = 0;
            while (loc5 < loc2) 
            {
                loc3[loc5] = new Array(loc2);
                loc5 = (loc5 + 1);
            }
            loc6 = (arg1[2] << 2) + (arg1[3] << 1) + arg1[4];
            //trace(loc6);
            switch (loc6) 
            {
                case 0:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int((loc4 + loc5) % 2 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 1:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int(loc4 % 2 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 2:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int(loc5 % 3 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 3:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int((loc4 + loc5) % 3 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 4:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int((Math.floor(loc4 * 0.5) + Math.floor(loc5 / 3)) % 2 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 5:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int(loc4 * loc5 % 2 + loc4 * loc5 % 3 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 6:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int((loc4 * loc5 % 2 + loc4 * loc5 % 3) % 2 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
                case 7:
                    loc5 = 0;
                    while (loc5 < loc2) 
                    {
                        loc4 = 0;
                        while (loc4 < loc2) 
                        {
                            loc3[loc4][loc5] = _getQR(loc5, loc4) ^ int(((loc4 + loc5) % 2 + loc4 * loc5 % 3) % 2 == 0);
                            loc4 = (loc4 + 1);
                        }
                        loc5 = (loc5 + 1);
                    }
                    break;
            }
            return loc3;
        }

        private function _Hex2String(arg1:uint):String
        {
            var loc2:*;
            var loc3:*;

            loc2 = Math.floor(arg1 / 16);
            loc3 = arg1 % 16;
            return String.fromCharCode(loc2 + 48 + uint(loc2 > 9) * 7) + String.fromCharCode(loc3 + 48 + uint(loc3 > 9) * 7);
        }

        private function _reduceToLU(arg1:Array, arg2:uint):void
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc3 = 0;
            loc4 = 0;
            loc5 = 0;
            loc6 = 0;
            loc8 = null;
            loc7 = arg1.length;
            loc3 = 0;
            while (loc3 < loc7) 
            {
                loc6 = 0;
                if (!(arg1[loc3][arg2].getPower() == -1))
                {
                    loc6 = 1;
                    loc4 = 0;
                    while (loc4 < arg2) 
                    {
                        if (!(arg1[loc3][loc4].getPower() == -1))
                        {
                            loc6 = 0;
                        }
                        loc4 = (loc4 + 1);
                    }
                }
                if (loc6)
                {
                    loc5 = loc3;
                    loc3 = loc7;
                }
                loc3 = (loc3 + 1);
            }
            loc8 = arg1[loc5][arg2].inverse();
            loc4 = arg2;
            while (loc4 <= loc7) 
            {
                arg1[loc5][loc4] = arg1[loc5][loc4].multiply(loc8);
                loc4 = (loc4 + 1);
            }
            loc3 = 0;
            while (loc3 < loc7) 
            {
                if (!(loc3 == loc5) && !(arg1[loc3][arg2].getPower == -1))
                {
                    loc8 = new G8Num(arg1[loc3][arg2].getPower());
                    loc4 = arg2;
                    while (loc4 <= loc7) 
                    {
                        arg1[loc3][loc4] = arg1[loc3][loc4].plus(arg1[loc5][loc4].multiply(loc8));
                        loc4 = (loc4 + 1);
                    }
                }
                loc3 = (loc3 + 1);
            }
            return;
        }

        private function _isFixed(arg1:uint, arg2:uint):uint
        {
            return _fixed[arg2][arg1];
        }

        private function _readByteData(arg1:Array):uint
        {
            return (arg1[0] << 7) + (arg1[1] << 6) + (arg1[2] << 5) + (arg1[3] << 4) + (arg1[4] << 3) + (arg1[5] << 2) + (arg1[6] << 1) + (arg1[7] << 0);
        }

        private function _Hex2Bin(arg1:Array):Array
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

            loc2 = 0;
            loc3 = 0;
            loc4 = arg1.length;
            loc5 = new Array(loc4 * 8);
            loc2 = 0;
            while (loc2 < loc4) 
            {
                loc5[(loc6 = loc3++)] = arg1[loc2] >> 7 & 1;
                loc5[(loc7 = loc3++)] = arg1[loc2] >> 6 & 1;
                loc5[(loc8 = loc3++)] = arg1[loc2] >> 5 & 1;
                loc5[(loc9 = loc3++)] = arg1[loc2] >> 4 & 1;
                loc5[(loc10 = loc3++)] = arg1[loc2] >> 3 & 1;
                loc5[(loc11 = loc3++)] = arg1[loc2] >> 2 & 1;
                loc5[(loc12 = loc3++)] = arg1[loc2] >> 1 & 1;
                loc5[(loc13 = loc3++)] = arg1[loc2] >> 0 & 1;
                loc2 = (loc2 + 1);
            }
            return loc5;
        }

        private function _makeFixed():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc1 = 0;
            loc2 = 0;
            loc3 = 0;
            loc4 = 0;
            _fixed = new Array(_qrVersion * 4 + 17);
            loc1 = 0;
            while (loc1 < _qrVersion * 4 + 17) 
            {
                _fixed[loc1] = new Array(_qrVersion * 4 + 17);
                ++loc1;
            }
            loc5 = _qrVersion;
            switch (loc5) 
            {
                case 1:
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        loc2 = 0;
                        while (loc2 < 8) 
                        {
                            _fixed[(_qrVersion * 4 + 9 + loc2)][loc1] = loc5 = 1;
                            _fixed[loc2][(_qrVersion * 4 + 9 + loc1)] = loc5 = loc5;
                            _fixed[loc2][loc1] = loc5;
                            ++loc2;
                        }
                        ++loc1;
                    }
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        _fixed[8][(_qrVersion * 4 + 9 + loc1)] = loc5 = 1;
                        _fixed[(_qrVersion * 4 + 9 + loc1)][8] = loc5 = loc5;
                        _fixed[loc1][8] = loc5 = loc5;
                        _fixed[8][loc1] = loc5;
                        ++loc1;
                    }
                    _fixed[8][8] = 1;
                    loc1 = 9;
                    while (loc1 < _qrVersion * 4 + 9) 
                    {
                        _fixed[loc1][6] = loc5 = 1;
                        _fixed[6][loc1] = loc5;
                        ++loc1;
                    }
                    break;
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        loc2 = 0;
                        while (loc2 < 8) 
                        {
                            _fixed[(_qrVersion * 4 + 9 + loc2)][loc1] = loc5 = 1;
                            _fixed[loc2][(_qrVersion * 4 + 9 + loc1)] = loc5 = loc5;
                            _fixed[loc2][loc1] = loc5;
                            ++loc2;
                        }
                        ++loc1;
                    }
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        _fixed[8][(_qrVersion * 4 + 9 + loc1)] = loc5 = 1;
                        _fixed[(_qrVersion * 4 + 9 + loc1)][8] = loc5 = loc5;
                        _fixed[loc1][8] = loc5 = loc5;
                        _fixed[8][loc1] = loc5;
                        ++loc1;
                    }
                    _fixed[8][8] = 1;
                    loc1 = -2;
                    while (loc1 <= 2) 
                    {
                        loc2 = -2;
                        while (loc2 <= 2) 
                        {
                            _fixed[(_qrVersion * 4 + 10 + loc2)][(_qrVersion * 4 + 10 + loc1)] = 1;
                            ++loc2;
                        }
                        ++loc1;
                    }
                    loc1 = 9;
                    while (loc1 < _qrVersion * 4 + 9) 
                    {
                        _fixed[loc1][6] = loc5 = 1;
                        _fixed[6][loc1] = loc5;
                        ++loc1;
                    }
                    break;
                case 7:
                case 8:
                case 9:
                case 10:
                case 12:
                case 13:
                    loc1 = 0;
                    while (loc1 < 3) 
                    {
                        loc2 = 0;
                        while (loc2 < 6) 
                        {
                            _fixed[(_qrVersion * 4 + 6 + loc1)][loc2] = loc5 = 1;
                            _fixed[loc2][(_qrVersion * 4 + 6 + loc1)] = loc5;
                            ++loc2;
                        }
                        ++loc1;
                    }
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        loc2 = 0;
                        while (loc2 < 8) 
                        {
                            _fixed[(_qrVersion * 4 + 9 + loc2)][loc1] = loc5 = 1;
                            _fixed[loc2][(_qrVersion * 4 + 9 + loc1)] = loc5 = loc5;
                            _fixed[loc2][loc1] = loc5;
                            ++loc2;
                        }
                        ++loc1;
                    }
                    loc1 = 0;
                    while (loc1 < 8) 
                    {
                        _fixed[8][(_qrVersion * 4 + 9 + loc1)] = loc5 = 1;
                        _fixed[(_qrVersion * 4 + 9 + loc1)][8] = loc5 = loc5;
                        _fixed[loc1][8] = loc5 = loc5;
                        _fixed[8][loc1] = loc5;
                        ++loc1;
                    }
                    _fixed[8][8] = 1;
                    loc3 = 6;
                    while (loc3 <= _qrVersion * 4 + 10) 
                    {
                        loc4 = 6;
                        while (loc4 <= _qrVersion * 4 + 10) 
                        {
                            if (!(loc3 == 6 && loc4 == _qrVersion * 4 + 10) && !(loc4 == 6 && loc3 == _qrVersion * 4 + 10))
                            {
                                loc1 = -2;
                                while (loc1 <= 2) 
                                {
                                    loc2 = -2;
                                    while (loc2 <= 2) 
                                    {
                                        _fixed[(loc3 + loc2)][(loc4 + loc1)] = 1;
                                        ++loc2;
                                    }
                                    ++loc1;
                                }
                            }
                            loc4 = loc4 + _qrVersion * 2 + 2;
                        }
                        loc3 = loc3 + _qrVersion * 2 + 2;
                    }
                    loc1 = 9;
                    while (loc1 < _qrVersion * 4 + 9) 
                    {
                        _fixed[loc1][6] = loc5 = 1;
                        _fixed[6][loc1] = loc5;
                        ++loc1;
                    }
                    break;
            }
            //trace(this._fixed);
            return;
        }

        public function startDecode():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc1 = null;
            loc2 = null;
            loc3 = null;
            loc4 = null;
            loc5 = null;
            loc6 = 1;
            loc7 = null;
            loc8 = _qrVersion * 4 + 17;
            loc1 = _decode15_5();
            loc2 = _unmask(loc1);
            trace("-----");
            _makeFixed();
            trace("----");
            dispatchEvent(new QRdecoderEvent(QRdecoderEvent.QR_DECODE_CHECK, "", _fixed));
            loc3 = _getWords(loc2);
            loc4 = _ReedSolomon(loc3, loc1);
            loc5 = _readData(loc4);
            //trace("###", loc3);
            //trace("###", loc4);
            //trace("###", loc5);
            if (loc6 == loc5[0])
            {
                loc7 = loc5[1];
                trace(">>>"+loc7);
                textObj.appendText("" + loc7);
                dispatchEvent(new QRdecoderEvent(QRdecoderEvent.QR_DECODE_COMPLETE, loc7, []));
            }
            return;
        }

        private function _ReedSolomon(arg1:Array, arg2:Array):Array
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

            loc3 = null;
            loc5 = null;
            loc6 = null;
            loc7 = 0;
            loc8 = 0;
            loc9 = 0;
            loc10 = 0;
            loc4 = [];
            loc11 = 0;
            loc12 = 0;
            loc13 = _qrVersion;
            switch (loc13) 
            {
                case 1:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(1);
                            loc5 = [16];
                            loc6 = [10];
                            break;
                        case 1:
                            loc3 = new Array(1);
                            loc5 = [19];
                            loc6 = [7];
                            break;
                        case 2:
                            loc3 = new Array(1);
                            loc5 = [9];
                            loc6 = [17];
                            break;
                        case 3:
                            loc3 = new Array(1);
                            loc5 = [13];
                            loc6 = [13];
                            break;
                    }
                    break;
                case 2:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(1);
                            loc5 = [28];
                            loc6 = [16];
                            break;
                        case 1:
                            loc3 = new Array(1);
                            loc5 = [34];
                            loc6 = [10];
                            break;
                        case 2:
                            loc3 = new Array(1);
                            loc5 = [16];
                            loc6 = [28];
                            break;
                        case 3:
                            loc3 = new Array(1);
                            loc5 = [22];
                            loc6 = [22];
                            break;
                    }
                    break;
                case 3:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(1);
                            loc5 = [44];
                            loc6 = [26];
                            break;
                        case 1:
                            loc3 = new Array(1);
                            loc5 = [55];
                            loc6 = [15];
                            break;
                        case 2:
                            loc3 = new Array(2);
                            loc5 = [13, (13)];
                            loc6 = [22, (22)];
                            break;
                        case 3:
                            loc3 = new Array(1);
                            loc5 = [17, (17)];
                            loc6 = [18, (18)];
                            break;
                    }
                    break;
                case 4:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(2);
                            loc5 = [32, (32)];
                            loc6 = [18, (18)];
                            break;
                        case 1:
                            loc3 = new Array(1);
                            loc5 = [80];
                            loc6 = [20];
                            break;
                        case 2:
                            loc3 = new Array(4);
                            loc5 = [9, (9), (9), 9];
                            loc6 = [16, (16), (16), 16];
                            break;
                        case 3:
                            loc3 = new Array(2);
                            loc5 = [24, (24)];
                            loc6 = [26, (26)];
                            break;
                    }
                    break;
                case 5:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(2);
                            loc5 = [43, (43)];
                            loc6 = [24, (24)];
                            break;
                        case 1:
                            loc3 = new Array(1);
                            loc5 = [108];
                            loc6 = [26];
                            break;
                        case 2:
                            loc3 = new Array(4);
                            loc5 = [11, (11), 12, (12)];
                            loc6 = [22, (22), (22), 22];
                            break;
                        case 3:
                            loc3 = new Array(4);
                            loc5 = [15, (15), 16, (16)];
                            loc6 = [18, (18), (18), 18];
                            break;
                    }
                    break;
                case 6:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(4);
                            loc5 = [27, (27), (27), 27];
                            loc6 = [16, (16), (16), 16];
                            break;
                        case 1:
                            loc3 = new Array(2);
                            loc5 = [68, (68)];
                            loc6 = [18, (18)];
                            break;
                        case 2:
                            loc3 = new Array(4);
                            loc5 = [15, (15), (15), 15];
                            loc6 = [28, (28), (28), 28];
                            break;
                        case 3:
                            loc3 = new Array(4);
                            loc5 = [19, (19), (19), 19];
                            loc6 = [24, (24), (24), 24];
                            break;
                    }
                    break;
                case 7:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(4);
                            loc5 = [31, (31), (31), 31];
                            loc6 = [18, (18), (18), 18];
                            break;
                        case 1:
                            loc3 = new Array(2);
                            loc5 = [78, (78)];
                            loc6 = [20, (20)];
                            break;
                        case 2:
                            loc3 = new Array(5);
                            loc5 = [13, (13), (13), 13, 14];
                            loc6 = [26, (26), (26), 26, (26)];
                            break;
                        case 3:
                            loc3 = new Array(6);
                            loc5 = [14, (14), 15, (15), (15), 15];
                            loc6 = [18, (18), (18), 18, (18), (18)];
                            break;
                    }
                    break;
                case 8:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(4);
                            loc5 = [38, (38), 39, (39)];
                            loc6 = [22, (22), (22), 22];
                            break;
                        case 1:
                            loc3 = new Array(2);
                            loc5 = [97, (97)];
                            loc6 = [24, (24)];
                            break;
                        case 2:
                            loc3 = new Array(6);
                            loc5 = [14, (14), (14), 14, 15, (15)];
                            loc6 = [26, (26), (26), 26, (26), (26)];
                            break;
                        case 3:
                            loc3 = new Array(6);
                            loc5 = [18, (18), (18), 18, 19, (19)];
                            loc6 = [22, (22), (22), 22, (22), (22)];
                            break;
                    }
                    break;
                case 9:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(5);
                            loc5 = [36, (36), (36), 37, (37)];
                            loc6 = [22, (22), (22), 22, (22)];
                            break;
                        case 1:
                            loc3 = new Array(2);
                            loc5 = [116, (116)];
                            loc6 = [30, (30)];
                            break;
                        case 2:
                            loc3 = new Array(8);
                            loc5 = [12, (12), (12), 12, 13, (13), (13), 13];
                            loc6 = [24, (24), (24), 24, (24), (24), 24, (24)];
                            break;
                        case 3:
                            loc3 = new Array(8);
                            loc5 = [16, (16), (16), 16, 17, (17), (17), 17];
                            loc6 = [20, (20), (20), 20, (20), (20), 20, (20)];
                            break;
                    }
                    break;
                case 10:
                    loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                    switch (loc13) 
                    {
                        case 0:
                            loc3 = new Array(5);
                            loc5 = [43, (43), (43), 43, 44];
                            loc6 = [26, (26), (26), 26, (26)];
                            break;
                        case 1:
                            loc3 = new Array(4);
                            loc5 = [68, (68), 69, (69)];
                            loc6 = [18, (18), (18), 18];
                            break;
                        case 2:
                            loc3 = new Array(8);
                            loc5 = [15, (15), (15), 15, (15), (15), 16, (16)];
                            loc6 = [28, (28), (28), 28, (28), (28), 28, (28)];
                            break;
                        case 3:
                            loc3 = new Array(8);
                            loc5 = [19, (19), (19), 19, (19), (19), 20, (20)];
                            loc6 = [24, (24), (24), 24, (24), (24), 24, (24)];
                            break;
                    }
                    break;
                default:
                    return [];
            }
            loc8 = loc3.length;
            loc7 = 0;
            while (loc7 < loc8) 
            {
                loc3[loc7] = new Array();
                loc7 = (loc7 + 1);
            }
            loc10 = loc5[(loc8 - 1)];
            loc9 = 0;
            while (loc9 < loc10) 
            {
                loc7 = 0;
                while (loc7 < loc8) 
                {
                    if (loc9 < loc5[loc7])
                    {
                        loc3[loc7].push([_readByteData(arg1[loc11++])]);
                    }
                    loc7 = (loc7 + 1);
                }
                loc9 = (loc9 + 1);
            }
            loc12 = loc6[0] * 0.5;
            if (!(_qrVersion != 1))
            {
                loc13 = (arg2[0] << 1) + (arg2[1] << 0);
                switch (loc13) 
                {
                    case 0:
                        loc12 = 4;
                        break;
                    case 1:
                        loc12 = 2;
                        break;
                    case 2:
                        loc12 = 8;
                        break;
                    case 3:
                        loc12 = 6;
                        break;
                }
            }
            if (_qrVersion == 2 && (arg2[0] << 1) + (arg2[1] << 0) == 1)
            {
                loc12 = 4;
            }
            if (_qrVersion == 3 && (arg2[0] << 1) + (arg2[1] << 0) == 1)
            {
                loc12 = 7;
            }
            loc10 = loc6[0];
            loc9 = 0;
            while (loc9 < loc10) 
            {
                loc7 = 0;
                while (loc7 < loc8) 
                {
                    loc3[loc7].push([_readByteData(arg1[loc11++])]);
                    loc7 = (loc7 + 1);
                }
                loc9 = (loc9 + 1);
            }
            loc7 = 0;
            while (loc7 < loc8) 
            {
                _RS8bit(loc3[loc7], loc5[loc7], loc6[loc7], loc12);
                loc7 = (loc7 + 1);
            }
            loc7 = 0;
            while (loc7 < loc8) 
            {
                loc10 = loc5[loc7];
                loc9 = 0;
                while (loc9 < loc10) 
                {
                    loc4.push(loc3[loc7][loc9]);
                    loc9 = (loc9 + 1);
                }
                loc7 = (loc7 + 1);
            }
            return loc4;
        }

        private function _readData(arg1:Array):Array
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

            loc3 = 0;
            loc6 = null;
            loc7 = 0;
            loc8 = null;
            loc9 = 0;
            loc10 = 0;
            loc11 = 0;
            loc12 = null;
            loc2 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", " ", "$", "%", "*", "+", "-", ".", "/", ":"];
            loc4 = [[10, 9, 8, (8)], [12, 11, 16, 10], [14, 13, 16, 12]];
            loc5 = "";
            loc13 = 1;
            if (_qrVersion < 10)
            {
                loc3 = 0;
            }
            else 
            {
                if (_qrVersion < 27)
                {
                    loc3 = 1;
                }
                else 
                {
                    if (_qrVersion < 41)
                    {
                        loc3 = 2;
                    }
                }
            }
            loc6 = _Hex2Bin(arg1);
            //trace(loc6);
            while (loc6.length > 0) 
            {
                loc8 = _readNstr(loc6, 4);
                //trace(":::::",loc8);
                loc14 = loc8;
                switch (loc14) 
                {
                    case "0001":
                        loc9 = _readNnumber(loc6, loc4[loc3][0]);
                        loc7 = 0;
                        while (loc7 < loc9) 
                        {
                            if (loc9 - loc7 != 2)
                            {
                                if (loc9 - loc7 != 1)
                                {
                                    loc10 = _readNnumber(loc6, 10);
                                    loc5 = loc5 + String("000" + loc10).substr(-3, 3);
                                }
                                else 
                                {
                                    loc10 = _readNnumber(loc6, 4);
                                    loc5 = loc5 + String("0" + loc10).substr(-1, 1);
                                }
                            }
                            else 
                            {
                                loc10 = _readNnumber(loc6, 7);
                                loc5 = loc5 + String("00" + loc10).substr(-2, 2);
                            }
                            loc7 = loc7 + 3;
                        }
                        continue;
                    case "0010":
                        loc9 = _readNnumber(loc6, loc4[loc3][1]);
                        loc7 = 0;
                        while (loc7 < loc9) 
                        {
                            if (loc9 - loc7 > 1)
                            {
                                loc10 = _readNnumber(loc6, 11);
                                loc5 = loc5 + loc2[Math.floor(loc10 / 45)] + loc2[(loc10 % 45)];
                            }
                            else 
                            {
                                loc10 = _readNnumber(loc6, 6);
                                loc5 = loc5 + loc2[loc10];
                            }
                            loc7 = loc7 + 2;
                        }
                        continue;
                    case "0100":
                        loc9 = _readNnumber(loc6, loc4[loc3][2]);
                        loc12 = "";
                        loc7 = 0;
                        while (loc7 < loc9) 
                        {
                            loc10 = _readNnumber(loc6, 8);
                            loc12 = loc12 + "%" + _Hex2String(loc10);
                            loc7 = (loc7 + 1);
                        }
                        System.useCodePage = true;
                        loc5 = loc5 + unescapeMultiByte(loc12);
                        continue;
                    case "1000":
                        loc9 = _readNnumber(loc6, loc4[loc3][3]);
                        loc7 = 0;
                        while (loc7 < loc9) 
                        {
                            loc10 = _readNnumber(loc6, 13);
                            loc11 = Math.floor(loc10 / 192) + !((loc11 = (Math.floor(loc10 / 192))) <= 30) ? 193 : 129;
                            loc10 = (loc10 = loc10 % 192) + 64;
                            System.useCodePage = true;
                            loc5 = loc5 + unescapeMultiByte("%" + _Hex2String(loc11) + "%" + _Hex2String(loc10));
                            loc7 = (loc7 + 1);
                        }
                        continue;
                    case "0000":
                    case "000":
                    case "00":
                    case "0":
                        loc10 = _readNnumber(loc6, loc6.length);
                        continue;
                    default:
                        loc13 = 0;
                        loc5 = loc5 + "";
                        continue;
                }
            }
            return [loc13, loc5];
        }

        
    }
}

