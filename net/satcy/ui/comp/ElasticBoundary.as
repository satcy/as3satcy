package net.satcy.ui.comp
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import net.satcy.util.EnterFrame;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.easing.Quart;
	import org.libspark.betweenas3.tweens.ITween;

	public class ElasticBoundary extends Sprite
	{
		private var pts:Array;
		private var cnt:int = 0;
		private var bmp:BitmapData;
		private var onComp:Function;
		public function ElasticBoundary(_target:DisplayObject, _fn:Function = null)
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			onComp = _fn;
			if ( _target.width > 0 && _target.height > 0 ) {
				pts = [];
				pts.push(new Point(0,0));
				pts.push(new Point(_target.width,0));
				pts.push(new Point(_target.width,_target.height));
				pts.push(new Point(0,_target.height));
				bmp = new BitmapData(_target.width, _target.height, true, 0);
				bmp.draw(_target);
				
				var pt:Point;
				for ( var i:int = 0; i<pts.length; i++ ) {
					pt = pts[i];
					var _x:Number = pt.x;
					var _y:Number = pt.y;
					pt.x += (Math.random()*2-1)*10;
					pt.y += (Math.random()*2-1)*10;
					var t:ITween = BetweenAS3.to(pt, {x:_x, y:_y}, Math.random()*0.5+0.25, /*Elastic.easeOut*/Expo.easeOut);
					t.onComplete = onTweenFunc;
					t.play();
					cnt++;
				}
				//this.alpha = 0;
				//BetweenAS3.to(this, {alpha:1}, 0.5, Quart.easeOut).play();
				onEnterFrameHandler(null);
				EnterFrame.add(this, onEnterFrameHandler);
			} else {
				if ( onComp != null ) onComp();
				destroy();
			}
		}
		
		
		private function destroy():void{
			pts = null;
			bmp.dispose();
			bmp = null;
			onComp = null;
			if ( this.parent ) this.parent.removeChild(this);
		}
		
		private function onTweenFunc():void{
			cnt--;
			if ( cnt == 0 ) {
				EnterFrame.remove(this);
				if ( this.parent ) this.parent.removeChild(this);
				if ( onComp != null ) onComp();
				destroy();
			}
		}
		
		private function onEnterFrameHandler(e:Event):void{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginBitmapFill(bmp, null, false, false);
			//g.beginFill(0xFF0000, 1);
			var verts:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<int> = new Vector.<int>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			
			verts.push(pts[0].x, pts[0].y);
			verts.push(pts[1].x, pts[1].y);
			verts.push(pts[2].x, pts[2].y);
			verts.push(pts[3].x, pts[3].y);
			indices.push(0);
			indices.push(1);
			indices.push(3);
			
			indices.push(1);
			indices.push(2);
			indices.push(3);
			
			uvs.push(0,0);
			uvs.push(1,0);
			uvs.push(1,1);
			uvs.push(0,1);
			
			g.drawTriangles(verts, indices, uvs);
		}
	}
}