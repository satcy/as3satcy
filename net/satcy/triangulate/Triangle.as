package net.satcy.triangulate
{
	import flash.geom.Point;
	
	public class Triangle
	{
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		public function Triangle(_p1:Point = null, _p2:Point = null ,_p3:Point = null)
		{
			p1 = _p1;
			p2 = _p2;
			p3 = _p3;
		}
		
		public function sharesVertex(other:Triangle):Boolean {
			return p1 == other.p1 || p1 == other.p2 || p1 == other.p3 || p2 == other.p1 || p2 == other.p2 || p2 == other.p3 || p3 == other.p1 || p3 == other.p2 || p3 == other.p3;
		}
		
		public function long():Number{
			var dx1:Number = p1.x - p2.x;
			var dy1:Number = p1.y - p2.y;
			var dx2:Number = p2.x - p3.x;
			var dy2:Number = p2.y - p3.y;
			var dx3:Number = p3.x - p1.x;
			var dy3:Number = p3.y - p1.y;
			return Math.sqrt(dx1*dx1 + dy1*dy1 + dx2*dx2 + dy2*dy2 + dx3*dx3 + dy3*dy3);
		}
		
		public function toString():String{
			return p1.x + ":" + p1.y + "-->" + p2.x + ":" + p2.y + "-->" + p3.x + ":" + p3.y;
		}
	}
}