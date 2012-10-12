package net.satcy.math{
	public function fastAbs(x:Number):Number{
		return (x ^ (x >> 31)) - (x >> 31);
	}
}