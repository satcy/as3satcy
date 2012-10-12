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
	//import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	* @author satoshi horii
	*/
	public class Delay_temp{
		
		private static var dict:Dictionary = new Dictionary(true);
		private static var element_dict:Dictionary = new Dictionary(true);
		
		
		public static function wait(num:Number, _obj:Object, _fn:Function, ...args):void{
			if(dict[_fn] != null) {
				remove(_fn);
			}
			
			var arg_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len>0){
				for(var i:int = 0;i<arg_len;i++){
					arg_arr.push(args[i]);
				}
			}else{
				//arg_arr = null;
			}
			
			var elements:FunctionElement = new FunctionElement();
			elements.fn = _fn;
			elements.obj = _obj;
			elements.args = arg_arr;
			elements.time = num;
			element_dict[_fn] = elements;
			
			dict[_fn] = new DelayFunction(num, Delay, Delay.bomb, _fn);
		}
		
		public static function waitByFrame(num:uint, _obj:Object, _fn:Function, ...args):void{
			if(dict[_fn] != null) {
				remove(_fn);
			}
			
			var arg_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len>0){
				for(var i:int = 0;i<arg_len;i++){
					arg_arr.push(args[i]);
				}
			}else{
				//arg_arr = null;
			}
			
			var elements:FunctionElement = new FunctionElement();
			elements.fn = _fn;
			elements.obj = _obj;
			elements.args = arg_arr;
			elements.time = num;
			element_dict[_fn] = elements;
			
			dict[_fn] = new DelayFunctionByFrame(num, Delay, Delay.bomb, _fn);
		}
		
		
		public static function pause(_fn:Function):void{
			if(dict[_fn] != null) {
				IDelayFunction(dict[_fn]).pause();
			}	
		}
		public static function resume(_fn:Function):void{
			if(dict[_fn] != null) {
				IDelayFunction(dict[_fn]).resume();
			}	
		}
		public static function remove(_fn:Function):void{
			if(dict[_fn] == null && element_dict[_fn] == null) return;
			IDelayFunction(dict[_fn]).stop();
			FunctionElement(element_dict[_fn]).destroy();
			delete element_dict[_fn];
		}
		public static function removeByObj(_obj:Object):void{
			var _fn_arr:Array = DictionaryUtil.getKeys( element_dict );
			var _obj_arr:Array = [];
			for ( var e:* in element_dict ){
				_obj_arr.push( FunctionElement(element_dict[i]).obj );
			}
			
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
			for(var i:* in dict){
				remove(i);
			}
			dict = new Dictionary(true);
			element_dict = new Dictionary(true);
		}
		private static function bomb(_fn:Function):void{
			if( dict[_fn] == null || element_dict[_fn] == null ) return;
			var element:FunctionElement = FunctionElement(element_dict[_fn]);
			element.fn.apply(element.obj, element.args);
			delete dict[_fn];
			delete  element_dict[_fn];
		} 
		
		private static function addElement(num:Number, _obj:Object, _fn:Function, ...args):void{
			if(dict[_fn] != null) {
				remove(_fn);
			}
			
			var arg_arr = new Array();
			var arg_len:int = args.length;
			if(arg_len>0){
				for(var i:int = 0;i<arg_len;i++){
					arg_arr.push(args[i]);
				}
			}else{
				arg_arr = null;
			}
			
			var elements:FunctionElement = new FunctionElement();
			elements.fn = _fn;
			elements.obj = _obj;
			elements.args = arg_arr;
			elements.time = num;
			element_dict[_fn] = elements;
		}
		
	}
}

class FunctionElement{
	public var obj:Object;
	public var fn:Function;
	public var args:Array;
	public var time:Number;
	public var frame:uint;
	public function destroy():void{
		obj = null;
		fn = null;
		args = null;
	}
}