package net.satcy.event{
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import net.satcy.util.ArrayUtil;
	
	public class EventHelper{
		
		private var _dict:Dictionary;
		
		public function EventHelper(){
			_dict = new Dictionary(true);
		}
		
		public function destroy():void{
			for ( var i:* in _dict ) removeEventListenerAll(_dict[i]);
			_dict = null;
		}
		
		public function addEventListener(_target:IEventDispatcher, _type:String, _fn:Function):void{
			removeEventListener(_target, _type, _fn);
			if ( !_dict[_target] ) _dict[_target] = [];
			(_dict[_target] as Array).push(_type, _fn);
			_target.addEventListener(_type, _fn);
		}
		
		public function removeEventListener(_target:IEventDispatcher, _type:String, _fn:Function):void{
			if ( _dict[_target] ){
				_dict[_target] = ArrayUtil.deleteItems(_dict[_target] as Array, _type, _fn);
			}
			_target.removeEventListener(_type, _fn);
		}
		
		public function removeEventListenerAll(_target:IEventDispatcher):void{
			if ( _dict[_target] ){
				var _a:Array = _dict[_target] as Array;
				var i:int = 0;
				var l:int = _a.length;
				for ( i=0; i<l; i+=2 ) {
					removeEventListener(_target, _a[i], _a[i+1]);
				}
				delete _dict[_target];
			}
		}
		
	}
}