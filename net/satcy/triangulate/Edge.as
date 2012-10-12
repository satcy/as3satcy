package net.satcy.triangulate
{
	import flash.geom.Point;
	
	public class Edge
	{
		public var p1:Point;
		public var p2:Point;
		public function Edge(_p1:Point = null, _p2:Point = null) {
			p1 = _p1;
    		p2 = _p2;
		}
	}
}