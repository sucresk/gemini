package iso 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoScene extends IsoContainer
	{
		private var _container:Sprite = new Sprite();
		private var _hostContainer:DisplayObjectContainer;
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		public function IsoScene() 
		{
			
		}
		//setter and getter
		override public function get x():Number 
		{ 
			return _x;
		}
		
		override public function set x(value:Number):void 
		{
			if (_x != value)
			{
				_x = value;
				_container.x = _x;
			}
		}
		
		override public function get y():Number 
		{ 
			return _y;
		}
		
		override public function set y(value:Number):void 
		{
			if (_y != value)
			{
				_y = value;
				_container.y = _y;
			}
		}
		
		public function get hostContainer():DisplayObjectContainer
		{
			return _hostContainer;
		}
		
		public function set hostContainer(v:DisplayObjectContainer):void
		{
			if (_hostContainer != v)
			{
				_hostContainer = v;
				_hostContainer.addChild(_container);
				_hostContainer.cacheAsBitmap = true;
			}
		}
		
		override public function get container():DisplayObjectContainer 
		{ 
			return _container;
		}
		
		override public function addObject(node:IisoObject):void 
		{
			super.addObject(node);
			
			_container.addChildAt(node.container, getObjectIndex(node));
		}
		
		override public function addObjectAt(node:IisoObject, index:int):void 
		{
			super.addObjectAt(node, index);
			_container.addChildAt(node.container, index);
		}
		
		override public function setObjectIndex(node:IisoObject, index:int):void 
		{
			super.setObjectIndex(node, index);
			_container.addChildAt(node.container, index);
		}
		
		override public function removeObject(node:IisoObject):void 
		{
			if (super.removeObjectAt(getObjectIndex(node)) != null)
				_container.removeChild(node.container);
		}
		
		override public function removeObjectAt(index:int):IisoObject 
		{
			var removeObject:IisoObject = super.removeObjectAt(index);
			if (removeObject != null)
				_container.removeChild(removeObject.container);
			return removeObject;
		}
		
		override public function removeObjectById(id:int):IisoObject 
		{
			var removeObject:IisoObject =  super.removeObjectById(id);
			if (removeObject != null)
				_container.removeChild(removeObject.container);
			return removeObject;
		}
		
		override public function removeAllObjects():void 
		{
			super.removeAllObjects();
			while (_container.numChildren > 0)
				_container.removeChildAt(0);
		}
		
		override public function resetObject(node:IisoObject):void 
		{
			super.resetObject(node);
			_container.setChildIndex(node.container, getObjectIndex(node));
		}
		
		override public function render():void 
		{
			for ( var i:int = 0; i < numChildren; i++)
			{
				if (IisoObject(children[i]).IsInvalidated)
					IisoObject(children[i]).render();
			}
		}
		
		override public function destory():void 
		{
			super.destory();
			if (_hostContainer != null)
			{
				if (_hostContainer.contains(_container))
					_hostContainer.removeChild(_container);
					
				_hostContainer = null;
			}
		}
	}

}