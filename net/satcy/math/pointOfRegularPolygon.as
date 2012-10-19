package net.satcy.math{
	import flash.geom.Point;
	
	public function pointOfRegularPolygon(_radius:Number, _num:int, _radian:Number):Point{
		var cep:Number = (Math.PI*2)/_num;
		var _pt1:Point;
		var _pt2:Point;
		var _rad1:Number;
		var _rad2:Number;
		for ( var i:int = 0; i<_num; i++ ) {
			_rad1 = i*cep;
			_rad2 = (i+1)*cep;
			if ( _rad2 > _radian && _rad1 <= _radian ) {
				_pt1 = new Point(Math.cos(_rad1)*_radius, Math.sin(_rad1)*_radius);
				_pt2 = new Point(Math.cos(_rad2)*_radius, Math.sin(_rad2)*_radius);
				break;
			}
		}
		if ( !_pt1 ) return new Point();
		var _ratio:Number = (_radian - _rad1)/cep;
		return new Point(interpolateNumber(_ratio, _pt1.x, _pt2.x, false), interpolateNumber(_ratio, _pt1.y, _pt2.y, false));
	}

	
}