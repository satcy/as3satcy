package net.satcy.display
{
	import flash.events.Event;
	
	public class Content extends App
	{
		public function Content()
		{
			super();
		}
		
		override protected function onAdd(e:Event):void{
			super.onAdd(e);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		protected function onRemove(e:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			this.removeChildren();
		}
		
	}
}