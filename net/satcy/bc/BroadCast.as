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
package net.satcy.bc{
	import net.satcy.util.ArrayUtil;
	public class BroadCast{
		private static var objs:Array = [];
		
		public static function cast(_func:String, _val:*):int{
			var l:int = objs.length;
			if( l == 0 ) return 0;
			
			var i:int;
			var cnt:int = 0;
			for ( i=0; i<l; i++ ){
				if( objs[i].hasOwnProperty(_func) ){
					cnt++;
					objs[i][_func](_val);
				}
			}
			return cnt;
		}
		
		public static function setClient(o:*):void{
			objs.push( o );
		}
		
		public static function deleteClient(o:*):void{
			objs = ArrayUtil.deleteItems( objs, o );
		}
		
		public static function print():void{
			trace(objs);
		}
	}
}