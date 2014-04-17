package net.satcy.util{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import net.satcy.view.IView;
	
	public class LayOutUtil{
		
		
		public static var stage:Stage;
		public static var sw:Number;
		public static var sh:Number;
		public static var minRect:Rectangle;
		public static var maxRect:Rectangle;
		
		private static var layout_resize:LayOutResize;
		
		
		private static var dict:Dictionary;
		
		public static function init(_stage:Stage):void{
			stage = _stage;
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			dict = new Dictionary(true);
		}
		
		public static function add(_view:IView, _auto_remove_at_remove_from_stage:Boolean = false):void{
			dict[_view] = _view;
			if ( _auto_remove_at_remove_from_stage ) {
				_view.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
			}
		}
		
		private static function onRemoveFromStageHandler(e:Event):void{
			var _view:IView = e.target as IView;
			_view.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
			remove(_view);
		}
		
		public static function remove(_view:IView):void{
			if ( dict[_view] ) delete dict[_view];
		}
		
		public static function dump():void{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			if ( minRect != null || maxRect != null ){
				//sw = Mass.minMax(stage.stageWidth, minRect.width, maxRect.width);
				//sh = Mass.minMax(stage.stageHeight, minRect.height, maxRect.height);
				if ( minRect != null ){
					sw = Math.max(sw, minRect.width);
					sh = Math.max(sh, minRect.height);
				}
				if ( maxRect != null ){
					sw = Math.min(sw, maxRect.width);
					sh = Math.min(sh, maxRect.height);
				} 
			}
			for( var i:* in dict ){
				IView(dict[i]).onResizing(sw, sh);
			}
		}
		
		public static function setResize():void{
			if( layout_resize != null ) layout_resize.destroy();
			layout_resize = new LayOutResize(LayOutUtil.dump);
		}
		
		public static function deleteResize():void{
			layout_resize.destroy();
			layout_resize = null;
		}
		
		public static function LtNoScale():void{
			if ( stage == null ) return;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		public static function showAll():void{
			if ( stage == null ) return;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
		}
		
		public static function left(_view:IView):void{
			_view["x"] = 0;
		} 
		public static function center(_view:IView):void{
			_view["x"] = int((sw - _view._thisWidth)*0.5);
		}
		public static function right(_view:IView):void{
			_view["x"] = (sw - _view._thisWidth);
		}
		public static function top(_view:IView):void{
			_view["y"] = 0;
		}
		public static function middle(_view:IView):void{
			_view["y"] = int((sh - _view._thisHeight)*0.5);
		}
		public static function bottom(_view:IView):void{
			_view["y"] = sh - _view._thisHeight;
		}
		
		
	}
}