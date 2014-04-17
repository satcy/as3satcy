package net.satcy.util
{
	import flash.geom.Point;
	
	public class PointUtil
	{
		public static function interporate(p1:Point, p2:Point, ratio:Number):Point{
			return new Point((p2.x - p1.x)*ratio + p1.x, (p2.y - p1.y)*ratio + p1.y);
		}
		
		public static function centerPoint(...pts):Point{
			var pt:Point = new Point();
			var cnt:Number = 0;
			for ( var i:int = 0; i<pts.length; i++ ) {
				if ( pts[i] is Point ) {
					pt.x += pts[i].x;
					pt.y += pts[i].y;
					cnt ++;
				}
			}
			pt.x /= cnt;
			pt.y /= cnt;
			return pt;
		}
		
		public static function crossProduct(v1:Point, v2:Point):Number{
    		return (v1.x*v2.y) - (v1.y*v2.x);
		}
		
		public static function sub(a:Point, b:Point):Point{
			return new Point(a.x - b.x, a.y - b.y);
		}
		
		public static function containTriangle(p:Point, a:Point, b:Point, c:Point):Boolean{
			//線上は外とみなします。
    		//ABCが三角形かどうかのチェックは省略
		    
		    var AB:Point = new Point(b.x - a.x, b.y - a.y);
		    var BP:Point = new Point(p.x - b.x, p.y - b.y);
		
		    var BC:Point = new Point(c.x - b.x, c.y - b.y);
		    var CP:Point = new Point(p.x - c.x, p.y - c.y);
		
		    var CA:Point = new Point(a.x - c.x, a.y - c.y);
		    var AP:Point = new Point(p.x - a.x, p.y - a.y);
		
		    var c1:Number = AB.x * BP.y - AB.y * BP.x;
		    var c2:Number = BC.x * CP.y - BC.y * CP.x;
		    var c3:Number = CA.x * AP.y - CA.y * AP.x;
		
		    if( ( c1 > 0 && c2 > 0 && c3 > 0 ) || ( c1 < 0 && c2 < 0 && c3 < 0 ) ) {
		        return true;//contain
		    }
		
		    return false;//outside

		}
		
		public static function contactTriangles(a:Point, b:Point, c:Point, x:Point, y:Point, z:Point):Boolean{
			// 辺ABとチェック
			if(crossLine(a, b, x, y)) return true;
			if(crossLine(a, b, x, z)) return true;
			if(crossLine(a, b, y, z)) return true;
	 
			// 辺ACとチェック
			if(crossLine(a, c, x, y)) return true;
			if(crossLine(a, c, x, z)) return true;
			if(crossLine(a, c, y, z)) return true;
	 
			// 辺BCとチェック
			if(crossLine(b, c, x, y)) return true;
			if(crossLine(b, c, x, z)) return true;
			if(crossLine(b, c, y, z)) return true;
	 
			return false;
		}
		
		//時計周りならマイナス
		public static function signedTriangle(a:Point, b:Point, c:Point):Number{
			return (a.x - c.x) * (b.y - c.y) - (a.y - c.y) * (b.x - c.x);
		}
		
		public static function angle(a:Point, b:Point, c:Point, d:Point):Number{
			var AB:Point = sub(b, a);
			var CD:Point = sub(d, c);
			var dotProduct:Number = AB.x * CD.x + AB.y * CD.y;
			var magAB:Number = Point.distance(a, b);
      		var magCD:Number = Point.distance(c, d);
			return Math.acos(dotProduct / (magAB * magCD));
		}
		//直線上に点が有るかどうか
		public static function containSegment(p:Point, a:Point, b:Point):Boolean{
			if (a.x != b.x) {    // S is not  vertical
		        if (a.x <= p.x && p.x <= b.x)
		            return true;
		        if (a.x >= p.x && p.x >= b.x)
		            return true;
		    }
		    else {    // S is vertical, so test y  coordinate
		        if (a.y <= p.y && p.y <= b.y)
		            return true;
		        if (a.y >= p.y && p.y >= b.y)
		            return true;
		    }
			return false;
		}
		
		public static function crossLine(a:Point, b:Point, c:Point, d:Point):Boolean{
			
			var a1:Number = signedTriangle(a, b, d);
			var a2:Number = signedTriangle(a, b, c);
 
			if(!(a1 * a2 < 0.0)) return false;
	 
			var a3:Number = signedTriangle(c, d, a);
			var a4:Number = signedTriangle(c, d, b);
	 
			if(a3 * a4 < 0.0){
				return true;
			}
	 
			return false;
		}
		
		public static function crossLinePoint(a:Point, b:Point, c:Point, d:Point):Point{
			var bundo:Number = ( b.x - a.x ) * ( d.y - c.y ) - ( b.y - a.y ) * ( d.x - c.x );
			if ( bundo == 0 ) {// heikou
				return null;
			}
			
			var vectorAC:Point = new Point( c.x - a.x, c.y - a.y );
			var dR:Number = ( ( d.y - c.y ) * vectorAC.x - ( d.x - c.x ) * vectorAC.y ) / bundo;
			var dS:Number = ( ( b.y - a.y ) * vectorAC.x - ( b.x - a.x ) * vectorAC.y ) / bundo;
			
			return new Point( a.x + dR * ( b.x - a.x ), a.y + dR * ( b.y - a.y ));
		}
		
		public static function getIncludeCircleTriangle(center:Point, radius:Number, start_radian:Number):Array{
			
			//this.graphics.beginFill(0xFF0000, 1);
			//this.graphics.drawCircle(center.x, center.y, radius);
			var r1:Number = start_radian;
			var r2:Number = r1 + Math.PI*0.5 + Math.random()*Math.PI*0.3;
			var r3:Number = ((r1 + Math.PI) + ( r2 + Math.PI))/2;
			var p1:Point = new Point(Math.cos(r1)*radius + center.x, Math.sin(r1)*radius + center.y);
			var p2:Point = new Point(Math.cos(r2)*radius + center.x, Math.sin(r2)*radius + center.y);
			var p3:Point = new Point(Math.cos(r3)*radius + center.x, Math.sin(r3)*radius + center.y);
			//this.graphics.beginFill(0x00ff00,1);
			//this.graphics.moveTo(p1.x, p1.y);
			//this.graphics.lineTo(p2.x, p2.y);
			//this.graphics.lineTo(p3.x, p3.y);
			
			var v1_1:Point = new Point( Math.cos(r1 + Math.PI*0.5)*10000 + p1.x, Math.sin(r1 + Math.PI*0.5)*10000 + p1.y );
			var v1_2:Point = new Point( Math.cos(r1 - Math.PI*0.5)*10000 + p1.x, Math.sin(r1 - Math.PI*0.5)*10000 + p1.y );
			
			var v2_1:Point = new Point( Math.cos(r2 + Math.PI*0.5)*10000 + p2.x, Math.sin(r2 + Math.PI*0.5)*10000 + p2.y );
			var v2_2:Point = new Point( Math.cos(r2 - Math.PI*0.5)*10000 + p2.x, Math.sin(r2 - Math.PI*0.5)*10000 + p2.y );
			
			var v3_1:Point = new Point( Math.cos(r3 + Math.PI*0.5)*10000 + p3.x, Math.sin(r3 + Math.PI*0.5)*10000 + p3.y );
			var v3_2:Point = new Point( Math.cos(r3 - Math.PI*0.5)*10000 + p3.x, Math.sin(r3 - Math.PI*0.5)*10000 + p3.y );
			
			//this.graphics.lineStyle(4, 0x00FFFF, 1);
			//this.graphics.moveTo(v1_1.x, v1_1.y);
			//this.graphics.lineTo(v1_2.x, v1_2.y);
			
			//this.graphics.moveTo(v2_1.x, v2_1.y);
			//this.graphics.lineTo(v2_2.x, v2_2.y);
			
			//this.graphics.moveTo(v3_1.x, v3_1.y);
			//this.graphics.lineTo(v3_2.x, v3_2.y);
			
			var c1:Point = PointUtil.crossLinePoint(v1_1, v1_2, v2_1, v2_2);
			var c2:Point = PointUtil.crossLinePoint(v1_1, v1_2, v3_1, v3_2);
			var c3:Point = PointUtil.crossLinePoint(v3_1, v3_2, v2_1, v2_2);
			
			if ( c1 && c2 && c3 ) return [c1, c2, c3];
			else return null;
		}

	}
}