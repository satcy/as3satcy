﻿package net.satcy.datb{	import flash.errors.IllegalOperationError;	import flash.display.*;	import flash.media.Sound;	import flash.utils.*;	public class AssetPocket {		public static var loaded_arr:Array = new Array();		public static var dict:Dictionary = new Dictionary();				/**		 * constructor		 */		public function AssetPocket() {			throw new IllegalOperationError("cannot create instance.");		}				public static function loadedCheck(str:String):Boolean{			var num:uint = loaded_arr.length;			var bool:Boolean = false;			for(var i:int = 0; i<num;i++){				if(loaded_arr[i] == str){					bool = true;					break;				}			}			return bool;		}				public static function loadedStore(str:String, __obj:*):void{			//   sound/***.mp3			loaded_arr.push(str);			dict[str] = __obj;		}				public static function getLoadedObject(str:String):*{			//trace("Sound :: キャッシュより読み出し");			if(dict[str] == null){				return null; 			}else{				return dict[str];			}		}	}}