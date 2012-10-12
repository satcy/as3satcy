package net.satcy.data{
	import flash.errors.EOFError;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class DelateBlankSound{
		private var wavBytes:ByteArray;
		private var stream:URLStream;
		
		public function DelateBlankSound()
		{
			
			
			wavBytes = new ByteArray();
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE,dataLoaded);
			stream.load(new URLRequest("sound/bgm_pan2.mp3"));
			
		}
		
		private function dataLoaded(ev:Event):void
		{
			trace( "HERE" );
			stream.readBytes( wavBytes );
			trace(wavBytes.length);
			var l:int = wavBytes.length;
			var isSilence:Boolean = true;
			for ( var i:int=0; i<l; i++ ){
				var p:Number;
				try{
					p = wavBytes.readFloat();
				}catch(e:EOFError){
					//trace(e);
				}
				/*
				if ( i > 335 ) {
					if ( isSilence && p>-10 && p<10 && i < 44000 ){
						//trace(p, i);
					}else{
						if ( isSilence ) trace(((i-336)*1000)/44000 + "ms");
						isSilence = false;
					}
				}
				*/
				if ( i < 4000 ) {
					trace(p, i);
				}
			}
		}
		
	
	}

}