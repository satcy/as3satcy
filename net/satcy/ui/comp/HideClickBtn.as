package net.satcy.ui.comp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class HideClickBtn extends SelectBtn
	{
		protected var bm2:Bitmap;
		public function HideClickBtn(_id:int, _bmp:BitmapData, _bmp2:BitmapData)
		{
			super(_id, _bmp);
			bm2 = new Bitmap(_bmp2);
			//this.addChild(bm2);
		}
		
		public function set bitmapData2(_bmp:BitmapData):void{
			bm2.bitmapData = _bmp;
		}
		
		override public function setSelect(_b:Boolean):void{
			_select = _b;
			if ( _b ) {
				this.addEvent();
				if ( bm.parent ) bm.parent.removeChild(bm);
				this.addChild(bm2);
			} else {
				if ( bm2.parent ) bm2.parent.removeChild(bm2);
				this.addChild(bm);
				this.removeEvent();
			}
		} 
		
		override public function destroy():void{
			super.destroy();
			if ( bm2 && bm2.bitmapData ) bm2.bitmapData.dispose();
			bm2 = null;
		}
	}
}