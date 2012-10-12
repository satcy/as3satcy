package net.satcy.action{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import net.satcy.util.ArrayUtil;
	
	public class PuzzleShuffle{
		private var target:Sprite;
		public var now_cnt:Number = -1;
		public function PuzzleShuffle(_parent:Sprite, _target:Sprite){
			target = _target;
			target.visible = false;
			var bmp:BitmapData = new BitmapData(target.width, target.height, true, 0x00000000);
			bmp.draw(target);
			var _num_x:int = 10;
			var _num_y:int = 3;
			var c_w:int = bmp.width / _num_x;
			var c_h:int = bmp.height / _num_y;
			var bmp_2:BitmapData;
			var bm:Bitmap;
			var _mat:Matrix;
			var bm_arr:Array = [];
			var i:int;
			var j:int;
			var l:int = _num_x*_num_y;
			var shuffle_arr:Array;
			for ( j = 0; j<_num_y; j++ ){
				for ( i = 0; i<_num_x; i++ ){
					_mat = new Matrix();
					_mat.translate( -i*c_w, -j*c_h );
					bmp_2 = new BitmapData(c_w, c_h, true, 0x00000000);
					bmp_2.draw(bmp, _mat);
					bm = new Bitmap( bmp_2 );
					bm.x = i*c_w + target.x;
					bm.y = j*c_h + target.y;
					_parent.addChild( bm );
					bm_arr.push( bm );
				}
			}
			bmp.dispose();
			bmp = null;
			Tweener.addTween(this,{now_cnt:l, time:1, delay:0., transition:"easeinoutcubic", onUpdate:update, onComplete:complete});
			function update():void{
				shuffle_arr = [];
				var offset_i:int = 0;
				for ( i = 0; i<l; i++ ){
					if ( i < now_cnt ){
						bm = bm_arr[i];
						bm.x = (i%_num_x)*c_w + target.x;
						bm.y = int(i/_num_x)*c_h + target.y;
						offset_i = i+1;
					}else{
						shuffle_arr.push( i );
					}
				}
				shuffle_arr = ArrayUtil.shuffle( shuffle_arr );
				for ( i = 0; i<shuffle_arr.length; i++ ){
					bm = bm_arr[ shuffle_arr[i] ];
					bm.x = ((offset_i+i)%_num_x)*c_w + target.x;
					bm.y = int((offset_i+i)/_num_x)*c_h + target.y;
				}
			}
			
			function complete():void{
				for ( i = 0; i<l; i++ ){
					bm = bm_arr[i];
					_parent.removeChild( bm );
					bm.bitmapData.dispose();
				}
				target.visible = true;
				bm_arr = null;
				target = null;
			}
		}

	}
}