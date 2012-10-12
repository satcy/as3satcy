package net.satcy.math{
	public function function scale(num:Number, in_min:Number, in_max:Number, out_min:Number, out_max:Number):Number{
		return ((out_max - out_min)/(in_max - in_min))*num + out_min;
	}
}