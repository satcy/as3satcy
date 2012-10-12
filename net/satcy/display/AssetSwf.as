package net.satcy.display{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	/**
	*	@author satoshi
	 * クラスをつけた素材だけを入れこんだSWFに使う
	*/
	public class AssetSwf extends MovieClip{	
		public function AssetSwf(){
		}
		public function getSoundClass(_filename:String):Class{
			return Class(getDefinitionByName(_filename));
		}
	}
}