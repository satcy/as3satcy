package net.satcy.event
{
	import flash.events.Event;

	public class MyEvent extends Event
	{
		public static const MENU_SELECT:String = "menu_select";
		public static const ITEM_SELECT:String = "item_select";
		public static const VALUE_CHANGE:String = "value_change";
		public static const COMPLETE:String = "my_event_complete";
		public var vals:Array;
		public function MyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, _vals:Array = null)
		{
			super(type, bubbles, cancelable);
			vals = _vals;
		}
		
		
		
	}
}