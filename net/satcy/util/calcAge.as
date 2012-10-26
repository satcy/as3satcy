package net.satcy.util{
		public function calcAge(_now:Date, _birth:Date):int{
			var birthday1:Number=_birth.fullYear*10000+(_birth.month+1)*100+_birth.date; 
			var today1:Number=_now.fullYear*10000+(_now.month+1)*100+_now.date;
			return Math.floor((today1-birthday1)/10000);
		}
}