package net.satcy.away3d.primitives
{
	import away3d.primitives.LineSegment;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.primitives.data.Segment;
	
	import flash.geom.Vector3D;
	
	import net.satcy.math.interpolateNumber;
	
	/**
	 * A WireframePlane primitive mesh.
	 */
	public class WireframeGradientCircle extends WireframePrimitiveBase
	{
		public static const ORIENTATION_YZ:String = "yz";
		public static const ORIENTATION_XY:String = "xy";
		public static const ORIENTATION_XZ:String = "xz";

		private var _radius : Number;
		private var _segmentsR : int;
		private var _orientation : String;
		private var _color2:uint;
		private var _arc:Number = 1;
		/**
		 * Creates a new WireframePlane object.
		 * @param width The size of the cube along its X-axis.
		 * @param height The size of the cube along its Y-axis.
		 * @param segmentsW The number of segments that make up the cube along the X-axis.
		 * @param segmentsH The number of segments that make up the cube along the Y-axis.
		 * @param color The colour of the wireframe lines
		 * @param thickness The thickness of the wireframe lines
		 * @param orientation The orientaion in which the plane lies.
		 */
		public function WireframeGradientCircle(radius : Number, segments : int  =12, color:uint = 0xFFFFFF, color2:uint = 0xFFFFFF, arc:Number = 1,thickness:Number = 1, orientation : String = "xy") {
			super(color, thickness);
			_radius = radius;
			_segmentsR = segments;
			_orientation = orientation;
			_color2 = color2;
			_arc = arc;
		}

		/**
		 * The orientaion in which the plane lies.
		 */
		public function get orientation() : String
		{
			return _orientation;
		}

		public function set orientation(value : String) : void
		{
			_orientation = value;
			invalidateGeometry();
		}
		public function get radius() : Number
		{
			return _radius;
		}

		public function set radius(value : Number) : void
		{
			_radius = value;
			invalidateGeometry();
		}
		
		public function get arc() : Number
		{
			return _arc;
		}

		public function set arc(value : Number) : void
		{
			_arc = value;
			invalidateGeometry();
		}
	
		/**
		 * The number of segments that make up the plane along the X-axis.
		 */
		public function get segmentsR() : int
		{
			return _segmentsR;
		}

		public function set segmentsR(value : int) : void
		{
			_segmentsR = value;
			removeAllSegments();
			invalidateGeometry();
		}
		
		/**
		 * The size of the cube along its X-axis.
		 */
		public function get color2() : uint
		{
			return _color2;
		}

		public function set color2(value : uint) : void
		{
			_color2 = value;
			invalidateGeometry();
		}
		
		override protected function updateOrAddSegment(index : uint, v0 : Vector3D, v1 : Vector3D) : void
		{
			var segment : Segment;
			var s : Vector3D, e : Vector3D;
			
			var _ratio1:Number = index/(_segments.length);
			var _ratio2:Number = (index+1)/(_segments.length);
			
			var _r1:Number = color >> 16 & 0xFF;
			var _g1:Number = color >> 8 & 0xFF;
			var _b1:Number = color & 0xFF;
			var _r2:Number = _color2 >> 16 & 0xFF;
			var _g2:Number = _color2 >> 8 & 0xFF;
			var _b2:Number = _color2 & 0xFF;
			
			var _c1:uint = int(interpolateNumber(_ratio1, _r1, _r2)) << 16 | int(interpolateNumber(_ratio1, _g1, _g2)) << 8 | int(interpolateNumber(_ratio1, _b1, _b2));
			var _c2:uint = int(interpolateNumber(_ratio2, _r1, _r2)) << 16 | int(interpolateNumber(_ratio2, _g1, _g2)) << 8 | int(interpolateNumber(_ratio2, _b1, _b2));
			
			if (_segments.length > index) {
				segment = _segments[index];
				s = segment.start;
				e = segment.end;
				s.x = v0.x; s.y = v0.y; s.z = v0.z;
				e.x = v1.x; e.y = v1.y; e.z = v1.z;
				_segments[index].updateSegment(s, e, null, _c1, _c2, thickness);
			}
			else {
				addSegment( new LineSegment(v0.clone(), v1.clone(), _c1, _c2, thickness));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildGeometry() : void
		{
			var v0 : Vector3D = new Vector3D();
			var v1 : Vector3D = new Vector3D();
			var index : int;
			var i:int;
			var _radian:Number = 0;
			
			var _f:Number = Math.PI*2*arc;

			if (_orientation == ORIENTATION_XY) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = (i/_segmentsR)*_f;
					v0.x = Math.cos(_radian)*this._radius;
					v0.y = Math.sin(_radian)*this._radius;
					
					_radian = ((i+1)/_segmentsR)*_f;
					v1.x = Math.cos(_radian)*this._radius;
					v1.y = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}

			}

			else if (_orientation == ORIENTATION_XZ) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = (i/_segmentsR)*_f;
					v0.x = Math.cos(_radian)*this._radius;
					v0.z = Math.sin(_radian)*this._radius;
					
					_radian = ((i+1)/_segmentsR)*_f;
					v1.x = Math.cos(_radian)*this._radius;
					v1.z = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}
			}

			else if (_orientation == ORIENTATION_YZ) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = (i/_segmentsR)*_f;
					v0.y = Math.cos(_radian)*this._radius;
					v0.z = Math.sin(_radian)*this._radius;
					
					_radian = ((i+1)/_segmentsR)*_f;
					v1.y = Math.cos(_radian)*this._radius;
					v1.z = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}
			}
		}

	}
}
