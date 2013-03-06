package net.satcy.data
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import net.satcy.util.EnterFrame;
	
	public class PreLoader
	{
		public static const SWF:int = 0;
		public static const IMG:int = 1;
		public static const MP3:int = 2;
		public static const BIN:int = 3;
		
		public var onComplete:Function;
		public var onProgress:Function;
		public var onError:Function;
		
		private var cnt:int = 0;
		
		private var loaders:Array;
		
		public function PreLoader(){
			loaders = [];
			EnterFrame.add(this, onEnterFrameHandler);
		}
		
		public function push(_path:String, _type:int = 0):void{
			if ( _type == SWF || _type == IMG ) {
				var ld:Loader = new Loader();
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteSwfHandler);
				ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				var loader_context:LoaderContext;
				if ( _type == SWF ){
					loader_context = new LoaderContext(false, ApplicationDomain.currentDomain);
				}else{
					loader_context = new LoaderContext(true);
				}
				try{
					ld.load(new URLRequest(_path), loader_context);
					cnt++;
					loaders.push(ld);
				} catch(e:*){
				
				}
				
				
			}
		}
		
		private function end():void{
			if ( onComplete != null ) onComplete();
			onComplete = null;
			onProgress = null;
			onError = null;
			EnterFrame.remove(this);
			loaders = null;
		}
		
		private function onCompleteSwfHandler(e:Event):void{
			var lf:LoaderInfo = (e.target as LoaderInfo);
			lf.removeEventListener(Event.COMPLETE, onCompleteSwfHandler);
			lf.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			var lsm:LoadSwfManager = LoadSwfManager.getInstance();
			lsm.loadedStore(lf.url, lf.loader);
			cnt--;
			loaders.splice(loaders.indexOf(lf.loader), 1);
			if ( cnt == 0 ) end();
		}
		
		private function onErrorHandler(e:ErrorEvent):void{
			var lf:LoaderInfo = (e.target as LoaderInfo);
			lf.removeEventListener(Event.COMPLETE, onCompleteSwfHandler);
			lf.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			if ( onError != null ) onError(e);
			cnt--;
			loaders.splice(loaders.indexOf(lf.loader), 1);
			if ( cnt == 0 ) end();
		}
		
		private function onEnterFrameHandler(e:Event):void{
			var l:int = loaders.length;
			var _all:Number = 0;
			var _now:Number = 0;
			for ( var i:int = 0; i<l; i++ ) {
				if ( loaders[i] is Loader ){
					_all += (loaders[i] as Loader).contentLoaderInfo.bytesTotal;
					_now += (loaders[i] as Loader).contentLoaderInfo.bytesLoaded;
				}
			}
			if ( _all == 0 ) _all = 1;
			if ( onProgress != null ) onProgress((_now/_all)*100);
		}
	}
}