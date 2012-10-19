package net.satcy.math{
	public function interpolateNumber(_ratio:Number, _n1:Number, _n2:Number, _auto:Boolean = true):Number{
		if ( !_auto ) return (_n2-_n1)*_ratio + _n1;
		else return (_n1 < _n2) ? _ratio*(_n2 - _n1) + _n1 : _ratio*(_n1 - _n2) + _n2;
	}	
}