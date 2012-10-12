package net.satcy.util{
	import flash.events.Event;
	
	public class DelayFunctionByFrame implements IDelayFunction{
		private var frame_count:uint;
		private var args_arr:Array;
		private var obj:Object;
		private var fn:Function;
		
		public function DelayFunctionByFrame(frame:uint, _obj:Object, _fn:Function, ...args){
			frame_count = frame;
			obj = _obj;
			fn = _fn;
			args_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len > 0){
				for(var i:int = 0;i<arg_len;i++){
					args_arr.push(args[i]);
				}
			}
			EnterFrame.add( this, onEnterFrameHandler);
		}

		public function stop():void{
			EnterFrame.remove( this );
		}
		
		public function pause():void{
			EnterFrame.pause( this );
		}
		
		public function resume():void{
			EnterFrame.resume( this );
		}
		
		
		private function onEnterFrameHandler(e:Event):void{
			frame_count--;
			if ( frame_count < 1 ){
				EnterFrame.remove( this );
				if( fn == null || obj == null ) return;
				fn.apply(obj, args_arr);
				obj = null;
				args_arr = null;
				fn = null;
			}
		}
	}
}