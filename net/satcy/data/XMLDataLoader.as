package net.satcy.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLDataLoader extends EventDispatcher
	{
		public var onComplete:Function;
		public var onError:Function;
		public function XMLDataLoader()
		{
			
		}
		
		public function load(_path:String):void{
			var path:String = _path;
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, onCompleteHandler);
			ld.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			try{
				ld.load(new URLRequest(path));
				
			}catch(e:*){
			}
			
		}
		
		public function destroy():void{
			onComplete = null;
			onError = null;
		}
		
		private function onCompleteHandler(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE, onCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			//if ( onComplete != null ) onComplete(new XML(URLLoader(e.target).data));
			
			try{	
				if ( onComplete != null ) onComplete(new XML(URLLoader(e.target).data));
			} catch(e:*) {
				if ( onError != null ) onError();// ivaid data
			}
			destroy();
		}
		private function onErrorHandler(e:IOErrorEvent):void{
			e.target.removeEventListener(Event.COMPLETE, onCompleteHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			
			if ( onError != null ) onError();
			
			destroy();
		}
	}
}