﻿package net.satcy.data {	import flash.errors.IllegalOperationError;	import flash.events.*;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundLoaderContext;	import flash.net.URLRequest;	import flash.utils.*;	/**	 *	Class description.	 *	 *	@langversion ActionScript 3.0	 *	@playerversion Flash 9.0	 *	 *	@author TCY	 *	@since  26.11.2007	 */		public class LoadSound extends EventDispatcher{		private static var instance:LoadSound = null;    	private static var internallyCalled:Boolean = false;		private var so:Sound;		private var onComplete:Function;		private var url:String;				public function LoadSound(){//////This is Singleton Class			if (internallyCalled) {  				//trace("constructor is called");   				internallyCalled = false;			} else {  				throw new IllegalOperationError ("Use Singleton.getInstance() to get the instance");			}		}				public static function getInstance():LoadSound {			if(LoadSound.instance == null) {  				//trace("instance is being created");  				internallyCalled = true;   				instance = new LoadSound();			}			return instance; 		}				public function loadStart(__path:String, __func:Function):void{			url = __path;			onComplete = __func;			if( LoadSoundManager.loadedCheck(url) ){				onComplete();							}else{				so = new Sound();				//so.load(new URLRequest(url));				try {		            so.load(new URLRequest(url));		        } catch (e:Error) {		        	//trace(e.message);		        	completeHandler(null);		        }		        so.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);				so.addEventListener(Event.COMPLETE, completeHandler);				so.addEventListener(ProgressEvent.PROGRESS, progressHandler);			}		}		private function errorHandler(e:IOErrorEvent):void{			completeHandler(null);		}		private function completeHandler(event:Event):void {            //trace("completeHandler: " + event.target);            so.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);			so.removeEventListener(Event.COMPLETE, completeHandler);			so.removeEventListener(ProgressEvent.PROGRESS, progressHandler);						if ( event ){				LoadSoundManager.loadedStore(url, so);			}else{				LoadSoundManager.storeNotFoundFilePath(url);				var r:LoadImageEvent = new LoadImageEvent (LoadImageEvent.ON_PROGRESS);				r.percent = 100;				dispatchEvent (r);///イベント送出			}						so = null;						onComplete();			onComplete = null;        }		private function progressHandler(event:ProgressEvent):void{			var r:LoadImageEvent = new LoadImageEvent (LoadImageEvent.ON_PROGRESS);			r.percent = Math.floor(event.bytesLoaded/event.bytesTotal*100);			dispatchEvent (r);///イベント送出		}	}	}