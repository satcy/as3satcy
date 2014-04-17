package net.satcy.util
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	public class ProjectionUtil
	{
		public static function setProjectionCenter(_x:Number, _y:Number, _target:DisplayObject, stage:Stage):void{
			var o:DisplayObject = _target;
			while (o.parent != stage) {
			  o.transform.perspectiveProjection = null;
			  o = o.parent;
			}
			try{
				if ( _target.root ){
					var proj:PerspectiveProjection = _target.root.transform.perspectiveProjection;
					var pt:Point = proj.projectionCenter;
					pt.x = _x;
					pt.y = _y;
					proj.projectionCenter = pt;
					_target.root.transform.perspectiveProjection = proj;
				}
			}catch(e:*){
				
			}	
		}

	}
}