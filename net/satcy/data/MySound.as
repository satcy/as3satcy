package net.satcy.data {
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author TCY
	 *	@since  27.11.2007
	 */
	public class MySound {
		public var sound:Sound;
		private var file_path:String;
		public function MySound(stream:URLRequest = null, context:SoundLoaderContext = null){
			if(stream != null){
				load(stream, context);
			}else{
				sound = new Sound(stream, context);
			}
		}
		
		public function load(stream:URLRequest, context:SoundLoaderContext = null):void{
			//trace((stream.url));
			file_path = stream.url;
			if(LoadSoundManager.loadedCheck(file_path)){
				sound =  LoadSoundManager.getLoadedObject(file_path);
			}else{
				sound = new Sound();
				try{
					sound.load(stream, context);
				}catch(e:Error){
					trace(e.message);
				}
				sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				sound.addEventListener(Event.COMPLETE, completeHandler);
				LoadSoundManager.startLoad(file_path, sound);
			}
		}
				
		public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel{
			return sound.play(startTime,loops,sndTransform);
		}
		private function errorHandler(e:IOErrorEvent):void{
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			sound.removeEventListener(Event.COMPLETE, completeHandler);
			LoadSoundManager.storeNotFoundFilePath(file_path);
		}
		private function completeHandler(event:Event):void {
			//trace(file_path);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			sound.removeEventListener(Event.COMPLETE, completeHandler);
			LoadSoundManager.loadedStore(file_path, sound);
        }
        
        public function get duration():Number{
        	var duration:Number = -1;
        	if (sound && sound.length > 0){
    			duration = (sound.bytesTotal / (sound.bytesLoaded / sound.length)) / 1000;
			}
			return duration;
        }
        
        public function destory():void{
        	//sound = null;
        }
	}
	
}
