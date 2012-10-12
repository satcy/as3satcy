package net.satcy.of{
	public function noise4(x:Number, y:Number, z:Number, w:Number):Number{
		return _slang_library_noise4(x, y, z, w);
	}
	
}
	import __AS3__.vec.Vector;
internal const F4:Number = 0.309016994; /* F4 = (Math.sqrt(5.0)-1.0)/4.0 */
internal const G4:Number = 0.138196601; /* G4 = (5.0-Math.sqrt(5.0))/20.0 */
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
  /* A lookup table to traverse the simplex around a given point in 4D. */
  /* Details can be found where this table is used, in the 4D noise method. */
  /* TODO: This should not be required, backport it from Bill's GLSL code! */
internal const simplex:Array = [
    [0,1,2,3],[0,1,3,2],[0,0,0,0],[0,2,3,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,2,3,0],
    [0,2,1,3],[0,0,0,0],[0,3,1,2],[0,3,2,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,3,2,0],
    [0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
    [1,2,0,3],[0,0,0,0],[1,3,0,2],[0,0,0,0],[0,0,0,0],[0,0,0,0],[2,3,0,1],[2,3,1,0],
    [1,0,2,3],[1,0,3,2],[0,0,0,0],[0,0,0,0],[0,0,0,0],[2,0,3,1],[0,0,0,0],[2,1,3,0],
    [0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
    [2,0,1,3],[0,0,0,0],[0,0,0,0],[0,0,0,0],[3,0,1,2],[3,0,2,1],[0,0,0,0],[3,1,2,0],
    [2,1,0,3],[0,0,0,0],[0,0,0,0],[0,0,0,0],[3,1,0,2],[0,0,0,0],[3,2,0,1],[3,2,1,0]];


internal function grad4( hash:int,  x:Number, y:Number, z:Number, t:Number ):Number {
   	var h:int = hash & 31;      /* Convert low 5 bits of hash code into 32 simple */
    var u:Number = h<24 ? x : y; /* gradient directions, and compute dot product. */
    var v:Number = h<16 ? y : z;
    var w:Number = h<8 ? z : t;
    return ((h&1)? -u : u) + ((h&2)? -v : v) + ((h&4)? -w : w);
}

/* 4D simplex noise */
internal function _slang_library_noise4 (x:Number, y:Number, z:Number, w:Number):Number{
  /* The skewing and unskewing factors are hairy again for the 4D case */

    var n0:Number, n1:Number, n2:Number, n3:Number, n4:Number; /* Noise contributions from the five corners */

    /* Skew the (x,y,z,w) space to determine which cell of 24 simplices we're in */
    var s:Number = (x + y + z + w) * F4; /* Factor for 4D skewing */
    var xs:Number = x + s;
    var ys:Number = y + s;
    var zs:Number = z + s;
    var ws:Number = w + s;
    var i:int = Math.floor(xs);
    var j:int = Math.floor(ys);
    var k:int = Math.floor(zs);
    var l:int = Math.floor(ws);

    var t:Number = (i + j + k + l) * G4; /* Factor for 4D unskewing */
    var X0:Number = i - t; /* Unskew the cell origin back to (x,y,z,w) space */
    var Y0:Number = j - t;
    var Z0:Number = k - t;
    var W0:Number = l - t;

    var x0:Number = x - X0;  /* The x,y,z,w distances from the cell origin */
    var y0:Number = y - Y0;
    var z0:Number = z - Z0;
    var w0:Number = w - W0;

    /* For the 4D case, the simplex is a 4D shape I won't even try to describe. */
    /* To find out which of the 24 possible simplices we're in, we need to */
    /* determine the magnitude ordering of x0, y0, z0 and w0. */
    /* The method below is a good way of finding the ordering of x,y,z,w and */
    /* then find the correct traversal order for the simplex we're in. */
    /* First, six pair-wise comparisons are performed between each possible pair */
    /* of the four coordinates, and the results are used to add up binary bits */
    /* for an integer index. */
    var c1:int = (x0 > y0) ? 32 : 0;
    var c2:int = (x0 > z0) ? 16 : 0;
    var c3:int = (y0 > z0) ? 8 : 0;
    var c4:int = (x0 > w0) ? 4 : 0;
    var c5:int = (y0 > w0) ? 2 : 0;
    var c6:int = (z0 > w0) ? 1 : 0;
    var c:int = c1 + c2 + c3 + c4 + c5 + c6;

    var i1:int, j1:int, k1:int, l1:int; /* The integer offsets for the second simplex corner */
    var i2:int, j2:int, k2:int, l2:int; /* The integer offsets for the third simplex corner */
    var i3:int, j3:int, k3:int, l3:int; /* The integer offsets for the fourth simplex corner */

    var x1:Number, y1:Number, z1:Number, w1:Number, x2:Number, y2:Number, z2:Number, w2:Number, x3:Number, y3:Number, z3:Number, w3:Number, x4:Number, y4:Number, z4:Number, w4:Number;
    var ii:int, jj:int, kk:int, ll:int;
    var t0:Number, t1:Number, t2:Number, t3:Number, t4:Number;

    /* simplex[c] is a 4-vector with the numbers 0, 1, 2 and 3 in some order. */
    /* Many values of c will never occur, since e.g. x>y>z>w makes x<z, y<w and x<w */
    /* impossible. Only the 24 indices which have non-zero entries make any sense. */
    /* We use a thresholding to set the coordinates in turn from the largest magnitude. */
    /* The number 3 in the "simplex" array is at the position of the largest coordinate. */
    i1 = simplex[c][0]>=3 ? 1 : 0;
    j1 = simplex[c][1]>=3 ? 1 : 0;
    k1 = simplex[c][2]>=3 ? 1 : 0;
    l1 = simplex[c][3]>=3 ? 1 : 0;
    /* The number 2 in the "simplex" array is at the second largest coordinate. */
    i2 = simplex[c][0]>=2 ? 1 : 0;
    j2 = simplex[c][1]>=2 ? 1 : 0;
    k2 = simplex[c][2]>=2 ? 1 : 0;
    l2 = simplex[c][3]>=2 ? 1 : 0;
    /* The number 1 in the "simplex" array is at the second smallest coordinate. */
    i3 = simplex[c][0]>=1 ? 1 : 0;
    j3 = simplex[c][1]>=1 ? 1 : 0;
    k3 = simplex[c][2]>=1 ? 1 : 0;
    l3 = simplex[c][3]>=1 ? 1 : 0;
    /* The fifth corner has all coordinate offsets = 1, so no need to look that up. */

    x1 = x0 - i1 + G4; /* Offsets for second corner in (x,y,z,w) coords */
    y1 = y0 - j1 + G4;
    z1 = z0 - k1 + G4;
    w1 = w0 - l1 + G4;
    x2 = x0 - i2 + 2.0*G4; /* Offsets for third corner in (x,y,z,w) coords */
    y2 = y0 - j2 + 2.0*G4;
    z2 = z0 - k2 + 2.0*G4;
    w2 = w0 - l2 + 2.0*G4;
    x3 = x0 - i3 + 3.0*G4; /* Offsets for fourth corner in (x,y,z,w) coords */
    y3 = y0 - j3 + 3.0*G4;
    z3 = z0 - k3 + 3.0*G4;
    w3 = w0 - l3 + 3.0*G4;
    x4 = x0 - 1.0 + 4.0*G4; /* Offsets for last corner in (x,y,z,w) coords */
    y4 = y0 - 1.0 + 4.0*G4;
    z4 = z0 - 1.0 + 4.0*G4;
    w4 = w0 - 1.0 + 4.0*G4;

    /* Wrap the integer indices at 256, to avoid indexing perm[] out of bounds */
    ii = i % 256;
    jj = j % 256;
    kk = k % 256;
    ll = l % 256;

    /* Calculate the contribution from the five corners */
    t0 = 0.6 - x0*x0 - y0*y0 - z0*z0 - w0*w0;
    if(t0 < 0.0) n0 = 0.0;
    else {
      t0 *= t0;
      n0 = t0 * t0 * grad4(perm[ii+perm[jj+perm[kk+perm[ll]]]], x0, y0, z0, w0);
    }

   t1 = 0.6 - x1*x1 - y1*y1 - z1*z1 - w1*w1;
    if(t1 < 0.0) n1 = 0.0;
    else {
      t1 *= t1;
      n1 = t1 * t1 * grad4(perm[ii+i1+perm[jj+j1+perm[kk+k1+perm[ll+l1]]]], x1, y1, z1, w1);
    }

   t2 = 0.6 - x2*x2 - y2*y2 - z2*z2 - w2*w2;
    if(t2 < 0.0) n2 = 0.0;
    else {
      t2 *= t2;
      n2 = t2 * t2 * grad4(perm[ii+i2+perm[jj+j2+perm[kk+k2+perm[ll+l2]]]], x2, y2, z2, w2);
    }

   t3 = 0.6 - x3*x3 - y3*y3 - z3*z3 - w3*w3;
    if(t3 < 0.0) n3 = 0.0;
    else {
      t3 *= t3;
      n3 = t3 * t3 * grad4(perm[ii+i3+perm[jj+j3+perm[kk+k3+perm[ll+l3]]]], x3, y3, z3, w3);
    }

   t4 = 0.6 - x4*x4 - y4*y4 - z4*z4 - w4*w4;
    if(t4 < 0.0) n4 = 0.0;
    else {
      t4 *= t4;
      n4 = t4 * t4 * grad4(perm[ii+1+perm[jj+1+perm[kk+1+perm[ll+1]]]], x4, y4, z4, w4);
    }

    /* Sum up and scale the result to cover the range [-1,1] */
    return 27.0 * (n0 + n1 + n2 + n3 + n4); /* TODO: The scale factor is preliminary! */
}