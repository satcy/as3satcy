package net.satcy.ui{
	import flash.events.Event;

	public class SliderEvent extends Event
	{
		public static const ON_CHANGE:String = "slider_on_change";
		public var ratio:Number = 0;
		public function SliderEvent(type:String, _ratio:Number){
			super(type, false, false);
			ratio = (_ratio<0) ? 0 : _ratio;
		}
		
	}
}