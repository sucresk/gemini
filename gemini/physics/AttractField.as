package gemini.physics 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author gemini
	 */
	public class AttractField implements IForceField
	{
		
		private var _centerX:Number;
		private var _centerY:Number;
		private var _power:Number;
		private var _radius:Number;
		private var _center:Point;
		
		public function AttractField(centerX:Number, centerY:Number, power:Number = 1.0, radius:Number = 0) 
		{
			_centerX = centerX;
			_centerY = centerY;
			_power = power;
			_radius = radius;
			_center = new Point(_centerX, _centerY);
		}
		
		/* INTERFACE gemini.physics.IForceField */
		
		public function setCenter(centerX:Number, centerY:Number):void
		{
			_centerX = centerX;
			_centerY = centerY;
			_center = new Point(_centerX, _centerY);
		}
		
		public function apply(obj:PhysicsObject):void 
		{
			var offest:Point = _center.subtract(new Point(obj.x,obj.y));
			var len:Number = offest.length;
			if (_radius != 0)
				offest.normalize(len - _radius);
			
			obj.velocity.x += 1 / len * offest.x * _power;
			obj.velocity.y += 1 / len * offest.y * _power;
		}
		
	}

}