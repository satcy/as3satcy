﻿package net.satcy.animation{		public class WaveParticle{		private var freq:Number;		private var count:Number;		public function WaveParticle(__freq:Number, __phase:Number){			freq = __freq;			count = __phase*100;		}		public function update():Number{			count++;			var base:Number = freq * (Math.PI*2)/33 * count;			if(base>(Math.PI*2) || base<-(Math.PI*2)){				count =0 ;			}						return Math.sin( base );		}	}	}