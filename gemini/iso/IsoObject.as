package gemini.iso 
{
	import flash.display.DisplayObjectContainer;
	import gemini.iso.IisoObject;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoObject implements IisoObject
	{
		private static var _idCount:uint = 0;
		
		public const UID:uint = _idCount++;
		
		public var autoRender:Boolean;
		
		protected var _bPositionInvalidated:Boolean;
		protected var _bDepthInvalidated:Boolean;
		
		private var _id:int = -1;
		private var _data:*;
		private var _owner:IisoScene;
		private var _isoX:Number;
		private var _isoY:Number;
		private var _isoZ:Number;
		private var _length:uint;
		private var _width:uint;
		private var _height:uint;
		private var _drawPriority:int = int.MAX_VALUE;
		
		public function IsoObject() 
		{
			
		}
		
		/* INTERFACE gemini.iso.IisoObject */
		
		public function get id():int 
		{
			if (_id < 0) 
				return UID;
			else
				return _id;
		}
		
		public function set id(v:int):void 
		{
			_id = v;
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(v:Object):void 
		{
			_data = v;
		}
		
		public function get owner():IisoScene 
		{
			return _owner;
		}
		
		public function set owner(v:IisoScene):void
		{
			_owner = v;
		}
		public function get hasOwner():Boolean 
		{
			return _owner != null;
		}
		
		public function get IsInvalidated():Boolean 
		{
			return _bPositionInvalidated || _bDepthInvalidated;
		}
		
		public function render():void 
		{
			_bDepthInvalidated = false;
			_bPositionInvalidated = false;
		}
		
		public function moveTo(x:Number, y:Number, z:Number):void 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function moveBy(x:Number, y:Number, z:Number):void 
		{
			this.x += x;
			this.y += y;
			this.z += z;
		}
		
		public function set x(v:Number):void 
		{
			if (_isoX != v)
			{
				_bPositionInvalidated = true;
				_isoX = v;
				setDrawPriority();
			}
		}
		
		public function get x():Number 
		{
			return _isoX;
		}
		
		public function set y(v:Number):void 
		{
			if (_isoY != v)
			{
				_bPositionInvalidated = true;
				_isoY = v;
				setDrawPriority();
			}
		}
		
		public function get y():Number 
		{
			return _isoY;
		}
		
		public function set z(v:Number):void 
		{
			if (_isoZ != v)
			{
				_bPositionInvalidated = true;
				_isoZ = v;
				setDrawPriority();
			}
		}
		
		public function get z():Number 
		{
			return _isoZ;
		}
		
		public function get screenX():Number 
		{
			return IsoMath.isoToScreen(new IsoPoint(x, y, z)).x;
		}
		
		public function get screenY():Number 
		{
			return IsoMath.isoToScreen(new IsoPoint(x, y, z)).y;
		}
		
		public function get depth():Number 
		{
			return IsoMath.getDepth(x, y, z);
		}
		
		public function get drawPriority():int
		{
			if (_drawPriority != int.MAX_VALUE)
				return _drawPriority;
			else 
				return int(depth);
		}
		
		public function set drawPriority(v:int):void
		{
			if (_drawPriority != v)
			{
				_drawPriority = v;
				_bDepthInvalidated = true;
				if (autoRender)
					render();
			}
		}
		
		public function setDrawPriority():void
		{
			drawPriority = int(depth);
		}
		
		public function setSize(length:uint, width:uint, heigh:uint):void 
		{
			this.length = length;
			this.width = width;
			this.height = height;
		}
		
		public function get length():uint 
		{
			return _height;
		}
		
		public function set length(v:uint):void 
		{
			_length = v;
		}
		
		public function get width():uint 
		{
			return _width;
		}
		
		public function set width(v:uint):void 
		{
			_width = v;
		}
		
		public function get height():uint 
		{
			return _height;
		}
		
		public function set height(v:uint):void 
		{
			_height = v;
		}
		
		public function get container():DisplayObjectContainer
		{
			return null;
		}
		
		public function clone():IisoObject 
		{
			var cloneObject:IsoObject = new IsoObject();
			cloneObject.id = this.id;
			cloneObject.data = this.data;
			cloneObject.x = this.x;
			cloneObject.y = this.y;
			cloneObject.z = this.z;
			cloneObject.length = this.length;
			cloneObject.width = this.width;
			cloneObject.height = this.height;
			return cloneObject;
		}
		
		public function destory():void
		{
			_owner = null;
			_data = null;
			_id = -1;
		}
		
		public function tick(interval:uint):void
		{
			
		}
	}

}