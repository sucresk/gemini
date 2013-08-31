package gemini.iso 
{
	import gemini.iso.IisoObject;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoContainer extends IsoObject implements IisoScene
	{
		private var _childrenArr:Vector.<IisoObject> = new Vector.<IisoObject>();
		
		public function IsoContainer() 
		{
			
		}
		
		/* INTERFACE gemini.iso.IisoScene */
		
		public function contains(node:IisoObject):Boolean 
		{
			return getObjectById(node.id) != null;
		}
		
		public function get children():Array 
		{
			var temp:Array = [];
			var child:IisoObject;
			
			for each ( child in _childrenArr )
				temp.push( child );
			
			return temp;
		}
		
		public function get numChildren():uint 
		{
			return _childrenArr.length;
		}
		
		public function addObject(node:IisoObject):void 
		{
			if (node != null)
			{
				if (getObjectById(node.id) != null)
					return;
				var added:Boolean = false;
				for ( var i:int = 0, length:int = numChildren; i < length; i++)
				{
					if (_childrenArr[i].drawPriority > node.drawPriority)
					{
						_childrenArr.splice(i, 0, node);
						added = true;
						break;
					}
				}
				if (!added)
					_childrenArr.push(node);
				node.owner = this;
			}
		}
		
		public function addObjectAt(node:IisoObject, index:int):void 
		{
			if (node != null)
			{
				if (getObjectById(node.id) != null)
					return;
				_childrenArr.splice(index, 0, node);
				node.owner = this;
			}
			
		}
		
		public function resetObject(node:IisoObject):void
		{
			removeObject(node);
			addObject(node);
		}
		
		public function getObjectIndex(node:IisoObject):int 
		{
			for ( var i:int = 0, length:int = numChildren; i < length; i++)
			{
				if (_childrenArr[i] == node)
				{
					return i;
					break;
				}
			}
			return -1;
		}
		
		public function getObjectAt(index:int):IisoObject 
		{
			if (index > numChildren - 1)
				return null;
			return _childrenArr[index];
		}
		
		public function getObjectById(id:int):IisoObject 
		{
			//TODO: optimize by dichotomy
			for ( var i:int = 0, length:int = numChildren; i < length; i++)
			{
				if (_childrenArr[i].id == id)
				{
					return _childrenArr[i];
					break;
				}
			}
			return null;
		}
		
		public function setObjectIndex(node:IisoObject, index:int):void 
		{
			var curIndex:int = getObjectIndex(node);
			if (index == curIndex)
				return;
			else if ( curIndex >= 0)
			{
				_childrenArr.splice(curIndex, 1);
				if (index >= numChildren)
					_childrenArr.push(node);
				else
					_childrenArr.splice(index, 0, node);
			}
		}
		
		public function removeObject(node:IisoObject):void 
		{
			removeObjectAt(getObjectIndex(node));
		}
		
		public function removeObjectAt(index:int):IisoObject 
		{
			if (index >= numChildren || index < 0)
				return null;
			else
			{
				var child:IisoObject = _childrenArr[index];
				_childrenArr.splice(index, 1);
				child.owner = null;
				return child;
			}
		}
		
		public function removeObjectById(id:int):IisoObject 
		{
			var child:IisoObject = getObjectById(id);
			if (child != null)
			{
				removeObject(child);
				return child;
			}
			else
				return null;
		}
		
		public function removeAllObjects():void 
		{
			for ( var i:int = 0, length:int = numChildren; i < length; i++)
			{
				_childrenArr[i].owner = null;
			}
			_childrenArr = new Vector.<IisoObject>();
		}
		
		override public function destory():void
		{
			super.destory();
			this.removeAllObjects();
		}
		
		override public function tick(interval:uint):void
		{
			for (var i:int = 0, length:int = numChildren; i < length; i++)
			{
				_childrenArr[i].tick(interval);
			}
		}
	}

}