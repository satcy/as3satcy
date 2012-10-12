package net.satcy.math{
	public function fastAbs(x:Number):Number{//this isnt fast
		return (x ^ (x >> 31)) - (x >> 31);
	}
}