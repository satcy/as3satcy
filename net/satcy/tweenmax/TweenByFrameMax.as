package net.satcy.tweenmax
{
	import com.greensock.TweenMax;
	
	public class TweenByFrameMax
	{
		public static var fps:Number = 30;
		public static var thru:Boolean = false;
		public function TweenByFrameMax()
		{
		}
		
		public static function to(target:Object, duration:Number, vars:Object):TweenMax {
			if ( !thru ) { 
				duration *= fps;
				vars = configure(vars);
			}
			return TweenMax.to(target, duration, vars);
		}
		
		public static function from(target:Object, duration:Number, vars:Object):TweenMax {
			if ( !thru ) { 
				duration *= fps;
				vars = configure(vars);
			}
			return TweenMax.from(target, duration, vars);
		}
		
		private static function configure(vars:Object):Object{
			vars = vars || {};
			vars.useFrames = true;
			if ( vars.delay ) vars.delay *= fps;
			return vars;
		}
	}
}