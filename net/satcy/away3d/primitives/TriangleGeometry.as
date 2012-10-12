package net.satcy.away3d.primitives
{
	import away3d.arcane;
	import away3d.core.base.SubGeometry;
	import away3d.materials.MaterialBase;
	import away3d.primitives.PrimitiveBase;

	use namespace arcane;

	/**
	 * A UV Sphere primitive mesh.
	 */
	public class TriangleGeometry extends PrimitiveBase
	{
		private var _radius : Number;
		private var _yUp : Boolean;

		public function TriangleGeometry(radius : Number = 50, yUp : Boolean = true)
		{
			super();

			_radius = radius;
			_yUp = yUp;
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target : SubGeometry) : void
		{
			var vertices : Vector.<Number>;
			var vertexNormals : Vector.<Number>;
			var vertexTangents : Vector.<Number>;
			var indices : Vector.<uint>;
			var i : uint, j : uint, triIndex : uint;
			var numVerts : uint = 3;

			if (numVerts == target.numVertices) {
				vertices = target.vertexData;
				vertexNormals = target.vertexNormalData;
				vertexTangents = target.vertexTangentData;
				indices = target.indexData;
			}
			else {
				vertices = new Vector.<Number>(numVerts * 3, true);
				vertexNormals = new Vector.<Number>(numVerts * 3, true);
				vertexTangents = new Vector.<Number>(numVerts * 3, true);
				indices = new Vector.<uint>(3, true);
				indices[0] = 0;
				indices[1] = 1;
				indices[2] = 2;
			}

			numVerts = 0;
			for (i = 0; i <= 2; ++i) {
				var horangle : Number = Math.PI * 0.5;
				var y : Number = -_radius * Math.cos(horangle);
				var ringradius : Number = _radius * Math.sin(horangle);

				var verangle : Number = 2 * Math.PI * i / 3 - Math.PI / 2;
				var x : Number = ringradius * Math.cos(verangle);
				var z : Number = ringradius * Math.sin(verangle) - ringradius / 2;
				var normLen : Number = 1 / Math.sqrt(x * x + y * y + z * z);
				var tanLen : Number = Math.sqrt(y * y + x * x);

				if (_yUp) {
					vertexNormals[numVerts] = x * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
					vertices[numVerts++] = x;
					vertexNormals[numVerts] = -z * normLen;
					vertexTangents[numVerts] = 0;
					vertices[numVerts++] = -z;
					vertexNormals[numVerts] = y * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? x / tanLen : 0;
					vertices[numVerts++] = y;
				}
				else {
					vertexNormals[numVerts] = x * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
					vertices[numVerts++] = x;
					vertexNormals[numVerts] = y * normLen;
					vertexTangents[numVerts] = tanLen > .007 ? x / tanLen : 0;
					vertices[numVerts++] = y;
					vertexNormals[numVerts] = z * normLen;
					vertexTangents[numVerts] = 0;
					vertices[numVerts++] = z;
				}

			}

			target.updateVertexData(vertices);
			target.updateVertexNormalData(vertexNormals);
			target.updateVertexTangentData(vertexTangents);
			target.updateIndexData(indices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target : SubGeometry) : void
		{
			var i : int, j : int;
			var numUvs : uint = 3 * 2;
			var uvData : Vector.<Number>;

			if (target.UVData && numUvs == target.UVData.length)
				uvData = target.UVData;
			else
				uvData = new Vector.<Number>(numUvs, true);

			uvData[0] = (0);
			uvData[1] = (0);
			uvData[2] = (1);
			uvData[3] = (0);
			uvData[4] = (0);
			uvData[5] = (1);
			

			target.updateUVData(uvData);
		}

		/**
		 * The radius of the sphere.
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
		 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function get yUp() : Boolean
		{
			return _yUp;
		}

		public function set yUp(value : Boolean) : void
		{
			_yUp = value;
			invalidateGeometry();
		}
	}
}