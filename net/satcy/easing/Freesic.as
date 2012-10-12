package net.satcy.easing
{
	public class Freesic
	{
		/*
		ex.
		import net.satcy.easing.Freesic;
		
		var freeEasing:Array = [0, 0.5, 1];
		
		//if you use TweenMax
		TweenMax.to(this, 1, {ease:Freesic.easeFree, easeParams:[ freeEasing ]});		
		
		//if you use Tweener.
		Tweener.addTween(this, {time:1, transition:Freesic.easeFree, transitionParams:freeEasing});
		*/
		/*
		You can generate Params by "tween_table_drawer.swf"
		*/
		public static function easeFree (t:Number, b:Number, c:Number, d:Number, tb:Array = null):Number {
			var r:Number = c*t/d + b;
			if ( tb && tb.length > 1 ){
				var cr:Number = 1 / (tb.length-1);
				var s_idx:int = int(r/cr);
				if ( s_idx < tb.length-1 ){
					r = (tb[s_idx+1] - tb[s_idx])*((r - (s_idx * cr))/cr) + tb[s_idx];
				}else{
					r = tb[s_idx];
				}
			}
			return r;
		}
		/*
		var customEasing:Array = [{Mx:0,My:0,Nx:110,Ny:-16,Px:-38,Py:-76},{Mx:72,My:-92,Nx:54,Ny:134,Px:-4,Py:-222},{Mx:122,My:-180,Nx:34,Ny:-80,Px:44,Py:60},{Mx:200, My:-200}];
		
		//if you use TweenMax
		TweenMax.to(this, 1, {ease:Freesic.fromCurve, easeParams:[ customEasing ]});
        
        //if you use Tweener.
        Tweener.addTween(this._circle, {transition:Freesic.fromCurve, transitionParams:customEasing});
        
        */
		/*
		You can generate Params by "customEasingTool2.swf"
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