package net.satcy.data{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class LoadDataSerial extends EventDispatcher{
		
		private var arr:Array;
		private var path_arr:Array;
		private var _complete:Function;
		
		private var _stream_max:int = 0;
		
		public function LoadDataSerial(){}	
		
		public function addURLLoader(_path:String, _comp:Function, _error:Function = null):LoadDataSerial{
			if ( !arr ) arr = [];
			if ( !path_arr ) path_arr = [];
			getURLLoader(_path, _comp, _error);
			if ( arr.length == 1 ) arr[0].load(new URLRequest(path_arr[0]));
			return this;
		}
		
		public function addLoader(_path:String, _comp:Function, _error:Function = null):LoadDataSerial{
			if ( !arr ) arr = [];
			if ( !path_arr ) path_arr = [];
			getLoader(_path, _comp, _error);
			if ( arr.length == 1 ) arr[0].load(new URLRequest(path_arr[0]));
			return this;
		}
		
		public function addLoaders(_arr:Array, _comp:Function, _error:Function = null):LoadDataSerial{
			for each ( var _str:String in _arr ) addLoader(_str, _comp, _error);
			return this;
		}
		
		public function setComplete(_fn:Function):LoadDataSerial{
			_complete = _fn;
			return this;
		}
		
		private function next():void{
			arr.splice(0, 1);
			path_arr.splice(0, 1);
			if ( arr.length > 0 ) arr[0].load(new URLRequest(path_arr[0]));
			if ( arr.length == 0 ) {
				arr = null;
				path_arr = null;
				_stream_max = 0;
				if ( _complete != null ) _complete();
				_complete = null;
			}
		}
		
		private function getURLLoader(_path:String, _comp:Function, _error:Function = null):URLLoader{
			path_arr.push(_path);
			resetMax();
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, $comp);
			ld.addEventListener(IOErrorEvent.IO_ERROR, $error);
			ld.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			
			arr.push(ld);
			
			function $comp(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, $comp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, $error);
				ld.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if ( _comp != null ) _comp(ld);
				next();
			}
			function $error(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, $comp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, $error);
				ld.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if ( _error != null ) _error(ld);
				next();
			}
			return ld;
		}
		
		private function getLoader(_path:String, _comp:Function, _error:Function = null):Loader{
			path_arr.push(_path);
			resetMax();
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, $comp);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, $error);
			ld.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			arr.push(ld);
			
			function $comp(e:Event):void{
				ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, $comp);
				ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, $error);
				ld.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if ( !LoadSwfManager.getInstance().loadedCheck(_path) ) LoadSwfManager.getInstance().loadedStore(_path, ld);
				if ( _comp != null ) _comp(ld);
				next();
			}
			function $error(e:Event):void{
				ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, $comp);
				ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, $error);
				ld.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				if ( _error != null ) _error(ld);
				next();
			}
			return ld;
		}
		
		private function resetMax():void{
			if ( _stream_max < path_arr.length ) _stream_max = path_arr.length;
		}
		
		private function onProgressHandler(e:ProgressEvent):void{
			var _ratio:Number = e.bytesLoaded/e.bytesTotal;
			trace(_ratio, arr.length, _stream_max);
			//this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 
		}
	}	
}