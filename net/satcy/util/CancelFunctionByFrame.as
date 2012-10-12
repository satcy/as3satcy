package net.satcy.util{
	public class CancelFunctionByFrame{
		private var isCancel:Boolean = false;
		private var frame:Number = 0;
		public function CancelFunctionByFrame(_frame:Number = 0){
			frame = _frame;
		}
		public function set exec(_fn:Function):void{
			if ( !isCancel ) {
				isCancel = true;
				new DelayFunctionByFrame(frame, this, function(){isCancel = false;});
				_fn();
			}
		}
		
		private var recent_func:Function;
		public function set execRecent(_fn:Function):void{
			recent_func = _fn;
			if ( !isCancel ) {
				isCancel = true;
				new DelayFunctionByFrame(frame, this, function(){
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