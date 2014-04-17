package net.satcy.error{
	import flash.errors.StackOverflowError;
	
	public function forceRuntimeError():void{
		throw new Error( new StackOverflowError().getStackTrace() );
	}
}