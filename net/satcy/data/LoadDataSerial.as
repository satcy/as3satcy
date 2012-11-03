package net.satcy.data{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import net.satcy.event.EventHelper;
	
	public class LoadDataSerial extends EventDispatcher{
		
		private var arr:Array;
		private var path_arr:Array;
		private var _complete:Function;
		
		private var _stream_max:int = 0;
		
		private var event:EventHelper;
		
		private var _auto_destroy:Boolean = true;
		
		public function LoadDataSerial(_auto_destroy:Boolean = true){
			this._auto_destroy = _auto_destroy;
			event = new EventHelper();
		}	
		
		public function addURLLoader(_path:String, _comp:Function, _error:Function = null):LoadDataSerial{
			if ( !arr ) arr = [];
			if ( !path_arr ) path_arr = [];
			setURLLoader(_path, _comp, _error);
			if ( arr.length == 1 ) arr[0].load(new URLRequest(path_arr[0]));
			return this;
		}
		
		public function addLoader(_path:String, _comp:Function, _error:Function = null):LoadDataSerial{
			if ( !arr ) arr = [];
			if ( !path_arr ) path_arr = [];
			setLoader(_path, _comp, _error);
			if ( arr.length == 1 ) {
				var ld:* = arr[0];
				var _path:String = path_arr[0];
				var req:URLRequest = new URLRequest(_path);
				if ( ld is Loader ) {
					var loader_context:LoaderContext;
					if ( _path.indexOf(".swf") != -1 ){
						loader_context = new LoaderContext(false, ApplicationDomain.currentDomain);
					}else{
						loader_context = new LoaderContext(true);
					}
					ld.load(req, loader_context );
				} else {
					ld.load(req);
				}
			}
			return this;
		}
		
		public function addLoaders(_arr:Array, _comp:Function, _error:Function = null):LoadDataSerial{
			for each ( var _str:String in _arr ) addLoader(_str, _comp, _error);
			return this;
		}
		
		public function addZip(_path:String, _comp:Function, _error:Function = null):LoadDataSerial{
			if ( !arr ) arr = [];
			if ( !path_arr ) path_arr = [];
			setZip(_path, _comp, _error);
			if ( arr.length == 1 ) arr[0].load(new URLRequest(path_arr[0]));
			return this;
		}
		
		public function setComplete(_fn:Function):LoadDataSerial{
			_complete = _fn;
			return this;
		}
		
		public function destroy():void{
			if ( arr ) {
				for each ( var ld:* in arr ) {
					if ( ld is URLLoader || ld is Loader ) try { ld["close"](); ld["unload"](); } catch(e:*) {}
					else if ( ld is LoadZip ) ld["destroy"]();
					if ( ld is IEventDispatcher ) event.removeEventListenerAll(ld as IEventDispatcher);
				}
				arr = null;
			}
			path_arr = null;
			_complete = null;
			event.destroy();
			event = null;
		}
		
		private function next():void{
			arr.splice(0, 1);
			path_arr.splice(0, 1);
			
			if ( arr.length > 0 ) {
				var ld:* = arr[0];
				var _path:String = path_arr[0];
				var req:URLRequest = new URLRequest(_path);
				if ( ld is Loader ) {
					var loader_context:LoaderContext;
					if ( _path.indexOf(".swf") != -1 ){
						loader_context = new LoaderContext(false, ApplicationDomain.currentDomain);
					}else{
						loader_context = new LoaderContext(true);
					}
					ld.load(req, loader_context );
				} else {
					ld.load(req);
				}
			}
			if ( arr.length == 0 ) {
				arr = null;
				path_arr = null;
				_stream_max = 0;
				if ( _complete != null ) _complete();
				_complete = null;
				if ( _auto_destroy ) destroy();
			}
		}
		
		private function setURLLoader(_path:String, _comp:Function, _error:Function = null):void{
			path_arr.push(_path);
			resetMax();
			var ld:URLLoader = new URLLoader();
			event.addEventListener(ld, Event.COMPLETE, $comp);
			event.addEventListener(ld, IOErrorEvent.IO_ERROR, $error);
			event.addEventListener(ld, ProgressEvent.PROGRESS, onProgressHandler);
			
			arr.push(ld);
			
			function $comp(e:Event):void{
				event.removeEventListenerAll(ld);
				if ( _comp != null ) _comp(ld);
				next();
			}
			function $error(e:Event):void{
				event.removeEventListenerAll(ld);
				if ( _error != null ) _error(ld);
				next();
			}
		}
		
		private function setLoader(_path:String, _comp:Function, _error:Function = null):void{
			path_arr.push(_path);
			resetMax();
			var ld:Loader = new Loader();
			event.addEventListener(ld.contentLoaderInfo, Event.COMPLETE, $comp);
			event.addEventListener(ld.contentLoaderInfo, IOErrorEvent.IO_ERROR, $error);
			event.addEventListener(ld.contentLoaderInfo, ProgressEvent.PROGRESS, onProgressHandler);
			arr.push(ld);
			
			function $comp(e:Event):void{
				event.removeEventListenerAll(ld.contentLoaderInfo);
				if ( !LoadSwfManager.getInstance().loadedCheck(_path) ) LoadSwfManager.getInstance().loadedStore(_path, ld);
				if ( _comp != null ) _comp(ld);
				next();
			}
			function $error(e:Event):void{
				event.removeEventListenerAll(ld.contentLoaderInfo);
				if ( _error != null ) _error(ld);
				next();
			}
		}
		
		private function setZip(_path:String, _comp:Function, _error:Function = null):void{
			path_arr.push(_path);
			resetMax();
			var ld:LoadZip = new LoadZip(null, $comp, _error);
			event.addEventListener(ld, ProgressEvent.PROGRESS, onProgressHandler);
			arr.push(ld);
			
			function $comp():void{
				event.removeEventListenerAll(ld);
				if ( _comp != null ) _comp(ld);
				next();
			}
			function $error(e:Event):void{
				event.removeEventListenerAll(ld);
				if ( _error != null ) _error(ld);
				next();
			}
		}
		
		private function resetMax():void{
			if ( _stream_max < path_arr.length ) _stream_max = path_arr.length;
		}
		
		private function onProgressHandler(e:ProgressEvent):void{
			var _ratio:Number = e.bytesLoaded/e.bytesTotal;
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _ratio + (_stream_max-arr.length), _stream_max));
		}
	}	
}