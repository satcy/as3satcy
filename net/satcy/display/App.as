package net.satcy.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.satcy.core.Status;
	import net.satcy.util.LayOutUtil;

	public class App extends Sprite
	{
		public function App()
		{
			super();
			if ( stage ) {
				this.onAdd(null);
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			}
		}
		
		protected function onAdd(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			if ( !LayOutUtil.stage ) {
				LayOutUtil.init(stage);
				LayOutUtil.LtNoScale();
				LayOutUtil.setResize();
				LayOutUtil.dump();
				Status.setFullPathFromLoaderInfo(this.loaderInfo);
			}
		}
		
	}
}