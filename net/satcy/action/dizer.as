package net.satcy.action
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	

	public function dizer(_sp:DisplayObject, _col:uint, _time:Number):void{
		var nx:Number = 10;
		var ny:Number = 10;
		var cw:Number = _sp.width/nx;
		var ch:Number = _sp.height/ny;
		var sp:Shape;
		var i:int, j:int;
		var _p:DisplayObjectContainer = _sp.parent;
		var cnt:int = 0;
		var a:Array = [];
		for ( i=0; i<nx; i++ ){
			for ( j=0; j<ny; j++ ){
				cnt ++;
				sp = new Shape();
				sp.graphics.beginFill(_col, 1);
				sp.graphics.drawRect(0,0,Math.ceil(cw),Math.ceil(ch));
				_p.addChild(sp);
				sp.x = _sp.x + i*cw;
				sp.y = _sp.y + j*ch;
				TweenMax.to(sp, 0, {alpha:0, delay:(cnt/(nx*ny) + Math.random()*0.3)*(_time), onComplete:onEndTween});
				a.push( sp );
			}
		}
		
		function onEndTween():void{
			cnt--;
			if ( cnt == 0 ){
				for each ( sp in a ){
					if ( sp.parent ) sp.parent.removeChild(sp);
				}
				a = null;
			}
		}
	}

	
}