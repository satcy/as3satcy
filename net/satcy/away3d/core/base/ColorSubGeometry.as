package net.satcy.away3d.core.base
{
	
	import away3d.arcane;
	import away3d.core.base.Geometry;
	
	import flash.display3D.Context3D;
	
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.managers.Stage3DProxy;
	import flash.geom.Matrix3D;

	
	use namespace arcane;
	
	public class ColorSubGeometry extends SubGeometry implements ISubGeometry
	{
		public function ColorSubGeometry()
		{
			super();
		}
		
		override public function get vertexStride():uint
		{
			return 6;
		}
		
		
		override public function activateVertexBuffer(index:int, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:int = stage3DProxy._stage3DIndex;
			var context:Context3D = stage3DProxy._context3D;
			if (!_vertexBuffer[contextIndex] || _vertexBufferContext[contextIndex] != context) {
				_vertexBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 6);
				_vertexBufferContext[contextIndex] = context;
				_verticesInvalid[contextIndex] = true;
			}
			if (_verticesInvalid[contextIndex]) {
				_vertexBuffer[contextIndex].uploadFromVector(_vertexData, 0, _numVertices);
				_verticesInvalid[contextIndex] = false;
			}
			
			context.setVertexBufferAt(index, _vertexBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_3);
			context.setVertexBufferAt(index+1, _vertexBuffer[contextIndex], 3, Context3DVertexBufferFormat.FLOAT_3);
			
		}
		
		override public function updateVertexData(vertices:Vector.<Number>):void
		{
			if (_autoDeriveVertexNormals)
				_vertexNormalsDirty = true;
			if (_autoDeriveVertexTangents)
				_vertexTangentsDirty = true;
			
			_faceNormalsDirty = true;
			
			_vertexData = vertices;
			var numVertices:int = vertices.length/6;
			if (numVertices != _numVertices)
				disposeAllVertexBuffers();
			_numVertices = numVertices;
			
			invalidateBuffers(_verticesInvalid);
			
			invalidateBounds();
		}
		
		
		
		override public function clone():ISubGeometry
		{
			var clone:ColorSubGeometry = new ColorSubGeometry();
			clone.updateVertexData(_vertexData.concat());
			clone.updateUVData(_uvs.concat());
			clone.updateIndexData(_indices.concat());
			if (_secondaryUvs)
				clone.updateSecondaryUVData(_secondaryUvs.concat());
			if (!_autoDeriveVertexNormals)
				clone.updateVertexNormalData(_vertexNormals.concat());
			if (!_autoDeriveVertexTangents)
				clone.updateVertexTangentData(_vertexTangents.concat());
			return clone;
			
		}
		
		
		
		
	}
}