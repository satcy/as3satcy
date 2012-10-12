package net.satcy.data {
	import flash.media.Sound;
	import flash.utils.*;
	
	import net.satcy.util.ArrayUtil;
	public class LoadSoundManager {
		public static var loaded_arr:Array = new Array();
		public static var dict:Dictionary = new Dictionary(true);
		private static var loading_dict:Dictionary = new Dictionary(true);
		private static var not_found_files:Array = [];
		public static function loadedCheck(str:String):Boolean{
			var num:uint = loaded_arr.length;
			var bool:Boolean = false;
			for(var i:int = 0; i<num;i++){
				if(loaded_arr[i] == str){
					bool = true;
					break;
				}
			}
			return bool;
		}
		
		public static function startLoad(str:String, __sound:Sound):void{
			loading_dict[str] = __sound;
		}
		
		public static function loadedStore(str:String, __sound:Sound):void{
			//   sound/***.mp3
			loaded_arr.push(str);
			dict[str] = __sound;
			delete loading_dict[str];
		}
		
		public static function storeNotFoundFilePath(_path:String):void{
			if ( not_found_files.indexOf(_path) != -1 ) return;
			not_found_files.push(_path);
		}
		public static function getNotFoundLength():uint{
			return not_found_files.length;
		}
		
		public static function isNotFound(_path):Boolean{
			if ( not_found_files.indexOf(_path) != -1 ){
				return false;
			}else{
				return true;
			}
		}
		
		public static function getLoadedObject(str:String):Sound{
			//trace("Sound :: キャッシュより読み出し");
			return dict[str];
		}
		
		
		public static function deleteSound(str:String):void{
			var sound:Sound;
			if ( dict[str] ) {
				sound = dict[ str ];
				if ( sound.isBuffering ) sound.close();
				delete dict[ str ];
				loaded_arr = ArrayUtil.deleteItems(loaded_arr, str);
			}else if ( loading_dict[str] ){
				sound = loading_dict[ str ];
				if ( sound.isBuffering ) sound.close();
				delete loading_dict[ str ];
			}
		}
		
		public static function destroy():void{
			var l:int = loaded_arr.length;
			for ( var i:int = 0; i<l; i++ ){
				var sound:Sound = dict[ loaded_arr[i] ];
				if ( sound.isBuffering ) sound.close();
				delete dict[ loaded_arr[i] ];
			}
			loaded_arr = [];
			dict = new Dictionary(true);
		}
	}
	
}
