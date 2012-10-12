package net.satcy.data{
	public class LoadAsset{
		private var pFunc:Function;
		private var onFunc:Function;
		private var paths:Array;
		private var isPause:Boolean = true;
		public function LoadAsset(_paths:Array, _pfn:Function = null, _fn:Function = null):void{
			paths = _paths;
			pFunc = _pfn;
			onFunc = _fn;
			
			resume();
		}
		
		public function stop():void{
			var pla:PreLoadAsset = PreLoadAsset.getInstance();
			pla.removeEventListener(PreLoadAssetEvent.ON_PROGRESS, onProgress);
			pla.removeEventListener(PreLoadAssetEvent.ON_COMPLETE, onComplete);
			if ( !pla.isProgress ) return;
			pause();
			pla.stop();
			
			paths = [];
			paths = null;
			onFunc = null;
			pFunc = null;
		}
		
		
		public function pause():void{
			if ( isPause ) return;
			//trace("PAUSE");
			isPause = true;
			var pla:PreLoadAsset = PreLoadAsset.getInstance();
			pla.removeEventListener(PreLoadAssetEvent.ON_PROGRESS, onProgress);
			pla.removeEventListener(PreLoadAssetEvent.ON_COMPLETE, onComplete);
			//if ( !pla.isProgress ) return;
			
			var l:int = paths.length;
			for ( var i:int = 0; i<l; i++ ){
				pla.remove( paths[i] );
			}
			//trace(pla.set_arr);
		}
		
		public function resume():void{
			if ( !isPause ) return;
			//trace("RESUME");
			isPause = false;
			var pla:PreLoadAsset = PreLoadAsset.getInstance();
			var l:int = paths.length;
			for ( var i:int = 0; i<l; i++ ){
				pla.add( paths[i] );
			}
			
			//trace(pla.set_arr);
			pla.addEventListener(PreLoadAssetEvent.ON_PROGRESS, onProgress);
			pla.addEventListener(PreLoadAssetEvent.ON_COMPLETE, onComplete);
				
			if ( !pla.isProgress ){	
				pla.exec();
			}
		}
		
		private function onProgress(e:PreLoadAssetEvent):void{
			if( pFunc == null ) return;
			var per:Number = ((e.count + e.percent/100)/e.maxCount)*100;
			pFunc(per);
		}
		
		private function onComplete(e:PreLoadAssetEvent):void{
			var pla:PreLoadAsset = PreLoadAsset.getInstance();
			pla.removeEventListener(PreLoadAssetEvent.ON_PROGRESS, onProgress);
			pla.removeEventListener(PreLoadAssetEvent.ON_COMPLETE, onComplete);
			if( onFunc != null ) onFunc();
			onFunc = null;
			pFunc = null;
			paths = null;
		}
	}
}