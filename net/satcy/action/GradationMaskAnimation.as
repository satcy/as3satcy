package net.satcy.action{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	
	
	public class GradationMaskAnimation{
		
		public function GradationMaskAnimation(_parent:Sprite, target:Sprite){
			//ColorShortcuts.init();
			//target.visible = false;
			var w:Number = target.width;
			var h:Number = target.height;
			
			var mat_0:Matrix = new Matrix();
			mat_0.scale(target.scaleX, target.scaleY);
			
			var bmp:BitmapData = new BitmapData(w, h, true, 0x00000000);
			bmp.draw(target, mat_0);
			//var bm:Bitmap = new Bitmap( bmp );
			
			//_parent.addChild( bm );
			
			var bmp_2:BitmapData = new BitmapData(w, h, true, 0x00000000);
			//bmp_2.draw(target);
			
			
			var sp:Sprite = new Sprite();
			var mat:Matrix = new Matrix();
			//mat.createGradientBox(h, h, 0, -Math.random()*w, -Math.random()*h);
			mat.createGradientBox(w, h, Math.random()*Math.PI*2, 0, 0);
			sp.graphics.beginGradientFill("linear", [0xffffff,0x000000], [1,1], [0,255], mat, "pad", "rgb", 0 );
			sp.graphics.drawRect(0,0,w, h);
			var sp_bmp:BitmapData = new BitmapData(w, h, true, 0x00000000);
			sp_bmp.draw( sp );
			bmp_2.copyPixels(sp_bmp, new Rectangle(0,0,w,h), new Point(), bmp, new Point(), true);
			sp_bmp.dispose();
			
			var bm_2:Bitmap = new Bitmap( bmp_2 );
			bm_2.blendMode = "add";
			
			_parent.addChild( bm_2 );
			
			update();
			
			Tweener.addTween(bm_2,{_color_redOffset:-255, _color_greenOffset:-255, _color_blueOffset:-255});
			Tweener.addTween(bm_2,{_color_redOffset:255, _color_greenOffset:255, _color_blueOffset:255, _color_alphaMultiplier:0, time:0.5, delay:0., transition:"easeinoutsine", onComplete:complete});
			//target.alpha = 0;
			//Tweener.addTween(target, {alpha:1, time:1, transition:"easeinoutsine"});
			
			var interval:uint = setInterval(update, 1);
			function update():void{
				//bm.x = target.x;
				//bm.y = target.y;
				bm_2.x = target.x;
				bm_2.y = target.y;
			}
			
			function complete():void{
				clearInterval(interval);
				//_parent.removeChild( bm );
				_parent.removeChild( bm_2 );
				bm_2 = null;
				bmp.dispose();
				bmp = null;
				bmp_2.dispose();
				bmp_2 = null;
				//target.visible = true;
			}
		}
	}
}