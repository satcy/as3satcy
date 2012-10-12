package net.satcy.action
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	

	public function dizer2(_sp:DisplayObjectContainer, _col:uint, _time:Number):void{
		var nx:Number = 10;
		var ny:Number = 10;
		var cw:Number = _sp.width/nx;
		var ch:Number = _sp.height/ny;
		var sp:Shape;
		var i:int, j:int;
		var _p:DisplayObjectContainer = _sp;
		var cnt:int = 0;
		var a:Array = [];
		for ( i=0; i<nx; i++ ){
			for ( j=0; j<ny; j++ ){
				cnt ++;
				sp = new Shape();
				sp.graphics.beginFill(_col, 1);
				sp.graphics.drawRect(0,0,cw,ch);
				_p.addChild(sp);
				sp.x = i*cw;
				sp.y = j*ch;
				TweenMax.to(sp, 0, {alpha:0, delay:Math.random()*(_time-0.1)+0.1, onComplete:onEndTween});
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