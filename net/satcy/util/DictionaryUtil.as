
package net.satcy.util{
	import flash.utils.Dictionary;
	
	public class DictionaryUtil
	{
		
		/**
		*	Returns an Array of all keys within the specified dictionary.	
		* 
		* 	@param d The Dictionary instance whose keys will be returned.
		* 
		* 	@return Array of keys contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for (var key:Object in d)
			{
				a.push(key);
			}
			
			return a;
		}
		
		/**
		*	Returns an Array of all values within the specified dictionary.		
		* 
		* 	@param d The Dictionary instance whose values will be returned.
		* 
		* 	@return Array of values contained within the Dictionary
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/					
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for each (var value:Object in d)
			{
				a.push(value);
			}
			
			return a;
		}
		
		
		
		public static function getLength(d:Dictionary):uint{
			var _num:uint;
			for(var value:* in d){
				_num++;
			}
			return _num;
		}
		
		public static function addAsArray(d:Dictionary, _key:*, _val:*):void{
			var a:Array;
			if ( d[_key] == null ){
				d[_key] = [_val];
			}else{
				a = d[_key];
				if( a.indexOf( _val ) == -1 ){
					d[_key] = a.concat( _val );
				}
			}
			
		}
	}
}