package net.satcy.data{
	import flash.display.Loader;
	public function getInstanceFromSwf(_path:String):Loader{
		var lsm:LoadSwfManager = LoadSwfManager.getInstance();
		if ( lsm.loadedCheck(_path) ){
			return lsm.getLoadedObject(_path);
		}else{
			return null;
		}
	}

}