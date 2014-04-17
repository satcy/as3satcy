package net.satcy.away3d.primitives {

    import __AS3__.vec.Vector;
    
    import away3d.primitives.WireframePrimitiveBase;
    
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;

    public class WireframeGeodesicSphere extends WireframePrimitiveBase {
        
        private var _radius:Number;
        private var _fractures:uint;
        private static var radian:Number = Math.PI/180;
        private static var sections:uint = 20;
        private static var deg180:Number = Math.PI;
        private static var deg360:Number = Math.PI*2;
		
		private var _vectors:Array;
		private var _vertices:Vector.<Vector3D>;
		private var _indices:Vector.<uint>;
		private var _uvs:Vector.<Number>;
		
        public function WireframeGeodesicSphere(radius:Number = 50, fractures:uint = 2, color:uint = 0xFFFFFF, thickness:Number = 1) {
            super(color, thickness);
            _radius = radius;
            _fractures = fractures;
        }
        
        public function get vectors():Array{
        	return _vectors;//[n][t][0-1]
        }
        
        public function get copyVectors():Array{
        	if ( !_vectors ) return null;
        	var _arr:Array = [];
        	var vectors:Array = _vectors;
			var n:int, t:int;
			var v0:Vector3D, v1:Vector3D;
			var segment:uint = 0;
			 for (n = 0; n < vectors.length; n++) {
                if (vectors[n]) {
			 		if ( !_arr[n] ) _arr[n] = [];
                    for (t = 0; t < vectors[n].length; t++) {
                        if (vectors[n][t]) {
 		                   	if ( !_arr[n][t] ) _arr[n][t] = [];
                            v0 = vectors[n][t][0];
                            v1 = vectors[n][t][1];
                            _arr[n][t][0] = v0.clone();
                            _arr[n][t][1] = v1.clone();
                        }
                    }
                }
            }
            return _arr;
        }
		
		public function redraw():void{
			if ( !_vectors ) return;
			var vectors:Array = _vectors;
			var n:int, t:int;
			var v0:Vector3D, v1:Vector3D;
			var segment:uint = 0;
			 for (n = 0; n < vectors.length; n++) {
                if (vectors[n]) {
                    for (t = 0; t < vectors[n].length; t++) {
                        if (vectors[n][t]) {
                            v0 = vectors[n][t][0];
                            v1 = vectors[n][t][1];
                            updateOrAddSegment(segment++, v0, v1);
                        }
                    }
                }
            }
		}
		
		public function getNearTriangle(vec:Vector3D):Array{
			var a:Array = [];
			var i:int = 0;
			var l:int = _indices.length;
			var min:Number = Number.MAX_VALUE;
			var d:Number = 0;
			for ( i=0; i<l; i+= 3 ) {
				var v1:Vector3D = _vertices[_indices[i]];
				var v2:Vector3D = _vertices[_indices[i+1]];
				var v3:Vector3D = _vertices[_indices[i+2]];
				d = 0;
				d += Vector3D.distance(vec, v1);
				d += Vector3D.distance(vec, v2);
				d += Vector3D.distance(vec, v3);
				if ( d < min ) {
					a = [v1, v2, v3,
					_uvs[_indices[i]*2], _uvs[_indices[i]*2+1],
					_uvs[_indices[i+1]*2], _uvs[_indices[i+1]*2+1],
					_uvs[_indices[i+2]*2], _uvs[_indices[i+2]*2+1]
					];
					min = d;
				}
			}
			return a;
		}

        override protected function buildGeometry():void {
            if (_fractures == 0) return;
            var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(0, false);
            var uvs:Vector.<Number> = new Vector.<Number>(0, false);
            var indices:Vector.<uint> = new Vector.<uint>();
            var n:uint, t:uint;
            var theta:Number, cos:Number, sin:Number;
            var subz:Number = 4.472136E-001*_radius;
            var subrad:Number = 2*subz;

            vertices.push(new Vector3D(0, 0, _radius, - 1));
            uvs.length += 2;
            for (n = 0; n < 5; n++) {
                theta = deg360*n/5 - 0.03;
                sin = Math.sin(theta);
                cos = Math.cos(theta);
                vertices.push(new Vector3D(subrad*cos, subrad*sin, subz, - 1));
                uvs.length += 2;
            }
            for (n = 0; n < 5; n++) {
                theta = deg180*((n << 1) + 1)/5;
                sin = Math.sin(theta);
                cos = Math.cos(theta);
                vertices.push(new Vector3D(subrad*cos, subrad*sin, - subz, - 1));
                uvs.length += 2;
            }
            vertices.push(new Vector3D(0, 0, - _radius, - 1));
            uvs.length += 2;

            for (n = 1; n < 6; n++) {
                interpolate(0, n, _fractures, vertices, uvs);
            }
            for (n = 1; n < 6; n++) {
                interpolate(n, n%5 + 1, _fractures, vertices, uvs);
            }
            for (n = 1; n < 6; n++) {
                interpolate(n, n + 5, _fractures, vertices, uvs);
            }
            for (n = 1; n < 6; n++) {
                interpolate(n, (n + 3)%5 + 6, _fractures, vertices, uvs);
            }
            for (n = 1; n < 6; n++) {
                interpolate(n + 5, n%5 + 6, _fractures, vertices, uvs);
            }
            for (n = 6; n < 11; n++) {
                interpolate(11, n, _fractures, vertices, uvs);
            }
            for (t = 0; t < 5; t++) {
                for (n = 1; n <= _fractures - 2; n++) {
                    interpolate(12 + t*(_fractures - 1) + n, 12 + (t + 1)%5*(_fractures - 1) + n, n + 1, vertices, uvs);
                }
            }
            for (t = 0; t < 5; t++) {
                for (n = 1; n <= _fractures - 2; n++) {
                    interpolate(12 + (t + 15)*(_fractures - 1) + n, 12 + (t + 10)*(_fractures - 1) + n, n + 1, vertices, uvs);
                }
            }
            for (t = 0; t < 5; t++) {
                for (n = 1; n <= _fractures - 2; n++) {
                    interpolate(12 + ((t + 1)%5 + 15)*(_fractures - 1) + _fractures - 2 - n, 12 + (t + 10)*(_fractures - 1) + _fractures - 2 - n, n + 1, vertices, uvs);
                }
            }
            for (t = 0; t < 5; t++) {
                for (n = 1; n <= _fractures - 2; n++) {
                    interpolate(12 + ((t + 1)%5 + 25)*(_fractures - 1) + n, 12 + (t + 25)*(_fractures - 1) + n, n + 1, vertices, uvs);
                }
            }
            for (t = 0; t < sections; t++) {
                for (var row:uint = 0; row < _fractures; row++) {
                    for (var col:uint = 0; col <= row; col++) {
                        var aIndex:uint = findVertices(_fractures, t, row, col);
                        var bIndex:uint = findVertices(_fractures, t, row + 1, col);
                        var cIndex:uint = findVertices(_fractures, t, row + 1, col + 1);
                        var a:Vector3D = vertices[aIndex];
                        var b:Vector3D = vertices[bIndex];
                        var c:Vector3D = vertices[cIndex];
                        var au:Number;
                        var av:Number;
                        var bu:Number;
                        var bv:Number;
                        var cu:Number;
                        var cv:Number;
                        if (a.y >= 0 && (a.x < 0) && (b.y < 0 || c.y < 0)) {
                            au = Math.atan2(a.y, a.x)/deg360 - 0.5;
                        } else {
                            au = Math.atan2(a.y, a.x)/deg360 + 0.5;
                        }
                        av = -Math.asin(a.z/_radius)/deg180 + 0.5;
                        if (b.y >= 0 && (b.x < 0) && (a.y < 0 || c.y < 0)) {
                            bu = Math.atan2(b.y, b.x)/deg360 - 0.5;
                        } else {
                            bu = Math.atan2(b.y, b.x)/deg360 + 0.5;
                        }
                        bv = -Math.asin(b.z/_radius)/deg180 + 0.5;
                        if (c.y >= 0 && (c.x < 0) && (a.y < 0 || b.y < 0)) {
                            cu = Math.atan2(c.y, c.x)/deg360 - 0.5;
                        } else {
                            cu = Math.atan2(c.y, c.x)/deg360 + 0.5;
                        }
                        cv = -Math.asin(c.z/_radius)/deg180 + 0.5;
                        if (aIndex == 0 || aIndex == 11) {
                            au = bu + (cu - bu)*0.5;
                        }
                        if (bIndex == 0 || bIndex == 11) {
                            bu = au + (cu - au)*0.5;
                        }
                        if (cIndex == 0 || cIndex == 11) {
                            cu = au + (bu - au)*0.5;
                        }
                        if (a.w > 0 && uvs[aIndex*2] != 1 - au) {
                            a = createVertex(a.x, a.y, a.z);
                            aIndex = vertices.push(a) - 1;
                        }
                        uvs[aIndex*2] = 1 - au;
                        uvs[aIndex*2 + 1] = av;
                        a.w = 1;
                        if (b.w > 0 && uvs[bIndex*2] != 1 - bu) {
                            b = createVertex(b.x, b.y, b.z);
                            bIndex = vertices.push(b) - 1;
                        }
                        uvs[bIndex*2] = 1 - bu;
                        uvs[bIndex*2 + 1] = bv;
                        b.w = 1;
                        if (c.w > 0 && uvs[cIndex*2] != 1 - cu) {
                            c = createVertex(c.x, c.y, c.z);
                            cIndex = vertices.push(c) - 1;
                        }
                        uvs[cIndex*2] = 1 - cu;
                        uvs[cIndex*2 + 1] = cv;
                        c.w = 1;
                        indices.push(aIndex, bIndex, cIndex);
                        if (col < row) {
                            bIndex = findVertices(_fractures, t, row, col + 1);
                            b = vertices[bIndex];
                            if (a.y >= 0 && (a.x < 0) && (b.y < 0 || c.y < 0)) {
                                au = Math.atan2(a.y, a.x)/deg360 - 0.5;
                            } else {
                                au = Math.atan2(a.y, a.x)/deg360 + 0.5;
                            }
                            av = -Math.asin(a.z/_radius)/deg180 + 0.5;
                            if (b.y >= 0 && (b.x < 0) && (a.y < 0 || c.y < 0)) {
                                bu = Math.atan2(b.y, b.x)/deg360 - 0.5;
                            } else {
                                bu = Math.atan2(b.y, b.x)/deg360 + 0.5;
                            }
                            bv = -Math.asin(b.z/_radius)/deg180 + 0.5;
                            if (c.y >= 0 && (c.x < 0) && (a.y < 0 || b.y < 0)) {
                                cu = Math.atan2(c.y, c.x)/deg360 - 0.5;
                            } else {
                                cu = Math.atan2(c.y, c.x)/deg360 + 0.5;
                            }
                            
                            cv = -Math.asin(c.z/_radius)/deg180 + 0.5;
                            if (aIndex == 0 || aIndex == 11) {
                                au = bu + (cu - bu)*0.5;
                            }
                            if (bIndex == 0 || bIndex == 11) {
                                bu = au + (cu - au)*0.5;
                            }
                            if (cIndex == 0 || cIndex == 11) {
                                cu = au + (bu - au)*0.5;
                            }
                            if (a.w > 0 && uvs[aIndex*2] != 1 - au) {
                                a = createVertex(a.x, a.y, a.z);
                                aIndex = vertices.push(a) - 1;
                            }
                            uvs[aIndex*2] = 1 - au;
                            uvs[aIndex*2 + 1] = av;
                            a.w = 1;
                            if (b.w > 0 && uvs[bIndex*2] != 1 - bu) {
                                b = createVertex(b.x, b.y, b.z);
                                bIndex = vertices.push(b) - 1;
                            }
                            uvs[bIndex*2] = 1 - bu;
                            uvs[bIndex*2 + 1] = bv;
                            b.w = 1;
                            if (c.w > 0 && uvs[cIndex*2] != 1 - cu) {
                                c = createVertex(c.x, c.y, c.z);
                                cIndex = vertices.push(c) - 1;
                            }
                            uvs[cIndex*2] = 1 - cu;
                            uvs[cIndex*2 + 1] = cv;
                            //if ( au == 0.5 || bu == 0.5 || cu == 0.5 ) log("b", aIndex, bIndex, cIndex, au, bu, cu);
                            c.w = 1;
                            indices.push(aIndex, cIndex, bIndex);
                        }
                    }
                }
            }

            var matrix:Matrix3D = new Matrix3D();
            matrix.appendRotation(- 90, Vector3D.X_AXIS);
            for (n = 0; n < vertices.length; n++) {
                var vertex:Vector3D = vertices[n];
                vertices[n] = matrix.transformVector(vertex);
            }

            var v0:Vector3D, v1:Vector3D, v2:Vector3D;
            var id0:uint, id1:uint, id2:uint;
            var key0:Object, key1:Object, key2:Object;
            var vector0:Vector.<Vector3D>, vector1:Vector.<Vector3D>, vector2:Vector.<Vector3D>;
            var vectors:Array = new Array();
            var segment:uint = 0;
            for (n = 0; n < indices.length - 2; n += 3) {
                id0 = indices[n];
                id1 = indices[n + 1];
                id2 = indices[n + 2];
                v0 = vertices[id0];
                v1 = vertices[id1];
                v2 = vertices[id2];
                if (id0 < id1) {
                    key0 = {id0: id0, id1: id1};
                    vector0 = Vector.<Vector3D>([v0, v1]);
                } else {
                    key0 = {id0: id1, id1: id0};
                    vector0 = Vector.<Vector3D>([v1, v0]);
                }
                if (id0 < id2) {
                    key1 = {id0: id0, id1: id2};
                    vector1 = Vector.<Vector3D>([v0, v2]);
                } else {
                    key1 = {id0: id2, id1: id0};
                    vector1 = Vector.<Vector3D>([v2, v0]);
                }
                if (id1 < id2) {
                    key2 = {id0: id1, id1: id2};
                    vector2 = Vector.<Vector3D>([v1, v2]);
                } else {
                    key2 = {id0: id2, id1: id1};
                    vector2 = Vector.<Vector3D>([v2, v1]);
                }
                if (vectors[key0.id0] == null) {
                    vectors[key0.id0] = new Array();
                }
                vectors[key0.id0][key0.id1] = vector0;
                if (vectors[key1.id0] == null) {
                    vectors[key1.id0] = new Array();
                }
                vectors[key1.id0][key1.id1] = vector1;
                if (vectors[key2.id0] == null) {
                    vectors[key2.id0] = new Array();
                }
                vectors[key2.id0][key2.id1] = vector2;
            }
            for (n = 0; n < vectors.length; n++) {
                if (vectors[n]) {
                    for (t = 0; t < vectors[n].length; t++) {
                        if (vectors[n][t]) {
                            v0 = vectors[n][t][0];
                            v1 = vectors[n][t][1];
                            updateOrAddSegment(segment++, v0, v1);
                        }
                    }
                }
            }
            _vectors = vectors;
            _vertices = vertices;
            _indices = indices;
            _uvs = uvs;
        }
        private function createVertex(x:Number, y:Number, z:Number):Vector3D {
            var vertex:Vector3D = new Vector3D();
            vertex.x = x;
            vertex.y = y;
            vertex.z = z;
            vertex.w = - 1;
            return vertex;
        }
        private function interpolate(v1:uint, v2:uint, max:uint, vertices:Vector.<Vector3D>, uvs:Vector.<Number>):void {
            if (max < 2) return;
            var a:Vector3D = vertices[v1];
            var b:Vector3D = vertices[v2];
            var cos:Number = (a.x*b.x + a.y*b.y + a.z*b.z)/(a.x*a.x + a.y*a.y + a.z*a.z);
            cos = (cos < -1) ? -1 : ((cos > 1) ? 1 : cos);
            var theta:Number = Math.acos(cos);
            var sin:Number = Math.sin(theta);
            for (var n:uint = 1; n < max; n++) {
                var theta1:Number = theta*n/max;
                var theta2:Number = theta*(max - n)/max;
                var st1:Number = Math.sin(theta1);
                var st2:Number = Math.sin(theta2);
                vertices.push(new Vector3D((a.x*st2 + b.x*st1)/sin, (a.y*st2 + b.y*st1)/sin, (a.z*st2 + b.z*st1)/sin));
                uvs.length += 2;
            }
        }
        private function findVertices(segments:uint, section:uint, row:uint, col:uint):uint {
            if (row == 0) {
                if (section < 5) {
                    return (0);
                }
                if (section > 14) {
                    return (11);
                }
                return (section - 4);
            }
            if (row == segments && col == 0) {
                if (section < 5) {
                    return (section + 1);
                }
                if (section < 10) {
                    return ((section + 4)%5 + 6);
                }
                if (section < 15) {
                    return ((section + 1)%5 + 1);
                }
                return ((section + 1)%5 + 6);
            }
            if (row == segments && col == segments) {
                if (section < 5) {
                    return ((section + 1)%5 + 1);
                }
                if (section < 10) {
                    return (section + 1);
                }
                if (section < 15) {
                    return (section - 9);
                }
                return (section - 9);
            }
            if (row == segments) {
                if (section < 5) {
                    return (12 + (5 + section)*(segments - 1) + col - 1);
                }
                if (section < 10) {
                    return (12 + (20 + (section + 4)%5)*(segments - 1) + col - 1);
                }
                if (section < 15) {
                    return (12 + (section - 5)*(segments - 1) + segments - 1 - col);
                }
                return (12 + (5 + section)*(segments - 1) + segments - 1 - col);
            }
            if (col == 0) {
                if (section < 5) {
                    return (12 + section*(segments - 1) + row - 1);
                }
                if (section < 10) {
                    return (12 + (section%5 + 15)*(segments - 1) + row - 1);
                }
                if (section < 15) {
                    return (12 + ((section + 1)%5 + 15)*(segments - 1) + segments - 1 - row);
                }
                return (12 + ((section + 1)%5 + 25)*(segments - 1) + row - 1);
            }
            if (col == row) {
                if (section < 5) {
                    return (12 + (section + 1)%5*(segments - 1) + row - 1);
                }
                if (section < 10) {
                    return (12 + (section%5 + 10)*(segments - 1) + row - 1);
                }
                if (section < 15) {
                    return (12 + (section%5 + 10)*(segments - 1) + segments - row - 1);
                }
                return (12 + (section%5 + 25)*(segments - 1) + row - 1);
            }
            return (12 + 30*(segments - 1) + section*(segments - 1)*(segments - 2)/2 + (row - 1)*(row - 2)/2 + col - 1);
        }

    }

}