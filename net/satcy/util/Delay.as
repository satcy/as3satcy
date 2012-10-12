/*
The MIT License

Copyright (c) 2007- Satoshi HORII/rhisomztiks co.,ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package net.satcy.util{
	import flash.utils.Dictionary;
	/**
	* @author satoshi horii
	*/
	public class Delay{
		
		private static var dict:Dictionary = new Dictionary(true);
		private static var fn_dict:Dictionary = new Dictionary(true);
		private static var obj_dict:Dictionary = new Dictionary(true);
		private static var arg_dict:Dictionary = new Dictionary(true);
		
		public static function wait(num:Number, _obj:Object, _fn:Function, ...args):void{
			if(dict[_fn] != undefined) remove(_fn);
			
			fn_dict[_fn] = _fn;
			var arg_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len>0){
				for(var i:int = 0;i<arg_len;i++){
					arg_arr.push(args[i]);
				}
				arg_dict[_fn] = arg_arr;
			}else{
				arg_dict[_fn] = null;
			}
			obj_dict[_fn] = _obj;
			
			dict[_fn] = new DelayFunction(num, Delay, Delay.bomb, _fn);
		}
		
		public static function waitFrame(num:Number, _obj:Object, _fn:Function, ...args):void{
			if(dict[_fn] != undefined) remove(_fn);
			
			fn_dict[_fn] = _fn;
			var arg_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len>0){
				for(var i:int = 0;i<arg_len;i++){
					arg_arr.push(args[i]);
				}
				arg_dict[_fn] = arg_arr;
			}else{
				arg_dict[_fn] = null;
			}
			obj_dict[_fn] = _obj;
			
			dict[_fn] = new DelayFunctionByFrame(num, Delay, Delay.bomb, _fn);
		}
		
		public static function pause(_fn:Function):void{
			if(dict[_fn] != undefined) {
				IDelayFunction(dict[_fn]).pause();
			}
		}
		public static function resume(_fn:Function):void{
			if(dict[_fn] != undefined) {
				IDelayFunction(dict[_fn]).resume();
			}	
		}
		public static function remove(_fn:Function):void{
			if(dict[_fn] != undefined) {
				IDelayFunction(dict[_fn]).stop();
				delete obj_dict[_fn];
				delete fn_dict[_fn];
				delete arg_dict[_fn];
				delete dict[_fn];
			}	
		}
		public static function removeByObj(_obj:Object):void{
			var _fn_arr:Array = DictionaryUtil.getKeys( obj_dict );
			var _obj_arr:Array = DictionaryUtil.getValues( obj_dict );
			var i:int, l:int = _obj_arr.length;
			for( i = 0; i<l; i++ ){
				if( _obj_arr[i] == _obj ){
					remove( _fn_arr[i] );
				}
			}
		}
		public static function removes():void{
			/*
			全部削除
			*/
			for(var i in dict){
				IDelayFunction(dict[i]).stop();
			}
			dict = new Dictionary(true);
			obj_dict = new Dictionary(true);
			fn_dict = new Dictionary(true);
			arg_dict = new Dictionary(true);
		}
		private static function bomb(_fn:Function):void{
			if( dict[_fn] == undefined || obj_dict[_fn] == undefined || fn_dict[_fn] == undefined ) return;
			//fn_dict[_fn].apply(obj_dict[_fn], arg_dict[_fn]);
			var fn:Function = fn_dict[_fn];
			var obj:Object = obj_dict[_fn];
			var args:Array = arg_dict[_fn];
			delete obj_dict[_fn];
			delete arg_dict[_fn];
			delete fn_dict[_fn];
			delete dict[_fn];
			fn.apply(obj, args);
		} 
		
		
	}
}