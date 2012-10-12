package net.satcy.five3D{
	import five3D.display.Bitmap3D;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import net.satcy.display.DisplayObjectUtils;
	import net.satcy.util.EnterFrame;
	public class MovieClip3D extends Bitmap3D{
		private var _mc:DisplayObject;
		private var mtrx:Matrix = new Matrix();
		public var isActive:Boolean = false;
		public function MovieClip3D(__mc:DisplayObject = null, _matrix:Matrix = null){
			if ( __mc != null ) mc = __mc;
			if ( _matrix == null ){
				mtrx = new Matrix();
			}else{
				mtrx = _matrix;
			}
		}
		
		public function destroy():void{
			mc = null;
			clear();
			mtrx = null;
		}
		
		public function set mc(__mc:DisplayObject):void{
			_mc = __mc;
			
		}
		
		public function get mc():DisplayObject{
			return _mc;
		}
		
		public function clear():void {
			super.bitmapData = null;
		}
		
		public function play():void {
			if ( _mc == null ) return;
			if ( mc is MovieClip ) mc["play"]();
			EnterFrame.add(this, enterFrameHandler);
			isActive = true;
		}
		
		public function drawOnce():void{
			var bitmapdata:BitmapData = new BitmapData(_mc.width, _mc.height, true, 0x00FFFFFF);
			bitmapdata.draw(_mc, mtrx);
			super.bitmapData = bitmapdata;			
		}

		private function enterFrameHandler(event:Event):void {
			if ( _mc == null ) return;
			drawOnce();
		}

		public function stop():void {
			if ( mc is MovieClip ) mc["stop"]();
			EnterFrame.remove(this);
			isActive = false;
		}
		
		// Errors

		override public function get bitmapData():BitmapData {
			throw new Error("The Video3D class does not implement this property or method.");
		}

		override public function set bitmapData(value:BitmapData):void {
			throw new Error("The Video3D class does not implement this property or method.");
		}
	}
}