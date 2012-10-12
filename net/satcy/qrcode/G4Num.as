package net.satcy.qrcode
{
    public class G4Num extends Object
    {
    	private var _vector:uint;

        private var _power:int;
        
        public function G4Num(arg1:int)
        {
            super();
            setPower(arg1);
            return;
        }

        

        public function plus(arg1:G4Num):G4Num
        {
            var loc2:*;

            loc2 = _vector ^ arg1.getVector();
            return new G4Num(GFstatic._vector2power_4[loc2]);
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
                _power = _power % 15;
                _vector = GFstatic._power2vector_4[_power];
            }
            return;
        }

        public function setVector(arg1:uint):void
        {
            _vector = arg1;
            _power = GFstatic._vector2power_4[arg1];
            return;
        }

        public function getVector():uint
        {
            return _vector;
        }

        public function multiply(arg1:G4Num):G4Num
        {
            if (_power == -1 || arg1.getPower() == -1)
            {
                return new G4Num(-1);
            }
            return new G4Num(_power + arg1.getPower());
        }

        public function getPower():int
        {
            return _power;
        }

        
    }
}

