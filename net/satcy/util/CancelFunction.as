package net.satcy.util{
	public class CancelFunction{
		private var isCancel:Boolean = false;
		private var duration:Number = 0;
		public function CancelFunction(_dur:Number = 0){
			duration = _dur;
		}
		public function set exec(_fn:Function):void{
			if ( !isCancel ) {
				isCancel = true;
				new DelayFunction(duration, this, function(){isCancel = false;});
				_fn();
			}
		}
		
		private var recent_func:Function;
		public function set execRecent(_fn:Function):void{
			recent_func = _fn;
			if ( !isCancel ) {
				isCancel = true;
				new DelayFunction(duration, this, function(){
					isCancel = false;
					if ( recent_func != null ) recent_func();
				});
			}
		}
		
		public function destroy():void{
			recent_func = null;
		}
	}
}