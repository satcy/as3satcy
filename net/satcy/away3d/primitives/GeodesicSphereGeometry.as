package net.satcy.away3d.primitives{

    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import away3d.primitives.PrimitiveBase;
    import away3d.core.base.CompactSubGeometry;

    public class GeodesicSphereGeometry extends PrimitiveBase {
        // プロパティ
        private var _radius:Number;
        private var _fractures:uint;
        private var vertices:Vector.<Vector3D>;
        private var uvData:Vector.<Number>;
        private static var radian:Number = Math.PI/180;
        private static var sections:uint = 20;
        private static var deg180:Number = Math.PI;
        private static var deg360:Number = Math.PI*2;

        // コンストラクタ
        public function GeodesicSphereGeometry(radius:Number = 50, fractures:uint = 2) {
            super();
            _radius = radius;
            _fractures = fractures;
        }

        // メソッド
        override protected function buildGeometry(target:SubGeometry):void {
            if (_fractures == 0) return;
            //var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(0, false);
            vertices = new Vector.<Vector3D>(0, false);
            var uvs:Vector.<Number> = new Vector.<Number>(0, false);
            var indices:Vector.<uint> = new Vector.<uint>();
            var n:uint, t:uint;
            var theta:Number, cos:Number, sin:Number;
            var subz:Number = 4.472136E-001*_radius;
            var subrad:Number = 2*subz;
            //vertices, uvs 生成
            vertices.push(new Vector3D(0, 0, _radius, - 1));
            uvs.length += 2;
            for (n = 0; n < 5; n++) {
                theta = deg360*n/5;
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
            //vertices, uvs 補間
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
            //indeces 生成
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
                            c.w = 1;
                            indices.push(aIndex, cIndex, bIndex);
                        }
                    }
                }
            }
            //vertices 座標補正
            var matrix:Matrix3D = new Matrix3D();
            matrix.appendRotation(- 90, Vector3D.X_AXIS);
            matrix.appendRotation(180, Vector3D.Y_AXIS);
            for (n = 0; n < vertices.length; n++) {
                var vertex:Vector3D = vertices[n];
                vertices[n] = matrix.transformVector(vertex);
            }
            //vertices, indices 適用
            /*
            target.updateVertexData(createVertices(vertices));
            target.updateVertexNormalData(createVertexNormals(vertices));
            target.updateVertexTangentData(createVertexTangents(vertices));
            */
            //indices 適用
            target.updateIndexData(indices);
            //uvData
            uvData = uvs;
        }
        override protected function buildGeometry(target:SubGeometry):void {
            //uvData 適用
            //target.updateUVData(uvData);
            //vertices, uvData 適用
            target.fromVectors(createVertices(vertices), uvData, createVertexNormals(vertices), createVertexTangents(vertices));
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
        private function createVertices(vectors:Vector.<Vector3D>):Vector.<Number> {
            var vertices:Vector.<Number> = new Vector.<Number>(0, false);
            for (var n:uint = 0; n < vectors.length; n++) {
                var vector:Vector3D = vectors[n];
                vertices.push(vector.x, vector.y, vector.z);
            }
            return vertices;
        }
        private function createVertexNormals(vectors:Vector.<Vector3D>):Vector.<Number> {
            var vertices:Vector.<Number> = new Vector.<Number>(0, false);
            for (var n:uint = 0; n < vectors.length; n++) {
                var vector:Vector3D = vectors[n];
                var length:Number = 1/Math.sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z);
                var x:Number = vector.x*length;
                var y:Number = vector.y*length;
                var z:Number = vector.z*length;
                vertices.push(x, y, z);
            }
            return vertices;
        }
        private function createVertexTangents(vectors:Vector.<Vector3D>):Vector.<Number> {
            var vertices:Vector.<Number> = new Vector.<Number>(0, false);
            for (var n:uint = 0; n < vectors.length; n++) {
                var vector:Vector3D = vectors[n];
                var length:Number = Math.sqrt(vector.y*vector.y + vector.x*vector.x);
                var x:Number = (length > 0.007) ? - vector.y/length : 1;
                var y:Number = (length > 0.007) ? vector.x/length : 0;
                var z:Number = 0;
                vertices.push(x, y, z);
            }
            return vertices;
        }
        public function get radius():Number {
            return _radius;
        }
        public function set radius(value:Number):void {
            _radius = value;
            invalidateGeometry();
        }
        public function get fractures():uint {
            return _fractures;
        }
        public function set fractures(value:uint):void {
            _fractures = value;
            invalidateGeometry();
            invalidateUVs();
        }

    }

}