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
	public class PhysicsScene implements ITick
	{
		private var _width:int;
		private var _height:int;
		private var _scene:BaseObject;
		
		public var gravity:Point;
		
		private var _objs:Vector.<PhysicsObject>;
		private var _newObjs:Vector.<PhysicsObject>;
		
		private var _tickEnable:Boolean;
		private var _autoRemove:Boolean;
		private var _pause:Boolean;
		private var _fields:Vector.<IForceField>;
		
		public function PhysicsScene(width:int, height:int, gravity:Point, container:BaseObject, autoRemove:Boolean = true) 
		{
			_width = width;
			_height = height;
			_objs = new Vector.<PhysicsObject>();
			_newObjs = new Vector.<PhysicsObject>();
			_scene = container;
			this.gravity = gravity;
			_autoRemove = autoRemove;
			tickEnable = true;
		}
		
		public function addObject(obj:PhysicsObject):void
		{
			if (gravity != null)
			{
				obj.gravity = gravity;
			}
			_objs.push(obj);
			if (_scene != null && obj.skin != null)
			{
				_scene.addObject(obj.skin);
			}
			obj.tickEnable = true;
		}
		
		public function removeObject(obj:PhysicsObject):void
		{
			obj.tickEnable = false;
			var index:int = _objs.indexOf(obj);
			if (index != -1)
			{
				_objs.splice(index, 1);
				if (_scene != null && obj.skin != null)
				{
					_scene.removeObject(obj.skin);
				}
			}
		}
		
		public function addField(field:IForceField):void
		{
			if (_fields == null)
				_fields = new Vector.<IForceField>();
			_fields.push(field);
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
		
		public function get pause():Boolean 
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void 
		{
			if (_pause != value)
			{
				_pause = value;
				for (var i:int, len:int = _objs.length; i < len; i++)
				{
					var obj:PhysicsObject = _objs[i];
					if (_pause)
						obj.pause();
					else
						obj.play();
				}
			}
			
		}
		
		public function destory():void
		{
			for (var i:int, len:int = _objs.length; i < len; i++)
			{
				var obj:PhysicsObject = _objs[i];
				if (_scene != null && obj.skin != null)
				{
					_scene.removeObject(obj.skin);
				}
				obj.destory();
			}
			_objs = new Vector.<PhysicsObject>();
			_newObjs = new Vector.<PhysicsObject>();
			_scene = null;
			tickEnable = false;
		}
		
		public function tick(intervalTime:uint):void 
		{
			for (var i:int = 0, len:int = _newObjs.length; i < len; i++)
			{
				var obj:PhysicsObject = _newObjs[i];
				if (_autoRemove)
				{
					if (obj.x <0||obj.x > _width ||obj.y < 0 ||obj.y > _height)
					{
						removeObject(obj);
					}
				}
				if (_fields != null && _fields.length > 0)
				{
					for (var j:int = 0, len0:int = _fields.length; j < len0; j++)
					{
						_fields[j].apply(obj);
					}
				}
			}
			_newObjs = _objs.slice();
		}
	}

}