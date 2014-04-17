package net.satcy.ui.comp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.satcy.display.DisplayObjectUtils;
	import net.satcy.event.MyEvent;
	import net.satcy.sound.IUISoundPlayer;
	import net.satcy.util.MouseEventUtil;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Quart;

	public class ClickBtn extends Sprite
	{
		protected static var _soundplayer:IUISoundPlayer;
		public static function set soundplayer(_player:IUISoundPlayer):void{ _soundplayer = _player; }
		public static function get soundplayer():IUISoundPlayer{ return _soundplayer; }
		
		protected var bm:Bitmap;
		protected var id:int = 0;
		public var bElasticOnOver:Boolean = true;
		public function ClickBtn(_id:int, _bmp:BitmapData)
		{
			super();
			id = _id;
			bm = new Bitmap(_bmp);
			this.addChild(bm);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function set bitmapData(_bmp:BitmapData):void{
			bm.bitmapData = _bmp;
		}
		
		public function set myid(_id:int):void{
			id = _id;
		}
		
		public function addEvent():void{
			MouseEventUtil.adds(this, true, {click:onClick, over:onOver, out:onOut});
		}
		
		public function removeEvent():void{
			MouseEventUtil.removes(this);
		}
		
		public function destroy():void{
			removeEvent();
			if ( bm && bm.bitmapData ) bm.bitmapData.dispose();
			if ( bm ) bm.bitmapData = null;
			bm = null;
			DisplayObjectUtils.removeAllChildren(this);
		}
		
		private function onRemove(e:Event):void{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			destroy();
		}
		
		
		protected function onClick(e:MouseEvent):void{
			if ( _soundplayer ) _soundplayer.playClick();
			this.dispatchEvent(new MyEvent(MyEvent.ITEM_SELECT, true, true, [id]));
		}
		
		protected function onOver(e:MouseEvent):void{
			if ( _soundplayer ) _soundplayer.playOver();
			this.alpha = 0;
			if ( 1 ) BetweenAS3.to(this, {alpha:1}, 0.5, Quart.easeOut).play();
			var _self:Sprite = this;
			if ( !bm || !_self.parent ) return;
			return;
			if ( !bElasticOnOver ) return;
			var _effect:ElasticBoundary = new ElasticBoundary(_self);
			_effect.x = _self.x;
			_effect.y = _self.y;
			
			this.parent.addChild(_effect);
			
		}
		
		protected function onOut(e:MouseEvent):void{
			
		}
	}
}