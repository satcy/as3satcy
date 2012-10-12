package net.satcy.math
{
	public function zmap(num:Number, in_min:Number, in_max:Number, out_min:Number, out_max:Number):Number{
		return minMax(scale(num, in_min, in_max, out_min, out_max), out_min, out_max);
	}
}