package net.satcy.string{
	public function addSemiColonToNumber( _num:int ):String {
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
}