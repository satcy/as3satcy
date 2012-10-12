package net.satcy.display{
	import flash.display.Graphics;
    public class Arc{
        public static function draw(g:Graphics, sx:Number, sy:Number, radius:Number, arc:Number, startAngle:Number=0, moveToFirst:Boolean = true):void{
            var segAngle:Number;
            var angle:Number;
            var angleMid:Number;
            var numOfSegs:Number;
            var ax:Number;
            var ay:Number;
            var bx:Number;
            var by:Number;
            var cx:Number;
            var cy:Number;
            
           if ( moveToFirst ) g.moveTo(sx, sy);
    
            if (Math.abs(arc) > 360) 
            {
            	arc = 360;
            }
    
            numOfSegs = Math.ceil(Math.abs(arc) / 45);
            segAngle = arc / numOfSegs;
            segAngle = (segAngle / 180) * Math.PI;
            angle = (startAngle / 180) * Math.PI;
            
            ax = sx - Math.cos(angle) * radius;
            ay = sy - Math.sin(angle) * radius;
    		
    		//if ( arc < 360 )
    		if ( moveToFirst ) g.lineTo(-ax, -ay);
    		else g.moveTo(-ax, -ay);
    		
            for(var i:int=0; i<numOfSegs; i++) {
                angle += segAngle;
                
                angleMid = angle - (segAngle / 2);
                
                bx = sx + Math.cos(angle) * radius;
                by = sy + Math.sin(angle) * radius;
                
                cx = sx + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
                cy = sy + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));

                g.curveTo(cx, cy, bx, by);
            }
            //if ( arc >= 360 ) t.graphics.lineTo(-ax, -ay);
        }
    }
}