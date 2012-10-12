package net.satcy.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import net.satcy.util.ArrayUtil;
	
	
	[Event(name="onProgress",type="rzm.LoadImageEvent")]
	[Event(name="onComplete",type="rzm.LoadImageEvent")]
	
	public class LoadBinary extends EventDispatcher
	{
		private static var loaded_arr:Array = new Array();
		private static var obj_arr:Dictionary = new Dictionary(true);
		
		public static function loadedCheck(str:String):Boolean{
			var path:String = str.split("?")[0];
			return loaded_arr.indexOf(path) != -1;
		}
		
		public static function loadedStore(str:String, mc:URLLoader):void{
			var path:String = str.split("?")[0];
			loaded_arr.push(path);
			obj_arr[path] = mc;
		}
		
		public static function getLoadedObject(str:String):URLLoader{
			return obj_arr[str];
		}
		
		public static function deleteObject(str:String):Boolean{
			var bool:Boolean = false;
			if ( obj_arr[str] != null ){
				var ld:URLLoader = obj_arr[str];
				loaded_arr = ArrayUtil.deleteItems(loaded_arr, str);
				if ( obj_arr[ str ] != null ) delete obj_arr[ str ];
				bool = true;
				ld = null;
			}
			return bool;
		}
		
		public static function destroy():void{
			var num:uint = loaded_arr.length;
			for(var i:int = 0; i<num;i++){
				deleteObject(loaded_arr[i]);
			}
			loaded_arr = [];
			obj_arr = new Dictionary(true);
		}
		
		
		
		private var onComplete:Function;
		private var url:String;
		private var loader:URLLoader;
		
		public function LoadBinary()
		{
		}
		
		public function load(_path:String, fn:Function = null):void{
			url = _path;
			onComplete = fn;
			if ( LoadBinary.loadedCheck(_path) ){
				if ( onComplete != null ) onComplete();
				onComplete = null;
			} else {
				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				loader.addEventListener(Event.COMPLETE, onLoaderComplete );
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError );
				loader.load( new URLRequest( _path ) );
			}
		}
		
		private function removeListeners():void{
			if ( !loader ) return;
			loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.removeEventListener(Event.COMPLETE, onLoaderComplete );
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError );
			try{
				loader.close();
			}catch(e:*){}
		}
		
		private function onLoaderComplete(e:Event):void{
			removeListeners();
			LoadBinary.loadedStore(url, loader);
			loader = null;
			if ( onComplete != null ) onComplete();
			onComplete = null;
		}
		
		private function onLoaderError(e:IOErrorEvent):void{
			removeListeners();
			loader = null;
			if ( onComplete != null ) onComplete();
			onComplete = null;
		}
		
		private function onProgressHandler(e:ProgressEvent):void{
			var r:LoadImageEvent = new LoadImageEvent(LoadImageEvent.ON_PROGRESS, true, false);
			r.percent = Math.floor(e.bytesLoaded/e.bytesTotal*100);
			dispatchEvent(r);
		}
	}
}