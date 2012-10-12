package net.satcy.away3d.primitives{
		
	import away3d.cameras.Camera3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	//import away3d.primitives.Cube;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class BezierCurve
	{
		
		private var _p0:Vector3D;
		private var _p1:Vector3D;
		private var _p2:Vector3D;
		
		public var length:Number;
		
		function BezierCurve(p0:Vector3D, p1:Vector3D, p2:Vector3D)
		{
			this._p0 = p0;
			this._p1 = p1;
			this._p2 = p2;
			
			length = BezierCurve.getBezierLength(this);
		}
		
		// http://segfaultlabs.com/docs/quadratic-bezier-curve-length
		static public function getBezierLength(bezier:BezierCurve):Number
		{
			var a:Vector3D = new Vector3D; 
			var b:Vector3D = new Vector3D;
			var c:Vector3D = new Vector3D;
			
			var p0:Vector3D = bezier.p0;
			var p1:Vector3D = bezier.p1;
			var p2:Vector3D = bezier.p2;
			
			a.x = p0.x - 2 * p1.x + p2.x;
			a.y = p0.y - 2 * p1.y + p2.y;
			a.z = p0.z - 2 * p1.z + p2.z;
			
			b.x = 2 * (p1.x - a.x);
			b.y = 2 * (p1.y - a.y);
			b.z = 2 * (p1.z - a.z);
			
			var A:Number = 4 * (a.x * a.x + a.y * a.y + a.z * a.z);
			
			if (A == 0) return 0;
			
			var B:Number = 4 * (a.x * b.x + a.y * b.y + a.z * b.z);
			var C:Number = b.x * b.x + b.y * b.y + b.z * b.z;
			
			var Sabc:Number = 2 * Math.sqrt(A + B + C);
			var A2:Number = Math.sqrt(A);
			var A32:Number = 2 * A * A2;
			var C2:Number = 2 * Math.sqrt(C);
			var BA:Number = B / A2;
			
			return (A32 * Sabc + A2 * B * (Sabc - C2) + (4 * C * A - B * B) * Math.log(2 * A2 +BA + Sabc) / (BA + C2)) / (4 * A32);
		}
		
		public function toString():String
		{
			return "[" + p0.toString() + ", " + p1.toString() + ", " + p2.toString() + "]";
		}
		
		public function getT(t:Number):Vector3D
		{
			var v:Vector3D = new Vector3D;
			
			v.x = _p0.x + t * (2 * (1 - t) * (_p1.x - _p0.x) + t * (_p2.x - _p0.x));
			v.y = _p0.y + t * (2 * (1 - t) * (_p1.y - _p0.y) + t * (_p2.y - _p0.y));
			v.z = _p0.z + t * (2 * (1 - t) * (_p1.z - _p0.z) + t * (_p2.z - _p0.z));
			
			return v;
		}
		
		public function get p2():Vector3D 
		{
			return _p2;
		}
		
		public function set p2(value:Vector3D):void 
		{
			_p2 = value;
			length = BezierCurve.getBezierLength(this);
		}
		
		public function get p1():Vector3D 
		{
			return _p1;
		}
		
		public function set p1(value:Vector3D):void 
		{
			_p1 = value;
			length = BezierCurve.getBezierLength(this);
		}
		
		public function get p0():Vector3D 
		{
			return _p0;
		}
		
		public function set p0(value:Vector3D):void 
		{
			_p0 = value;
			length = BezierCurve.getBezierLength(this);
		}
	}

}