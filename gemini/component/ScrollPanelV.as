package gemini.component 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class ScrollPanelV extends BaseObject
	{
		public var defaultSpeed:Number = 2000;
		
		public var items:Vector.<BaseObject>;
		
		private var _cacheItems:Vector.<BaseObject>;
		private var _numItems:int;
		private var _curIndex:int = 0;
		private var _oldIndex:int = 0;
		private var _length:int;
		
		private var _renderHandler:Function;
		private var _renderClass:Class;
		private var _panelWidth:Number;
		private var _panelHeight:Number;
		private var _paddingX:Number;
		private var _paddingY:Number;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _itemPanel:Sprite;
		private var _mask:Shape;
		private var _targetY:int;
		private var _speed:Number;
		private var _row:int;
		private var _column:int;
		private var _moveDistance:Number = 0;
		private var _totalHeight:Number;
		private var _realRow:int;
		private var _disable:Boolean;
		private var _tileHeight:Number;
		
		public function ScrollPanelV(skin:*) 
		{
			super(skin, true);
		}
		
		public function set renderClass(v:Class):void
		{
			_renderClass = v;
			items = new Vector.<CoreObject>();
			_itemPanel = new Sprite();
			addChild(_itemPanel);
			initItems();
		}
		
		private function initItems():void
		{
			var item:MovieClip;
			var i:int;
			var length:int;
			
			for (i = 0; (item = getChildMovieClip("item" + i)) != null; i++)
			{
				var renderItem:CoreObject;
				renderItem = new _renderClass(item)
				items.push(renderItem);
				_itemPanel.addChild(renderItem);
			}
			
			_numItems = items.length;
			
			item = items[0].content;
			for (i = 1; i < _numItems; i++)
			{
				if (item.y != items[i].y)
				{
					_column = i ;
					break;
				}
			}
			if (_column == 0)
				_column = 1;
			_row = Math.ceil(_numItems / _column);
			
			_itemWidth = items[0].width;
			_itemHeight = items[0].height;
			var lastY:Number = items[items.length - 1].y;
			
			if (_numItems > 1)
			{
				if(_column > 1)
					_paddingX = ((items[_column - 1].x - items[0].x - _itemWidth * (_column - 1)) / (_column - 1));
				else 
					_paddingX = 0;
				if (_row > 1)
					_paddingY = ((items[_numItems - 1].y - items[0].y - _itemHeight * (_row - 1)) / (_row - 1));
				else
					_paddingY = 0;
			}
			else
			{
				_paddingX = 0
				_paddingY = 0;
			}
			_tileHeight = _itemHeight + _paddingY;
			_panelHeight = (_tileHeight) * _row;
			
			_cacheItems = new Vector.<CoreObject>();
			
			var addedItem:CoreObject;
			
			for (i = 0; i < _column; i++)
			{
				
				addedItem = new _renderClass();
				addedItem.x = i * (_itemWidth + _paddingX);
				addedItem.y =  -(_tileHeight);
				items.unshift(addedItem);
				_itemPanel.addChild(addedItem);

			}
			
			for (i = 0; i < _column; i++)
			{
				addedItem = new _renderClass();
				addedItem.x = i * (_itemWidth + _paddingX);
				addedItem.y =  lastY + (_tileHeight);
				items.push(addedItem);
				_itemPanel.addChild(addedItem);
			}
			
			
			_mask = new Shape();
			_mask.graphics.beginFill(0x00ffff, 0.1);
			_mask.graphics.drawRect(-_paddingX *0.5, -_paddingY * 0.5, (_itemWidth + _paddingX) * _column, (_tileHeight) * _row);
			_mask.x = item.x;
			_mask.y = item.y;
			addChild(_mask);
			_itemPanel.mask = _mask;
			//defaultSpeed = (_tileHeight) * 0.778;
		}
		
		public function get length():int 
		{
			return _length;
		}
		
		public function set length(v:int):void 
		{
			reset();
			_length = v;
			_realRow = Math.ceil(_length / _column);
			if (_realRow > _row)
			{
				_totalHeight = (_realRow - _row) * (_tileHeight);
				tickEnable = true;
			}
			else
			{
				_totalHeight = 0;
			}
			index = 0;
			
		}
		
		public function get index():int
		{
			return _curIndex;
		}
		
		public function set position(v:Number):void
		{
			//var realY:Number = -_totalHeight * v;
			//var index:int = getIndexByY(realY);
			//_targetY = -index * _tileHeight;
			_targetY = -_totalHeight * v;
			
		}
		public function set index(v:int):void
		{
			if (v < 0)
				v = 0;
			if (_curIndex != v)
			{
				_oldIndex = _curIndex;
				_curIndex = v;
				
				setupItems();
				
			}
			for (var i:int = 0; i < _numItems + 2 * _column; i++)
			{
				var tempIndex:int = (_curIndex - 1) * _column + i;
				if(tempIndex >= 0)
					render(items[i], tempIndex);
			}
		}
		
		public function getIndexByY(yPos:Number):int
		{
			var index:int = -int(yPos / (_tileHeight));
			if (index <= 0)
				index = 0;
			else if (index > _realRow - _row)
			{
				index = _realRow - _row;
			}
			return index;
		}
		
		public function set renderHandler(v:Function):void
		{
			_renderHandler = v;
		}
		
		public function get disable():Boolean 
		{
			return _disable;
		}
		
		public function set disable(value:Boolean):void 
		{
			if (_disable != value)
			{
				_disable = value;
				_itemPanel.mouseChildren = !_disable;
				_itemPanel.mouseEnabled = !_disable;
			}
		}
		
		public function get speed():Number 
		{
			return defaultSpeed;
		}
		
		public function set speed(value:Number):void 
		{
			if (defaultSpeed != value)
			{
				defaultSpeed = value;
			}
		}
		
		private function setupItems():void
		{
			var offsetIndex:int = _curIndex - _oldIndex;
			//if (offsetIndex > 0)
			//{
				//for ( ; offsetIndex > 0; offsetIndex--)
				//{
					//pushItem();
				//}
			//}
			//else if (offsetIndex < 0)
			//{
				//for (; offsetIndex < 0; offsetIndex++)
				//{
					//unShiftItem();
				//}
			//}
			if (offsetIndex == 1)
			{
				pushItem();
			}
			else if (offsetIndex == -1)
			{
				unShiftItem();
			}
			else
			{
				for (var i:int = 0; i < items.length; i++)
				{
					items[i].y = (_curIndex - 1 + int(i / _column)) * (_tileHeight);
				}
			}
		}
		
		private function pushItem():void
		{
			var i:int;
			var item:CoreObject;
			var lastY:Number = items[items.length - 1].y;
			
			for (i = 0; i < _column; i++)
			{
				item = items.shift();
				item.x = i * (_itemWidth + _paddingX);
				item.y = lastY + (_tileHeight);
				items.push(item);
			}
			
		}		
		
		private function unShiftItem():void
		{
			var i:int;
			var item:CoreObject;
			var firstY:Number = items[0].y;
			
			for (i = 0; i < _column; i++)
			{
				item = items.pop();
				item.y = firstY - (_tileHeight);
				items.unshift(item);
			}
		}
		
		private function render(item:CoreObject, index:int):void 
		{
			if (index < _length) {
				item.visible = true;
				if (_renderHandler != null){
					_renderHandler(index, item);
				}
			}else {
				item.visible = false;
			}
		}
		
		public function reset():void
		{
			tickEnable = false;
			_itemPanel.y = 0;
			_targetY = 0;
			//_curIndex = 0;
			_length = 0;
			index = 0;
			//for (var i:int = 0; i < _numItems; i++)
			//{
				//items[i].x = int( i % _column) * (_itemWidth + _paddingX);
				//items[i].y = int(i / _column) * (_tileHeight);
			//}
		}
		
		
		override public function tick(intervalTime:uint):void 
		{
			if (_itemPanel.y == _targetY)
				return;
			if (_itemPanel.y > _targetY)
			{
				_speed = -defaultSpeed;
			}
			else 
			{
				_speed = defaultSpeed;
			}
			_moveDistance += _speed;
			_itemPanel.y += _speed;
			
			disable = true;

			
			if (_speed > 0 && _itemPanel.y >= _targetY || _speed < 0 && _itemPanel.y <= _targetY)
			{
				_itemPanel.y = _targetY;
				_moveDistance = _targetY;
				_speed = 0;
				disable = false;
			}
			
			var absMoveDistance:Number = _moveDistance >= 0 ? _moveDistance : -_moveDistance;

			if (absMoveDistance >= (_tileHeight) || absMoveDistance == 0)
			{
				index = getIndexByY(_itemPanel.y);
			}
		}
	}

}