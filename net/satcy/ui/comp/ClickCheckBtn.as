package net.satcy.ui.comp
{
	import flash.display.BitmapData;

	public class ClickCheckBtn extends HideClickBtn
	{
		public function ClickCheckBtn(_id:int, _bmp:BitmapData, _bmp2:BitmapData)
		{
			super(_id, _bmp, _bmp2);
		}
		
		override public function setSelect(_b:Boolean):void{
			_select = _b;
			if ( _b ) {
				if ( bm.parent ) bm.parent.removeChild(bm);
				this.addChild(bm2);
			} else {
				if ( bm2.parent ) bm2.parent.removeChild(bm2);
				this.addChild(bm);
			}
		} 
		
	}
}