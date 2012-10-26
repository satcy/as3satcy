package net.satcy.away3d.primitives
{
	import away3d.primitives.WireframePrimitiveBase;
	
	import flash.geom.Vector3D;
	
	/**
	 * A WireframePlane primitive mesh.
	 */
	public class WireframeCircle extends WireframePrimitiveBase
	{
		public static const ORIENTATION_YZ:String = "yz";
		public static const ORIENTATION_XY:String = "xy";
		public static const ORIENTATION_XZ:String = "xz";

		private var _radius : Number;
		private var _segmentsR : int;
		private var _orientation : String;

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
		public function WireframeCircle(radius : Number, segments : int  =12, color:uint = 0xFFFFFF, thickness:Number = 1, orientation : String = "xy") {
			super(color, thickness);
			_radius = radius;
			_segmentsR = segments;
			_orientation = orientation;
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

		/**
		 * The size of the cube along its X-axis.
		 */
		public function get radius() : Number
		{
			return _radius;
		}

		public function set radius(value : Number) : void
		{
			_radius = value;
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
		 * @inheritDoc
		 */
		override protected function buildGeometry() : void
		{
			var v0 : Vector3D = new Vector3D();
			var v1 : Vector3D = new Vector3D();
			var index : int;
			var i:int;
			var _radian:Number = 0;
			var _cep:Number = (Math.PI*2)/_segmentsR;
			if (_orientation == ORIENTATION_XY) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = i*_cep;
					v0.x = Math.cos(_radian)*this._radius;
					v0.y = Math.sin(_radian)*this._radius;
					
					_radian = (i+1)*_cep;
					v1.x = Math.cos(_radian)*this._radius;
					v1.y = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}

			}

			else if (_orientation == ORIENTATION_XZ) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = i*_cep;
					v0.x = Math.cos(_radian)*this._radius;
					v0.z = Math.sin(_radian)*this._radius;
					
					_radian = (i+1)*_cep;
					v1.x = Math.cos(_radian)*this._radius;
					v1.z = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}
			}

			else if (_orientation == ORIENTATION_YZ) {
				v0.x = v0.y = v0.z = 0;
				v1.x = v1.y = v1.z = 0;

				for (i = 0; i < _segmentsR; i++) {
					_radian = i*_cep;
					v0.y = Math.cos(_radian)*this._radius;
					v0.z = Math.sin(_radian)*this._radius;
					
					_radian = (i+1)*_cep;
					v1.y = Math.cos(_radian)*this._radius;
					v1.z = Math.sin(_radian)*this._radius;
					
					updateOrAddSegment(index++, v0, v1);
				}
			}
		}

	}
}
