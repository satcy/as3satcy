package net.satcy.of{
    public function noise2(x:Number, y:Number):Number{
		return _slang_library_noise2(x, y);
	}

}
	import __AS3__.vec.Vector;
internal const F2:Number = 0.366025403; /* F2 = 0.5*(sqrt(3.0)-1.0) */
internal const G2:Number = 0.211324865;
internal const perm:Vector.<int> = Vector.<int>([151,160,137,91,90,15,
	  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
	  151,160,137,91,90,15,
	  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180 
	]);

internal function grad2( hash:int, x:Number, y:Number ):Number {
    var h:int = hash & 7;      /* Convert low 3 bits of hash code */
    var u:Number = h<4 ? x : y;  /* into 8 simple gradient directions, */
    var v:Number = h<4 ? y : x;  /* and compute the dot product with (x,y). */
    return ((h&1)? -u : u) + ((h&2)? -2.0*v : 2.0*v);
}

/* 2D simplex noise */
internal function _slang_library_noise2 (x:Number, y:Number):Number{

    var n0:Number, n1:Number, n2:Number; /* Noise contributions from the three corners */

    /* Skew the input space to determine which simplex cell we're in */
    var s:Number = (x+y)*F2; /* Hairy factor for 2D */
    var xs:Number = x + s;
    var ys:Number = y + s;
    var i:int = (xs>0) ? int(xs) : (int(xs)-1);
    var j:int = (ys>0) ? int(ys) : (int(ys)-1);

    var t:Number = (Number)(i+j)*G2;
    var X0:Number = i-t; /* Unskew the cell origin back to (x,y) space */
    var Y0:Number = j-t;
    var x0:Number = x-X0; /* The x,y distances from the cell origin */
    var y0:Number = y-Y0;

    var x1:Number, y1:Number, x2:Number, y2:Number;
    var ii:int, jj:int;
    var t0:Number, t1:Number, t2:Number;

    /* For the 2D case, the simplex shape is an equilateral triangle. */
    /* Determine which simplex we are in. */
    var i1:int, j1:int; /* Offsets for second (middle) corner of simplex in (i,j) coords */
    if(x0>y0) {i1=1; j1=0;} /* lower triangle, XY order: (0,0)->(1,0)->(1,1) */
    else {i1=0; j1=1;}      /* upper triangle, YX order: (0,0)->(0,1)->(1,1) */

    /* A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and */
    /* a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where */
    /* c = (3-sqrt(3))/6 */

    x1 = x0 - i1 + G2; /* Offsets for middle corner in (x,y) unskewed coords */
    y1 = y0 - j1 + G2;
    x2 = x0 - 1.0 + 2.0 * G2; /* Offsets for last corner in (x,y) unskewed coords */
    y2 = y0 - 1.0 + 2.0 * G2;

    /* Wrap the integer indices at 256, to avoid indexing perm[] out of bounds */
    ii = i % 256;
    jj = j % 256;
    while ( ii < 0 ) ii += 256;
    while ( jj < 0 ) jj += 256;

    /* Calculate the contribution from the three corners */
    t0 = 0.5 - x0*x0-y0*y0;
    if(t0 < 0.0) n0 = 0.0;
    else {
      t0 *= t0;
      n0 = t0 * t0 * grad2(perm[ii+perm[jj]], x0, y0); 
    }

    t1 = 0.5 - x1*x1-y1*y1;
    if(t1 < 0.0) n1 = 0.0;
    else {
      t1 *= t1;
      n1 = t1 * t1 * grad2(perm[ii+i1+perm[jj+j1]], x1, y1);
    }

    t2 = 0.5 - x2*x2-y2*y2;
    if(t2 < 0.0) n2 = 0.0;
    else {
      t2 *= t2;
      n2 = t2 * t2 * grad2(perm[ii+1+perm[jj+1]], x2, y2);
    }

    /* Add contributions from each corner to get the final noise value. */
    /* The result is scaled to return values in the interval [-1,1]. */
    return 40.0 * (n0 + n1 + n2); /* TODO: The scale factor is preliminary! */
}
