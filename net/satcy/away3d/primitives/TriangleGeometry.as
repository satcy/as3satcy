package net.satcy.away3d.primitives
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.primitives.PrimitiveBase;
	use namespace arcane;

	/**
	 * A UV Sphere primitive mesh.
	 */
	public class TriangleGeometry extends PrimitiveBase
	{
		private var _radius : Number;
		private var _yUp : Boolean;
		
//		protected var _topRadius:Number;
//		protected var _bottomRadius:Number;
//		protected var _height:Number;
		protected var _segmentsW:uint;
//		protected var _segmentsH:uint;
//		protected var _topClosed:Boolean;
//		protected var _bottomClosed:Boolean;
//		protected var _surfaceClosed:Boolean;
		private var _rawData:Vector.<Number>;
		private var _rawIndices:Vector.<uint>;
		private var _nextVertexIndex:uint;
		private var _currentIndex:uint;
		private var _currentTriangleIndex:uint;
		private var _numVertices:uint;
		private var _stride:uint;
		private var _vertexOffset:uint;

		public function TriangleGeometry(radius : Number = 50, yUp : Boolean = true)
		{
			super();

			//_topRadius = radius;
			//_bottomRadius = 0;
			//_height = 0;
			_segmentsW = 3;
			//_segmentsH = 1;
			//_topClosed = true;
			//_bottomClosed = false;
			//_surfaceClosed = false;
			
			_radius = radius;
			_yUp = yUp;
		}
		
		private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:uint = _vertexOffset + _nextVertexIndex*_stride; // current component vertex index
			_rawData[compVertInd++] = px;
			_rawData[compVertInd++] = py;
			_rawData[compVertInd++] = pz;
			_rawData[compVertInd++] = nx;
			_rawData[compVertInd++] = ny;
			_rawData[compVertInd++] = nz;
			_rawData[compVertInd++] = tx;
			_rawData[compVertInd++] = ty;
			_rawData[compVertInd++] = tz;
			_nextVertexIndex++;
		}
		
		private function addTriangleClockWise(cwVertexIndex0:uint, cwVertexIndex1:uint, cwVertexIndex2:uint):void
		{
			_rawIndices[_currentIndex++] = cwVertexIndex0;
			_rawIndices[_currentIndex++] = cwVertexIndex1;
			_rawIndices[_currentIndex++] = cwVertexIndex2;
			_currentTriangleIndex++;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target : CompactSubGeometry) : void
		{
			var i:uint, j:uint;
			var x:Number, y:Number, z:Number, radius:Number, revolutionAngle:Number;
			var dr:Number, latNormElev:Number, latNormBase:Number;
			var numTriangles:uint = 0;
			
			var comp1:Number, comp2:Number;
			var startIndex:uint;
			//numvert:uint = 0;
			var t1:Number, t2:Number;
			
			_stride = target.vertexStride;
			_vertexOffset = target.vertexOffset;
			
			// reset utility variables
			_numVertices = 0;
			_nextVertexIndex = 0;
			_currentIndex = 0;
			_currentTriangleIndex = 0;
			
			_numVertices = 3;
			numTriangles = 1;
			
			// need to initialize raw arrays or can be reused?
			if (_numVertices == target.numVertices) {
				_rawData = target.vertexData;
				_rawIndices = target.indexData || new Vector.<uint>(numTriangles*3, true);
			} else {
				var numVertComponents:uint = _numVertices*_stride;
				_rawData = new Vector.<Number>(numVertComponents, true);
				_rawIndices = new Vector.<uint>(numTriangles*3, true);
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/Number(_segmentsW);
			
			
			z = 0;
			
			for (i = 0; i < _segmentsW; ++i) {
				// central vertex
				if (_yUp) {
					t1 = 1;
					t2 = 0;
					comp1 = -z;
					comp2 = 0;
					
				} else {
					t1 = 0;
					t2 = -1;
					comp1 = 0;
					comp2 = z;
				}
				
				//addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
				
				// revolution vertex
				revolutionAngle = i*revolutionAngleDelta;
				x = _radius*Math.cos(revolutionAngle);
				y = _radius*Math.sin(revolutionAngle);
				
				if (_yUp) {
					comp1 = -z;
					comp2 = y;
				} else {
					comp1 = y;
					comp2 = z;
				}
				
				addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
				
			}
			addTriangleClockWise(0, 2, 1);
		
		
		
			
			// build real data from raw data
			target.updateData(_rawData);
			target.updateIndexData(_rawIndices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target : CompactSubGeometry) : void
		{
			var i:int, j:int;
			var x:Number, y:Number, revolutionAngle:Number;
			var stride:uint = target.UVStride;
			var skip:uint = stride - 2;
			var UVData:Vector.<Number>;
			
			// evaluate num uvs
			var numUvs:uint = _numVertices*stride;
			
			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
				UVData = target.UVData;
			else {
				UVData = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/Number(_segmentsW);
			
			// current uv component index
			var currentUvCompIndex:uint = target.UVOffset;
			
			for (i = 0; i < _segmentsW; ++i) {
				
				revolutionAngle = i*revolutionAngleDelta;
				x = 0.5 + 0.5* -Math.cos(revolutionAngle);
				y = 0.5 + 0.5*Math.sin(revolutionAngle);
				
				UVData[currentUvCompIndex++] = 0.5*target.scaleU; // central vertex
				UVData[currentUvCompIndex++] = 0.5*target.scaleV;
				currentUvCompIndex += skip;
				//UVData[currentUvCompIndex++] = x*target.scaleU; // revolution vertex
				//UVData[currentUvCompIndex++] = y*target.scaleV;
				//currentUvCompIndex += skip;
			}
		
			
			// build real data from raw data
			target.updateData(UVData);
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
		
		public static function setTriangle(mesh:Mesh, vecs:Array, multi:Number = 1):void{
			var vertex:Vector.<Number> = (((mesh.subMeshes[0] as SubMesh).subGeometry as CompactSubGeometry).vertexData);
			
			var l:int = vertex.length;
			for ( var i:int = 0; i<l; i+=13 ){
				var index:int = i/13;
				vertex[i] += (vecs[index].x - vertex[i] )*multi;
				vertex[i+1] += (vecs[index].y - vertex[i+1])*multi;
				vertex[i+2] += (vecs[index].z - vertex[i+2])*multi;
			}
			((mesh.subMeshes[0] as SubMesh).subGeometry as CompactSubGeometry).updateData(vertex);
		}
	}
}