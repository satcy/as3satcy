package net.satcy.qrcode{
    public class G8Num extends Object
    {
    	
        private var _vector:uint;

        private var _power:int;
        
        public function G8Num(arg1:int)
        {
            super();
            setPower(arg1);
            return;
        }

        

        public function inverse():G8Num
        {
            return new G8Num(255 - getPower());
        }

        public function plus(arg1:G8Num):G8Num
        {
            var loc2:*;

            loc2 = _vector ^ arg1.getVector();
            return new G8Num(GFstatic._vector2power_8[loc2]);
        }

        public function setPower(arg1:int):void
        {
            _power = arg1;
            if (_power < 0)
            {
                _vector = 0;
            }
            else 
            {
                _power = _power % 255;
                _vector = GFstatic._power2vector_8[_power];
            }
            return;
        }

        public function setVector(arg1:uint):void
        {
            _vector = arg1;
            _power = GFstatic._vector2power_8[_vector];
            return;
        }

        public function getVector():uint
        {
            return _vector;
        }

        public function multiply(arg1:G8Num):G8Num
        {
            if (_power < 0 || arg1.getPower() < 0)
            {
                return new G8Num(-1);
            }
            return new G8Num(_power + arg1.getPower());
        }

        public function getPower():int
        {
            return _power;
        }

    }
}

