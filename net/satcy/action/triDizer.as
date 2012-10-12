package net.satcy.action
{
	import __AS3__.vec.Vector;
	
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import net.satcy.triangulate.Triangle;
	import net.satcy.triangulate.Triangulate;
	
	public function triDizer(_sp:DisplayObjectContainer, col:uint, _time:Number):void
	{
		var w:Number = _sp.width;
		var h:Number = _sp.height;
		
		var pts:Array = [];
		var pt:Point;
		var i:int;
		var l:int = 70;
		
		pts.push(new Point(0,0));
		pts.push(new Point(w,0));
		pts.push(new Point(w,h));
		pts.push(new Point(0,h));
		
		pts.push(new Point(w*0.5,0));
		pts.push(new Point(w,h*0.5));
		pts.push(new Point(0,h*0.5));
		pts.push(new Point(w*0.5,h));
		
		for ( i=0; i<l; i++ ){
			pt = new Point(Math.random()*w, Math.random()*h);
			pts.push(pt);
		}
		var tris:Array = Triangulate.triangulate(pts);
		l = tris.length;
		var t:Triangle;
		var shp:Shape;
		var g:Graphics;
		var cnt:int = 0;
		var tri_arr:Array = [];
		var verticles:Vector.<Number>;
		for ( i=0; i<l; i++ ){
			cnt++;
			t = tris[i];
			shp = new Shape();
			g = shp.graphics;
			verticles = new Vector.<Number>();
			var mx:Number = (t.p1.x+t.p2.x+t.p3.x)/3;
			var my:Number = (t.p1.y+t.p2.y+t.p3.y)/3;
			g.beginFill(col, 1);
			verticles.push(t.p1.x-mx, t.p1.y-my, t.p2.x-mx, t.p2.y-my, t.p3.x-mx, t.p3.y-my);
			g.drawTriangles(verticles, null, null);
			_sp.addChild(shp);
			tri_arr.push(shp);
			shp.x = mx;
			shp.y = my;
			TweenMax.to(shp, Math.random()*0.1, {alpha:0, delay:Math.random()*_time, onComplete:onEndTween});
		}
		
		function onEndTween():void{
			cnt--;
			if ( cnt == 0 ) {
				var i:int;
				var l:int = tri_arr.length;
				var o:DisplayObject;
				for ( i=0; i<l; i++ ){
					o = tri_arr[i];
					if ( o.parent ) o.parent.removeChild(o);
				}
				tri_arr = null;
			}
		}
	}

}