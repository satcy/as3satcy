﻿package net.satcy.ddd{	import flash.display.*;	public class SortDepth extends Sprite{				private var scope:*;				public function SortDepth(_mc:*){			scope = _mc;		}				public function swapDepth(num:*, num_2:*):void{						scope.swapChildren(num, num_2);		}				public function getDepthNum(mc:*):Number{									return scope.getChildIndex(mc);		}				public function getDepthAt(num:uint):DisplayObjectContainer{			return scope.getChildAt(num);		}	}			}