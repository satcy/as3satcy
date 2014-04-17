package net.satcy.ui.comp
{
	import flash.display.BitmapData;
	import flash.display.Graphics;

	public class SelectBtn extends ClickBtn
	{
		protected var _select:Boolean = false;
		public function SelectBtn(_id:int, _bmp:BitmapData)
		{
			super(_id, _bmp);
		}
		
		
		public function get select():Boolean{
			return _select;
		}
		
		public function set select(b:Boolean):void{
			_select = b;
		}
		
		public function setSelect(_b:Boolean):void{
			_select = _b;
			var g:Graphics = this.graphics;
			g.clear();
			if ( _b ) {
				g.beginFill(0,1);
				g.drawRect(-4,-4,bm.width+8,bm.height+8);
				g.drawRect(0,0,bm.width,bm.height);
				removeEvent();
			} else {
				addEvent();
			}
		}
		
	}
}