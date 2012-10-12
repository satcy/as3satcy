package  net.satcy.away3d.primitives 
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cone;
	import away3d.primitives.data.Segment;
	import away3d.primitives.LineSegment;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Alex Logashov
	 */
	public class BezierCurveSample extends View3D 
	{
		
		private var cameraController:HoverDragController;
		// Position zero
		private var origin:Vector3D;
		// Lines container
		private var lines:SegmentSet;
		// Array of generated points
		private var points:Vector.<Vector3D>;
		// Array of generated bezier curves
		private var curves:Vector.<BezierCurve>;
		// Object to follow along the curve
		private var cone:ObjectContainer3D;
		// Used for animation (0 -> 1)
		private var tValue:Number = 0;
		
		public function BezierCurveSample() 
		{
			init();
		}
		
		private function init():void 
		{
			backgroundColor = 0xffffff;
			addChild(new AwayStats(this));
			
			origin = new Vector3D;
			
			generatePoints();
			initLight();
			initCamera();
			init3D();
			
			if (stage) onStage(null);
			else 
				addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function generatePoints():void 
		{
			var i:int = 0, 
				l:int = 12, 
				xStep:Number = 100,  
				xOffset:Number = (l >> 1) * xStep * -1;
			points = new <Vector3D>[];
			for (; i < l; i++)
				points[i] = new Vector3D(i * xStep + xOffset, Math.random() * 300 - 150, Math.random() * 200 - 100);
		}
		
		private function initLight():void 
		{
			
		}
		
		private function initCamera():void 
		{	
			camera.lens = new PerspectiveLens();
			camera.z = -500;
			camera.y = 500;
			camera.lookAt(origin);
		}
		
		private function init3D():void 
		{
			// Lines container
			lines = new SegmentSet;
			scene.addChild(lines);
			
			initCurves();
			drawCurve();
			
			// By default cone is Y-Axis oriented
			// To orient cone along Z-Axis, place it inside ObjectContainer3D and apply rotations
			cone = new ObjectContainer3D;
			var inner:Cone = new Cone(new ColorMaterial(0xff6600));
			inner.rotationZ = -90;
			inner.rotationX = 90;
			inner.scale(.25);
			cone.addChild(inner);
			
			scene.addChild(cone);
		}
		
		private function drawCurve():void 
		{
			var i:int = 0, l:int = curves.length;
			var ii:Number, ll:int = 1;
			var c:BezierCurve, p:Vector3D, pp:Vector3D, a:Mesh;
			for (; i < l; ++i) {
				c = curves[i];
				for (ii = 0; ii < ll; ii += .1) {
					p = c.getT(ii);
					if (!pp) pp = p.clone();
					lines.addSegment(new LineSegment(pp, p, 0x333333, 0x333333, 3));
					pp = p.clone();
				}
			}
		}
		
		private function initCurves():void 
		{
			curves = new Vector.<BezierCurve>;
			var p0:Vector3D, p1:Vector3D, p2:Vector3D = points[0].clone();
			var l:int = points.length - 1;
			var i:int = 1;
			var c:int;
			while (i < l) {
				p0 = p2.clone();
				p1 = points[i].clone();
				p2 = points[++i].clone();
				if (i !== l) {
					p2.x = (p1.x + p2.x) / 2;
					p2.y = (p1.y + p2.y) / 2;
					p2.z = (p1.z + p2.z) / 2;
				}
				curves[c++] = new BezierCurve(p0, p1, p2);
			}
		}
		
		public function positionOnCurve(t:Number, path:Vector.<BezierCurve>, object:Object3D, align:Boolean = true):Vector3D
		{
			var i:int, 
				l:int = curves.length,
				curve:BezierCurve;
			
			// Total distance of all curves
			var totalDistance:Number = 0;
			
			// Calclulate total length
			for (; i < l; ++i) {
				curve = curves[i];
				totalDistance += curve.length;
			}
			
			// Distance of t argument
			var tDistance:Number = totalDistance * t;
			
			var ct:Number,
				v:Vector3D,
				c:Number = 0;
			
			// Calculate point
			for (i = 0; i < l; ++i) {
				curve = curves[i];
				if (c + curve.length >= tDistance) {
					c = tDistance - c;
					// t value on curve relative to t of total distance
					ct = c / curve.length;
					// Get point on curve
					v = curve.getT(ct);
					// Position object
					object.position = v;
					// Optionally align object along the curve
					if (align) {
						var q:Vector3D = new Vector3D;
						q.x = curve.p1.x + ct * (curve.p2.x - curve.p1.x);
						q.y = curve.p1.y + ct * (curve.p2.y - curve.p1.y);
						q.z = curve.p1.z + ct * (curve.p2.z - curve.p1.z);
						
						object.lookAt(q);
					}
					
					break;
				}
				
				c += curve.length;
			}
			
			return v;
		}
		
	
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			stage.addEventListener(Event.RESIZE, resize);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			cameraController = new HoverDragController(camera, stage);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			resize();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			tValue = tValue > 1 ? 0 : tValue + .001;
			positionOnCurve(tValue, curves, cone, true);
			
			render();
		}
		
		private function resize(e:Event = null):void 
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
		
	}

}
import away3d.cameras.Camera3D;
import away3d.core.base.Object3D;
import away3d.entities.Mesh;
import away3d.materials.ColorMaterial;
import away3d.materials.MaterialBase;
import away3d.primitives.Cube;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Vector3D;

