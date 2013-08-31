package gemini.physics 
{
	import flash.geom.Point;
	import gemini.component.BaseObject;
	import gemini.component.ITick;
	import gemini.manager.TickManager;
	/**
	 * ...
	 * @author gemini
	 */
	public class PhysicsObject implements ITick
	{
		public var skin:BaseObject;
		
		public var velocity:Point = new Point();
		public var acceleration:Point;
		public var gravity:Point;
		public var spin:Number = 0;
		public var scaleSpeed:Number = 0;
		public var friction:Number = 1;
		public var spinFriction:Number = 1;
		public var scaleFriction:Number = 1;
		public var x:Number = 0;
		public var y:Number = 0;
		public var rotation:Number = 0;
		public var scale:Number = 1;
		
		private var _pause:Boolean;
		private var _tickEnable:Boolean;
		private var _d:Number;
		
		public function PhysicsObject(skin:BaseObject) 
		{
			this.skin = skin;
		}
		
		public function pause():void
		{
			_pause = true;
		}
		
		public function play():void
		{
			_pause = false;
		}
		
		public function destory():void
		{
			tickEnable = false;
			if (skin != null)
			{
				skin.destroy();
				skin = null;
			}
		}
		/* INTERFACE gemini.component.ITick */
		
		public function set tickEnable(value:Boolean):void 
		{
			if (_tickEnable == value)
				return;
			_tickEnable = value;
			if (_tickEnable)
			{
				TickManager.instance.registerTick(this);
			}
			else
			{
				TickManager.instance.unRegisterTick(this);
			}
		}
		
		public function tick(intervalTime:uint):void 
		{
			if (_pause)	return;
			
			_d = intervalTime / 1000;
			
			
			if (acceleration)
			{
				velocity.x += acceleration.x * _d;
				velocity.y += acceleration.y * _d;
			}
			if (gravity)
			{
				velocity.x += gravity.x * _d;
				velocity.y += gravity.y * _d;
			}
			if (friction != 1)
			{
				velocity.x *= friction;
				velocity.y *= friction;
			}
			
			if (spin)
				rotation += spin;
			
			if (spinFriction != 1)
				spin *= spinFriction;
			
			if (scaleSpeed)
				scale += scaleSpeed;
			
			if (scaleFriction != 1)
				scaleSpeed *= scaleFriction;
			
			x += velocity.x * _d * scale;
			y += velocity.y * _d * scale;
			
			if (skin != null)
			{
				skin.x = x;
				skin.y = y;
				skin.rotation = rotation;
				if(scale != 1)
					skin.scale = scale;
			}
		}
		
	}

}