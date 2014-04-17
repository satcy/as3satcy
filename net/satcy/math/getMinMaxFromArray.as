package net.satcy.math
{
	public function getMinMaxFromArray(numbers:Array):Array{
		var min:Number = Number.MAX_VALUE;
		var max:Number = Number.MIN_VALUE;
		var l:int = numbers.length;
		for ( var i:int = 0; i<l; i++ ) {
			if ( numbers[i] > max ) max = numbers[i];
			if ( numbers[i] < min ) min = numbers[i];
		}
		return [min, max];
	}

	
}