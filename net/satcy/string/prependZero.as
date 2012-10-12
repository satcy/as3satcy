package net.satcy.string
{
	public function prependZero(__str:String, __num:uint):String{
		var len:uint = __str.length;
		var str:String = __str;
		while(len < __num){
			str = "0"+str;
			len = str.length;
		}
		return str;
	}
}