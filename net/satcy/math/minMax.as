package net.satcy.math{
	public function minMax(num:Number, min:Number, max:Number):Number{
		return (((num < min) ? min : num) > max) ? max : num;
	}
}