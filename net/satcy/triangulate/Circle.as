package net.satcy.triangulate
{
	import flash.geom.Point;
	public class Circle extends Point{
		public var z:Number;
		public function Circle(_x:Number=0, _y:Number=0, _z:Number=0){
			super(_x, _y);
			this.z = _z;
		}
	}
}