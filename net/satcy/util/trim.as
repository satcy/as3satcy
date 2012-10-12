package net.satcy.util{
	public function trim(str:String):String {
        var startIndex:int = 0;
        while (isWhitespace(str.charAt(startIndex)))
            ++startIndex;

        var endIndex:int = str.length - 1;
        while (isWhitespace(str.charAt(endIndex)))
            --endIndex;

        if (endIndex >= startIndex)
            return str.slice(startIndex, endIndex + 1);
        else
            return "";
    }   
}

internal function isWhitespace(character:String):Boolean{
    switch (character){
    	case "　":
        case " ":
        case "\t":
        case "\r":
        case "\n":
        case "\f":
            return true;

        default:
            return false;
    }
}