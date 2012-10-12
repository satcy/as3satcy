package net.satcy.data{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadXML{
		public var myXML:XML;
		
		private var onCompleteFunc:Function;
		
		public function LoadXML(str:String, fn:Function){
			var myLoader:URLLoader = new URLLoader();
			myLoader.addEventListener(Event.COMPLETE, completeData);

			myLoader.load(new URLRequest(str));
			
			onCompleteFunc = fn;
			
		}
		private function completeData(event:Event):void {
			var myLoader = event.target;
			myLoader.removeEventListener(Event.COMPLETE, completeData);
			
			myXML = new XML(myLoader.data);
			default xml namespace = new Namespace( myXML.namespaceDeclarations().toString() );
			//trace(myXML.data[0].title);
			
			onCompleteFunc();
			myXML = null;
			onCompleteFunc = null;
			delete this;
		}
		
	}
	
	
}