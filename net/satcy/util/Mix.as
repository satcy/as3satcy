package net.satcy.util{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import net.satcy.display.DisplayObjectUtils;
	import net.satcy.view.IView;
	
	
	public class Mix{
		//Utils Mix
		public static function init(_stage:Stage):void{
			LayOutUtil.init(_stage);
		}
		
		
		//--------------------------------------------------
		//EnterFrame
		//--------------------------------------------------
		public static function addEnterFrame(obj:Object, func:Function):void{
			EnterFrame.add(obj, func);
		}
		
		public static function removeEnterFrame(obj:Object):void{
			EnterFrame.remove(obj);
		}
		
		
		//--------------------------------------------------
		//Layout
		//--------------------------------------------------
		public static function stage():Stage{
			return LayOutUtil.stage;
		}
		
		public static function setMinStageSize(rect:Rectangle):void{
			LayOutUtil.minRect = rect;
		}
		
		public static function setMaxStageSize(rect:Rectangle):void{
			LayOutUtil.maxRect = rect;
		}
		
		public static function setStageLtNoScale():void{
			LayOutUtil.LtNoScale();
		}
		
		public static function setStageShowAll():void{
			LayOutUtil.showAll();
		}
		
		
		//--------------------------------------------------
		//Resize
		//--------------------------------------------------
		public static function setResizeEvent():void{
			LayOutUtil.setResize();
		}
		
		public static function addTargetOnResizeEvent(view:IView):void{
			LayOutUtil.add(view);
		}
		
		public static function removeTargetOnResizeEvent(view:IView):void{
			LayOutUtil.remove(view);
		}
		
		//--------------------------------------------------
		//MouseEvent
		//--------------------------------------------------
		public static function addMouseEvent(obj:Object, bool:Boolean, handlers:Object):void{
			MouseEventUtil.adds(obj, bool, handlers);
		}
		
		public static function removeMouseEvent(obj:Object):void{
			MouseEventUtil.removes(obj);
		}
		
		public static function pauseAllMouseEvent(cancel_obj:Array = null):void{
			MouseEventMg.pause(cancel_obj);
		}
		
		public static function resumeAllMouseEvent(cancel_obj:Array = null):void{
			MouseEventMg.resume(cancel_obj);
		}
		
		//--------------------------------------------------
		//DisplayObject
		//--------------------------------------------------
		public static function removeAllChildren(sp:Sprite):void{
			DisplayObjectUtils.removeAllChildren(sp);
		}
		
		public static function mouseEnable(sp:Sprite, _bool:Boolean):void{
			DisplayObjectUtils.mouseEnable(sp, _bool);
		}
		
		//--------------------------------------------------
		//Link
		//--------------------------------------------------
		public static function getURL(url:String, target:String = "_self"):void{
			Linker.getURL(url, target);
		}
	}
}