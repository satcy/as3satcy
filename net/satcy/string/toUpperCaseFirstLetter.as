package net.satcy.string{
	public function toUpperCaseFirstLetter( str:String ):String {
		str = str.toLowerCase();
		var f:String = str.charAt(0).toUpperCase();
		if ( str.length > 1 ) return f + str.substr(1);
		else return f;
	}
}