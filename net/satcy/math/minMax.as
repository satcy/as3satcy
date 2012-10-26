package net.satcy.math{
	public function minMax(num:Number, min:Number, max:Number):Number{
		return Math.max(Math.min(num, max), min);
	}
}