internal class BezierCurve
{
	
	private var _p0:Vector3D;
	private var _p1:Vector3D;
	private var _p2:Vector3D;
	
	public var length:Number;
	
	function BezierCurve(p0:Vector3D, p1:Vector3D, p2:Vector3D)
	{
		this._p0 = p0;
		this._p1 = p1;
		this._p2 = p2;
		
		length = BezierCurve.getBezierLength(this);
	}
	
	// http://segfaultlabs.com/docs/quadratic-bezier-curve-length
	static public function getBezierLength(bezier:BezierCurve):Number
	{
		var a:Vector3D = new Vector3D; 
		var b:Vector3D = new Vector3D;
		var c:Vector3D = new Vector3D;
		
		var p0:Vector3D = bezier.p0;
		var p1:Vector3D = bezier.p1;
		var p2:Vector3D = bezier.p2;
		
		a.x = p0.x - 2 * p1.x + p2.x;
		a.y = p0.y - 2 * p1.y + p2.y;
		a.z = p0.z - 2 * p1.z + p2.z;
		
		b.x = 2 * (p1.x - a.x);
		b.y = 2 * (p1.y - a.y);
		b.z = 2 * (p1.z - a.z);
		
		var A:Number = 4 * (a.x * a.x + a.y * a.y + a.z * a.z);
		
		if (A == 0) return 0;
		
		var B:Number = 4 * (a.x * b.x + a.y * b.y + a.z * b.z);
		var C:Number = b.x * b.x + b.y * b.y + b.z * b.z;
		
		var Sabc:Number = 2 * Math.sqrt(A + B + C);
		var A2:Number = Math.sqrt(A);
		var A32:Number = 2 * A * A2;
		var C2:Number = 2 * Math.sqrt(C);
		var BA:Number = B / A2;
		
		return (A32 * Sabc + A2 * B * (Sabc - C2) + (4 * C * A - B * B) * Math.log(2 * A2 +BA + Sabc) / (BA + C2)) / (4 * A32);
	}
	
	public function toString():String
	{
		return "[" + p0.toString() + ", " + p1.toString() + ", " + p2.toString() + "]";
	}
	
	public function getT(t:Number):Vector3D
	{
		var v:Vector3D = new Vector3D;
		
		v.x = _p0.x + t * (2 * (1 - t) * (_p1.x - _p0.x) + t * (_p2.x - _p0.x));
		v.y = _p0.y + t * (2 * (1 - t) * (_p1.y - _p0.y) + t * (_p2.y - _p0.y));
		v.z = _p0.z + t * (2 * (1 - t) * (_p1.z - _p0.z) + t * (_p2.z - _p0.z));
		
		return v;
	}
	
	public function get p2():Vector3D 
	{
		return _p2;
	}
	
	public function set p2(value:Vector3D):void 
	{
		_p2 = value;
		length = BezierCurve.getBezierLength(this);
	}
	
	public function get p1():Vector3D 
	{
		return _p1;
	}
	
	public function set p1(value:Vector3D):void 
	{
		_p1 = value;
		length = BezierCurve.getBezierLength(this);
	}
	
	public function get p0():Vector3D 
	{
		return _p0;
	}
	
