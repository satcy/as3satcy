package net.satcy.ui.comp
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import net.satcy.action.blinkByEnterFrame;
	
	public class ClickHaveOverBtn extends ClickCheckBtn
	{
		public function ClickHaveOverBtn(_id:int, _bmp:BitmapData, _bmp2:BitmapData)
		{
			super(_id, _bmp, _bmp2);
		}
		
		override protected function onOver(e:MouseEvent):void{
			if ( _soundplayer ) _soundplayer.playOver();
			net.satcy.action.blinkByEnterFrame(this, 6);
			setSelect(true);
		}
		override protected function onOut(e:MouseEvent):void{
			setSelect(false);
		}
		
		override protected function onClick(e:MouseEvent):void{
			//setSelect(false);
			super.onClick(e);
		}
	}
}