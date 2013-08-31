package gemini.component 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class ScrollListV extends BaseObject
	{
		private var _activeItems:Vector.<BaseObject>;
		private var _inactiveItems:Vector.<BaseObject>;
		
		private var _selectedHandler:Function;
		
		private var _renderClass:Class;
		private var _row:int;
		private var _renderWidth:int;
		private var _renderHeight:int;
		private var _showRect:Rectangle;
		private var _numPrePage:int;
		private var _showNum:int;
		
		private var _curIndex:int;
		private var _listContainer:BaseObject;
		private var _maxHeight:int;
		private var _data:Array;
		private var _length:int;
		private var _position:Number;
		private var _enableMouseWheel:Boolean;
		private var _curY:int;
		
		public var slider:SliderV;
		
		public function ScrollListV(skin:* = null,interactive:Boolean = true, autoBuild:Boolean = false, buildLayer:int = 1) 
		{
			super(skin, interactive, autoBuild, buildLayer);
			if (!autoBuild)
			{
				slider = new SliderV(getChildMovieClipInstance("slider"));
			}
			_listContainer = new BaseObject();
			addObject(_listContainer);
			_activeItems = new Vector.<BaseObject>();
		}
		
		public function setRender(renderClass:Class, row:int, showRect:Rectangle = null, renderWidth:int = NaN, renderHeight:int = NaN):void
		{
			_renderClass = renderClass;
			_row = row;
			if (showRect == null)
			{
				showRect = new Rectangle(0, 0, content.width, content.height);
			}
			_showRect = showRect;
			if ((renderWidth <= 0 ) || (renderHeight <= 0))
			{
				var helpItem:BaseObject = new _renderClass();
				renderWidth = helpItem.width;
				renderHeight = helpItem.height;
			}
			_renderWidth = renderWidth;
			_renderHeight = renderHeight;
			
			_numPrePage = (Math.ceil(showRect.height / _renderHeight) + 1) * _row;
			_showNum = (int(showRect.height / _renderHeight)) * _row;
			
			for (var i:int = 0; i < _numPrePage; i++)
			{
				_activeItems.push(new _renderClass());
				_listContainer.addObject(_activeItems[_activeItems.length - 1]);
			}
			_listContainer.scrollRect = _showRect;
			if (slider)
			{
				slider.bindObj(this, "position");
			}
		}
		
		override public function set userData(value:Object):void 
		{
			_userData = value;
			_data = _userData as Array;
			_length = _data.length;
			_maxHeight = Math.ceil(_data.length / _row) * _renderHeight - _showRect.height;
			reset();
			if (slider)
			{
				slider.setRange(_showNum, _data.length);
			}
			render();
		}
		
		public function get position():Number 
		{
			return _position;
		}
		
		public function set position(value:Number):void 
		{
			_position = value;
			_curY = int(_position * _maxHeight);
			render();
		}
		
		public function get enableMouseWheel():Boolean 
		{
			return _enableMouseWheel;
		}
		
		public function set enableMouseWheel(value:Boolean):void 
		{
			_enableMouseWheel = value;
			if (slider)
				slider.enableMouseWheel = _enableMouseWheel;
		}
		
		public function reset():void
		{
			_position = 0;
			_listContainer.y = 0;
			_curY = 0;
			if (slider)
				slider.reset();
		}
		
		public function refresh():void
		{
			render();
		}
		
		private function render():void
		{
			_curIndex = int(_curY / _renderHeight) * _row;
			for (var i:int = 0; i < _numPrePage; i++)
			{
				_activeItems[i].x = getIndexPosX(_curIndex + i);
				_activeItems[i].y = getIndexPosY(_curIndex + i);
				if (_length <= _curIndex + i)
				{
					_activeItems[i].visible = false;
				}
				else
				{
					_activeItems[i].visible = true;
					_activeItems[i].userData = userData[_curIndex + i];
				}
			}
		}
		
		private function getIndexPosX(index:int):int
		{
			return int(index % _row) * _renderWidth;
		}
		private function getIndexPosY(index:int):int
		{
			return int(index / _row) * _renderHeight - _curY;
		}
	}

}