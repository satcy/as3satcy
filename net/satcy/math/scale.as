package net.satcy.math{
	public function scale(num:Number, in_min:Number, in_max:Number, out_min:Number, out_max:Number):Number{
		return ((num - in_min)/(in_max - in_min))*(out_max - out_min) + out_min;
	}
}