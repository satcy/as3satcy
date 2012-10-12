package net.satcy.util{
	
	public class TweenerUtil{
		
		/*
		var customEasing:Array = [{Mx:0,My:0,Nx:110,Ny:-16,Px:-38,Py:-76},{Mx:72,My:-92,Nx:54,Ny:134,Px:-4,Py:-222},{Mx:122,My:-180,Nx:34,Ny:-80,Px:44,Py:60},{Mx:200, My:-200}];
        Tweener.addTween(this._circle, {
            x: this.stage.mouseX,
            y: this.stage.mouseY,
            time: 1,
            transition: TweenerUtil.fromCurve,
            transitionParams: customEasing
        });
        */
		public static function fromCurve (t:Number,b:Number,c:Number,d:Number,pl:Array):Number {
			var r:Number = 200 * t/d;
			var i:Number = -1;
			var e:Object;
			while (pl[++i].Mx<=r) e = pl[i];
			var Px:Number = e.Px;
			var Nx:Number = e.Nx;
			var s:Number = (Px==0) ? -(e.Mx-r)/Nx : (-Nx+Math.sqrt(Nx*Nx-4*Px*(e.Mx-r)))/(2*Px);
			return (b-c*((e.My+e.Ny*s+e.Py*s*s)/200));
		}
	}
}