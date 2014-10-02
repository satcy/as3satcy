package net.satcy.util{
	public class StringUtil{
		
		public static function prependZero(__str:String, __num:uint):String{
			var len:uint = __str.length;
			var str:String = __str;
			while(len < __num){
				str = "0"+str;
				len = str.length;
			}
			return str;
		}
		
		static public function addSemiColonToNumber( _num:int ):String {
			var _str:String = "" + _num;
			var l:int = _str.length;
			var i:int;
			var a:Array = [];
			var s:String = "";
			for ( i = 0; i<l; i++ ){
				a.push(_str.charAt(i));
			}
			var c:int = 0;
			for ( i = 0; i<l; i++ ){
				s = a[l-1-i] + s;
				c++;
				if ( c > 2 ) {
					c = 0;
					if ( i < l -1 ) s = "," + s;
				}
			}
			return s;
		}
		
		/**
		* 最初の文字を大文字にして、後の文字を小文字にします。
		* @param	str	変換したい文字列
		* @return		変換後の文字列
		*/
		static public function toUpperCaseFirstLetter( str:String ):String {
			var words:Array = str.toLowerCase().split( "" );
			words[0] = words[0].toUpperCase();
			return words.join( "" );
		}
		
		/**
		* 文字列から最適と思われる型に変換して返します。
		* @param	str			変換したい文字列
		* @param	priority	変換の優先順位、true であれば数値化を優先し、false であれば文字列化を優先する。
		* @return				変換後のインスタンス
		*/
		static public function toProperType( str:String, priority:Boolean = true ):* {
			// Number型に変換する
			var _number:Number = parseFloat( str );
			// モードがtrueなら
			if ( priority ) {
				// 数値化を優先する
				if ( !isNaN(_number) ) { return _number; }
			} else {
				// 元データの維持を優先する
				if ( _number.toString() == str ) { return _number; }
			}
			// グローバル定数、プライマリ式キーワードで返す
			switch( str ) {
				case "true" : return true;
				case "false" : return false;
				case "null" : return null;
				case "undefined" : return undefined;
				case "Infinity" : return Infinity;
				case "-Infinity" : return -Infinity;
				case "NaN" : return NaN;
			}
			// そのまま返す
			return str;
		}
		
		static public function trimWhitespace(str:String):String {
			if (str == null) {
				return "";
			}
			return str.replace(/^\s+|\s+$/g, "");
		}
		
	}
}