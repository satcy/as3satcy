package net.satcy.math{
		public function normalizeArray(numbers:Array, out_min:Number = 0, out_max:Number = 1):Array{
			var minMax:Array = getMinMaxFromArray(numbers);
			var min:Number = minMax[0];
			var max:Number = minMax[1];
			var l:int = numbers.length;
			for ( var i:int = 0; i<l; i++ ) {
				numbers[i] = scale(numbers[i], min, max, out_min, out_max);
			}
			return numbers;
		}
	
}