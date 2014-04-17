package net.satcy.away3d.filters
{
	import away3d.arcane;
	import away3d.filters.Filter3DBase;
	
	use namespace arcane;
	public class ContrastFilter3D extends Filter3DBase
	{
		private var _contrastTask:Filter3DContrastTask;
		
		public function ContrastFilter3D(contrast:Number = 1, brightness:Number = 1)
		{
			super();
			_contrastTask = new Filter3DContrastTask();
			
			addTask(_contrastTask);
			
			this.contrast = contrast;
			this.brightness = brightness;
		}
		
		public function set brightness(val:Number):void{
			_contrastTask.adjustBrightness(val);
		}
		
		public function set contrast(val:Number):void{
			_contrastTask.adjustContrast(val);
		}
		
		public function set hue(val:Number):void{
			_contrastTask.adjustHue(val);
		}
		//-1, 1
		public function set saturation(val:Number):void{
			_contrastTask.adjustSaturation(val);
		}

	}
}