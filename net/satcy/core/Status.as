package net.satcy.core
{
	import flash.display.LoaderInfo;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	public class Status
	{
		public static var so:SharedObject;
		public static var fullPath:String = "";
		
		public static function initSO(_ident:String):void{
			so = SharedObject.getLocal(_ident);
		}
		
		public static function setFullPathFromLoaderInfo(_loaderInfo:LoaderInfo):void{
			var _path:String = _loaderInfo.loaderURL;
			var _last_index:int = _path.lastIndexOf("/");
			fullPath = _path.substring(0,_last_index+1);
		}
		
		
		public static function getFullPath(_str:String):String{
			return fullPath + _str;
		}
		
		public static function getFullPathWithNumber(_str:String, _num:int):String{
			var s:String = "";
			if ( Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX" ) s = "?rand=" + _num;
			else s = "";
			return fullPath + _str + s;
		}
		
		public static function getFullPathWithRandom(_str:String):String{
			var s:String = "";
			if ( Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX" ) s = "?rand=" + int(Math.random()*100000);
			else s = "";
			return fullPath + _str + s;
		}
		
		public static function appendRandom(_str:String):String{
			var s:String = "";
			if ( Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX" ) s = "?rand=" + int(Math.random()*100000);
			else s = "";
			return _str + s;
		}
		
		public static function avaivableWithRandom():Boolean{
			return ( Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX" );
		}
		
	}
}