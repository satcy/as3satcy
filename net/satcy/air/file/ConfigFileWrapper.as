package net.satcy.air.file
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.*;
	import flash.net.*;
	
	public class ConfigFileWrapper implements IFileWriter
	{
		private var file:File;
		private var _result:String;
		public function get result():String{ return _result; }
		public function ConfigFileWrapper(path:String, whichDir:int=0, def:String = "", fn:Function = null)
		{
			if ( whichDir == 0 ) file = File.applicationStorageDirectory.resolvePath(path);
			else file = File.desktopDirectory.resolvePath(path);
			
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, _onCompleteHandler);
			ld.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			ld.load(new URLRequest(file.url));
			
			function _onCompleteHandler(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onCompleteHandler);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				_result = ld.data as String;
				if ( fn != null ) fn();
				ld = null;
			}
			
			function _onError(e:IOErrorEvent):void{
				ld.removeEventListener(Event.COMPLETE, _onCompleteHandler);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				ld = null;
				if ( def ) { 
					_result = def;
					var stream:FileStream = new FileStream();
					var s:String = def;
				　　	stream.open(file, FileMode.WRITE);
				　　	stream.writeUTFBytes(s);
				　　	stream.close();
				}
				if ( fn != null ) fn();
			}
		}
		
		public function write(s:String):void{
			if ( !file) return;
			var stream:FileStream = new FileStream();
		　　	stream.open(file, FileMode.WRITE);
		　　	stream.writeUTFBytes(s);
		　　	stream.close();
		}

	}
}