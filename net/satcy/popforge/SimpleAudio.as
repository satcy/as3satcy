package net.satcy.popforge
{
	import de.popforge.audio.processor.IAudioProcessor;
	
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class SimpleAudio implements IAudioProcessor, IExternalizable
	{
		private var activeVoices:Array;
		public function SimpleAudio()
		{
			activeVoices = [];
		}
		
		

		public function processAudio(samples:Array):void
		{
		}
		
		public function reset():void
		{
		}
		
		public function writeExternal(output:IDataOutput):void
		{
		}
		
		public function readExternal(input:IDataInput):void
		{
		}
		
	}
}