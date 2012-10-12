package net.satcy.action
{
	import flash.display.DisplayObject;
	
	
	public function blinkByEnterFrame(_t_mc:DisplayObject, _num:int):void
	{
		new _BlinkByEnterFrame(_t_mc, _num);
	}
}
	import flash.display.DisplayObject;
	import net.satcy.util.EnterFrame;
	import flash.events.Event;
	

class _BlinkByEnterFrame{
	private var t_mc:DisplayObject;
	private var count:int = 0;
	private var max_num:int;
	public function _BlinkByEnterFrame(_t_mc:DisplayObject, _num:int){
		t_mc = _t_mc;
		max_num = _num;
		EnterFrame.add(this, onEnterFrameHandler);
	}
	
	private function onEnterFrameHandler(e:Event):void{
		if ( count%2 == 0 ) t_mc.alpha = 0;
		else t_mc.alpha = 1;
		count++;
		if (count >  max_num-1 ){
			EnterFrame.remove(this);
			t_mc.alpha = 1;
			t_mc = null;
		}
	}
	
}