﻿package net.satcy.bitmap{	/*___________________________________________________________Mozaic	___2007.05.09 by Satoshi HORII (satcy.net)	_______	___________	_	@param:MovieClip モザイキング対象のMC。今のところ(0,0)以下は表示しない。	@param:uint    開始Number（大きいほどピクセルがでかい。「１」が等倍） 	@param:uint    終了Number（大きいほどピクセルがでかい。「１」が等倍）	@param:int    インクリメントNumber	@param:Function    モザイキング対象のMCと同じレベルにMCを作ってます。その深度。	___	モザイクのアニメーションは、インターバルで走っている。33ミリ秒間隔。	____	var mozaic = new Mozaic();	mozaic.doMozaic(test_mc, 100, 1, -10, 10);	*/	import flash.display.*;	import flash.events.*;	import flash.geom.*;	import flash.utils.*;		import net.satcy.util.EnterFrame;	public class Mozaic extends Sprite {		private var _src_mc:DisplayObjectContainer;		private var _dst_mc:Bitmap;		public  var _count:Number;		///		private var dstBitMap:BitmapData;		private var midBitMap:BitmapData;		private var interval:uint = 0;		private var onComplete:Function;		public function Mozaic() {		}		public function doMozaic(mc:DisplayObjectContainer, s_num:uint, t_num:uint, k_num:Number, fn:Function):void {			_src_mc = mc;			_dst_mc = new Bitmap(dstBitMap);			addChild(_dst_mc);						this.x = _src_mc.x;			this.y = _src_mc.y;			//_dst_mc.x = _src_mc.x;			//_dst_mc.y = _src_mc.y;			_count = s_num;			_src_mc.visible = false;			clearInterval(interval);			interval = setInterval(counter, 33, t_num, k_num);						onComplete = fn;		}		private function destroy():void{			if ( contains(_dst_mc) ) removeChild(_dst_mc);			if ( this.parent ) this.parent.removeChild(this);			onComplete = null;			_src_mc = null;			_dst_mc = null;			dstBitMap = null;			midBitMap = null;			clearInterval(interval);			//trace("end");		}		private function counter(t_num, k_num):void {			_count += k_num;						//trace((_count)+"::::::LLLLL");			if ( Math.abs(_count-t_num)<=Math.abs(k_num) ) {				_count = t_num;				clearInterval(interval);								dstBitMap.dispose();				midBitMap.dispose();				_src_mc.visible = true;				onComplete();				destroy();			}else{				update(_src_mc, _dst_mc);			}		}		private function update(mc:DisplayObjectContainer, mc2:Bitmap):void {			const myColorTransform:ColorTransform = new ColorTransform();			const blendMode2:String = "normal";			////bitmap///smaller 			var t_w:Number = int(mc.width/_count);			var t_h:Number = int(mc.height/_count);			if ( t_w < 1 ) t_w = 1;			if ( t_h < 1 ) t_h = 1;						midBitMap = new BitmapData(t_w, t_h, true, 0x00000000);			var myMatrix:Matrix = new Matrix();			myMatrix.scale(t_w/mc.width, t_h/mc.height);			var myRectangle:Rectangle = new Rectangle(0, 0,t_w, t_h);			var smooth:Boolean = true;			midBitMap.draw(mc, myMatrix, myColorTransform, blendMode2, myRectangle, smooth);			/////bigger			if ( dstBitMap ) dstBitMap.dispose();			dstBitMap = new BitmapData((mc.width), (mc.height), true, 0x00000000);			myMatrix = new Matrix();			myMatrix.scale(mc.width/t_w, mc.height/t_h);			myRectangle = new Rectangle(0, 0, mc.width, mc.height);			smooth = false;			dstBitMap.draw(midBitMap, myMatrix, myColorTransform, blendMode2, myRectangle, smooth);			/////			//mc2.removeChildAt(0);			//mc2.attachBitmap(dstBitMap, 0, "auto", true);			//mc2.addChild(dstBitMap);			//_src_mc.removeChildAt(dep);			//trace(_src_mc.numChildren+"///__//_/_eeeee");			_dst_mc.bitmapData = dstBitMap;			//trace(_src_mc.numChildren+"///__//_/_");			midBitMap.dispose();		}	}}