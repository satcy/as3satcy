package net.satcy.action
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import net.satcy.display.DisplayObjectUtils;

	public class GlowMask extends Sprite
	{
		private var glow_bm:Bitmap;
		public var appear_time:Number = 0.5;
		public var close_time:Number = 1;
		
		public function GlowMask()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function glowBitmapAction(t_sp:DisplayObject):void{
			if ( glow_bm ) {
				if ( glow_bm.parent ) glow_bm.parent.removeChild(glow_bm);
				if ( glow_bm.bitmapData ) glow_bm.bitmapData.dispose();
				glow_bm = null;
			}
			glow_bm = new Bitmap();
			glow_bm.bitmapData = new BitmapData(t_sp.width, t_sp.height, true, 0);
			glow_bm.bitmapData.draw(t_sp);
			var c_index:int = t_sp.parent.getChildIndex(t_sp);
			
			this.x = t_sp.x;
			this.y = t_sp.y;

			
			var t_mask_mc:Sprite = new Sprite();
			t_mask_mc.graphics.beginFill(0,0);
			t_mask_mc.graphics.drawRect(0,0,glow_bm.width, glow_bm.height);
			glow_bm.mask = t_mask_mc;
			t_mask_mc.scaleX = 0;
			TweenMax.to(t_mask_mc, appear_time, {scaleX:1, ease:Expo.easeOut, onComplete:function(){
				if ( t_mask_mc.parent ) t_mask_mc.parent.removeChild(t_mask_mc);
				glow_bm.mask = null;
			}});
			
			this.addChild(glow_bm);
			this.addChild(t_mask_mc);
			this.alpha = 1;
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0, {glowFilter:{color:0x00A7FF, blurX:0, blurY:0, quality:2, alpha:1, strength:2}});
			TweenMax.to(this, appear_time, {glowFilter:{color:0x00A7FF, blurX:8, blurY:8, quality:2, alpha:1, strength:2}, ease:Expo.easeOut});
			
			
			t_sp.parent.addChild(this);
		}
		public function hideGlow():void{
			if ( !glow_bm ) return;
			var this_obj:Sprite = this;
			TweenMax.to(this, close_time, {alpha:0, glowFilter:{color:0x00A7FF, blurX:0, blurY:0, remove:true}, ease:Expo.easeOut, onComplete:function(){
				this_obj.filters = null;
				if ( this_obj.parent ) this_obj.parent.removeChild(this_obj);
				if ( glow_bm ) {
					if ( glow_bm.parent ) glow_bm.parent.removeChild(glow_bm);
					if ( glow_bm.bitmapData ) glow_bm.bitmapData.dispose();
					glow_bm = null;
				}
			}});
		}
		
		public function destroy():void{
			net.satcy.display.DisplayObjectUtils.removeAllChildren(this);
			TweenMax.killTweensOf(this);
			if ( glow_bm ) {
				if ( glow_bm.parent ) glow_bm.parent.removeChild(glow_bm);
				if ( glow_bm.bitmapData ) glow_bm.bitmapData.dispose();
				glow_bm = null;
			}
		}
	}
}