	public function set p0(value:Vector3D):void 
	{
		_p0 = value;
		length = BezierCurve.getBezierLength(this);
	}
}

internal class Anchor
{
	static private var _mesh:Mesh;
	
	static public function clone():Mesh
	{
		return Mesh(mesh.clone());
	}
	
	static public function get mesh():Mesh 
	{
		if (!_mesh) {
			var material:MaterialBase = new ColorMaterial(0x0066ff);
			_mesh = new Cube(material, 10, 10, 10);
		}
		
		return _mesh;
	}
}

// Class is from away3d-examples-broomstick Github repository
// http://github.com/away3d/away3d-examples-broomstick
internal class HoverDragController
{
	private var _stage : Stage;
	private var _target : Vector3D;
	private var _camera : Camera3D;
	private var _radius : Number = 1000;
	private var _speed : Number = .005;
	private var _dragSmoothing : Number = .1;
	private var _drag : Boolean;
	private var _referenceX : Number = 0;
	private var _referenceY : Number = 0;
	private var _xRad : Number = 0;
	private var _yRad : Number = .5;
	private var _targetXRad : Number = 0;
	private var _targetYRad : Number = .5;
	private var _targetRadius : Number = 1000;

	/**
	 * Creates a HoverDragController object
	 * @param camera The camera to control
	 * @param stage The stage that will be receiving mouse events
	 */
	public function HoverDragController(camera : Camera3D, stage : Stage)
	{
		_stage = stage;
		_target = new Vector3D();
		_camera = camera;

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/**
	 * Amount of "lag" the camera has
	 */
	public function get dragSmoothing() : Number
	{
		return _dragSmoothing;
	}

	public function set dragSmoothing(value : Number) : void
	{
		_dragSmoothing = value;
	}

	/**
	 * The distance of the camera to the target
	 */
	public function get radius() : Number
	{
		return _targetRadius;
	}

	public function set radius(value : Number) : void
	{
		_targetRadius = value;
	}

	/**
	 * The amount by which the camera be moved relative to the mouse movement
	 */
	public function get speed() : Number
	{
		return _speed;
	}

	public function set speed(value : Number) : void
	{
		_speed = value;
	}

	/**
	 * Removes all listeners
	 */
	public function destroy() : void
	{
		_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/**
	 * The center of attention for the camera
	 */
	public function get target() : Vector3D
	{
		return _target;
	}

	public function set target(value : Vector3D) : void
	{
		_target = value;
	}

	/**
	 * Update cam movement towards its target position
	 */
	private function onEnterFrame(event : Event) : void
	{
		if (_drag) updateRotationTarget();

		_radius = _radius + (_targetRadius - _radius)*dragSmoothing;
		_xRad = _xRad + (_targetXRad - _xRad)*dragSmoothing;
		_yRad = _yRad + (_targetYRad - _yRad)*dragSmoothing;

		// simple spherical position based on spherical coordinates
		var cy : Number = Math.cos(_yRad)*_radius;
		_camera.x = _target.x - Math.sin(_xRad)*cy;
		_camera.y = _target.y - Math.sin(_yRad)*_radius;
		_camera.z = _target.z - Math.cos(_xRad)*cy;
		_camera.lookAt(_target);
	}

	/**
	 * If dragging, update the target position's spherical coordinates
	 */
	private function updateRotationTarget() : void
	{
		var mouseX : Number = _stage.mouseX;
		var mouseY : Number = _stage.mouseY;
		var dx : Number = mouseX - _referenceX;
		var dy : Number = mouseY - _referenceY;
		var bound : Number = Math.PI * .5 - .05;

		_referenceX = mouseX;
		_referenceY = mouseY;
		_targetXRad += dx * _speed;
		_targetYRad += dy * _speed;
		if (_targetYRad > bound) _targetYRad = bound;
		else if (_targetYRad < -bound) _targetYRad = -bound;
	}

	/**
	 * Start dragging
	 */
	private function onMouseDown(event : MouseEvent) : void
	{
		_drag = true;
		_referenceX = _stage.mouseX;
		_referenceY = _stage.mouseY;
	}

	/**
	 * Stop dragging
	 */
	private function onMouseUp(event : MouseEvent) : void
	{
		_drag = false;
	}

	/**
	 * Updates camera distance
	 */
	private function onMouseWheel(event:MouseEvent) : void
	{
		_targetRadius -= event.delta*5;
	}


}
