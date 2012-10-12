package net.satcy.string{
	public function insertCommaToNumber( _str:String ):String {
		var pattern:RegExp = /(\d)(?=(\d{3})+(?!\d))/g;
		return _str.replace(pattern, "$1,");
	}
}