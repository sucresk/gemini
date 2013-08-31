package gemini.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gemini.data.FunctionObject;
	import gemini.manager.FontsManager;
	/**
	 * ...
	 * @author sucre
	 */
	public class BaseList extends BaseObject
	{
		public var items:Vector.<BaseObject>;
		
		
		private var _numItems:int;
		private var _curIndex:int;
		private var _length:int;
		private var _curPage:int = 0;
		
		private var _btnPrevPage:Button;
		private var _btnNextPage:Button;
		private var _btnPrev:Button;
		private var _btnNext:Button;
		private var _renderHandler:Function;
		private var _selectedHandler:Function;
		private var _renderClass:Class;
		private var _totalPage:int;
		private var _txtPage:TextField;
		private var _position:Number;
		private var _selectedIndex:int = 0;
		
		private var _selectable:Boolean;
		
		public function BaseList(skin:*, renderClass:Class = null) 
		{
			super(skin);
				
			if (renderClass != null)
			{
				this.renderClass = renderClass;
			}
			
		}
		
		public function get renderClass():Class 
		{
			return _renderClass;
		}
		
		public function set renderClass(value:Class):void 
		{
			_renderClass = value;
			initItems();
		}
		
		private function initItems():void
		{
			items = new Vector.<BaseObject>();
			var item:MovieClip;
			for (var i:int = 0; (item = getChildMovieClipInstance("item" + i)) != null; i++)
			{
				items.push(new _renderClass(item));
			}
			_numItems = items.length;
			if (_selectable)
			{
				_selectable = false;
				selectable = true;
			}
			var btn:MovieClip = getChildMovieClipInstance("btnPrevPage");
			if (btn != null)
			{
				_btnPrevPage = new Button(btn);
				_btnPrevPage.clickHandler = new FunctionObject(scroll, [-_numItems]);
			}
			btn = getChildMovieClipInstance("btnNextPage");
			if (btn != null)
			{
				_btnNextPage = new Button(btn);
				_btnNextPage.clickHandler = new FunctionObject(scroll, [_numItems]);
			}
			btn = getChildMovieClipInstance("btnPrev");
			if (btn != null)
			{
				_btnPrev = new Button(btn);
				_btnPrev.clickHandler = new FunctionObject(scroll, [-1]);
			}
			btn = getChildMovieClipInstance("btnNext");
			if (btn != null)
			{
				_btnNext = new Button(btn);
				_btnNext.clickHandler = new FunctionObject(scroll, [1]);
			}
			btn = null;
			_txtPage = getChildTextFieldInstance("txtPage");
			if(_txtPage != null)
				FontsManager.setStrictSized(_txtPage);
				
			index = 0;
		}
		
		public function set renderHandler(v:Function):void
		{
			_renderHandler = v;
		}
		
		public function get index():int
		{
			return _curIndex;
		}
		public function set index(v:int):void
		{
			if (_curIndex != v)
			{
				if (v < 0)
					v = 0;
				_curIndex = v;
				_curPage = Math.max(Math.ceil((v + 1) / _numItems), 1);
				
				refresh();
			}
		}
		public function get length():int 
		{
			return _length;
		}
		
		public function set length(v:int):void 
		{
			_length = v;
			_totalPage = Math.ceil(_length / _numItems);
			refresh();
		}
		
		public function get position():Number 
		{
			return _position;
		}
		
		public function set position(value:Number):void 
		{
			_position = value;
			if (_length > _numItems)
			{
				index = int(_position * (_length - _numItems));
			}
			else
			{
				index = 0;
			}
		}
		
		public function get selectable():Boolean 
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void 
		{
			if (_selectable != value)
			{
				_selectable = value;
				
				for (var i:int = 0, len:int = items.length; i < len; i++)
				{
					if (_selectable)
					{
						items[i].addEventListener(MouseEvent.CLICK, clickHandler);
					}
					else
					{
						items[i].removeEventListener(MouseEvent.CLICK, clickHandler);
					}
				}
			}
			
		}
		
		public function get selectedIndex():int 
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void 
		{
			if (_selectedIndex != value)
			{
				
				if (_selectedIndex >= _curIndex && _selectedIndex < _curIndex + _numItems)
				{
					items[_selectedIndex - _curIndex]["selected"] = false;
				}
				_selectedIndex = value;
				if (_selectedIndex >= _curIndex && _selectedIndex < _curIndex + _numItems)
				{
					items[_selectedIndex - _curIndex]["selected"] = true;
				}
				if (_selectedHandler != null)
				{
					_selectedHandler(_selectedIndex);
				}
			}
			
		}
		
		/**
		 * 不触发回调
		 * @param	value
		 */
		public function setIndex(value:int):void 
		{
			if (_selectedIndex != value)
			{
				if (_selectedIndex >= _curIndex && _selectedIndex < _curIndex + _numItems)
				{
					items[_selectedIndex - _curIndex]["selected"] = false;
				}
				_selectedIndex = value;
				if (_selectedIndex >= _curIndex && _selectedIndex < _curIndex + _numItems)
				{
					items[_selectedIndex - _curIndex]["selected"] = true;
				}
			}
			
		}
		
		public function set selectedHandler(value:Function):void 
		{
			_selectedHandler = value;
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var target:BaseObject = e.currentTarget as BaseObject;
			var index:int;
			if (target)
			{
				index = items.indexOf(target);
				if (index != -1)
				{
					selectedIndex = _curIndex + index;
				}
			}
		}
		
		private function render(item:BaseObject, index:int):void {
			if (index < _length) {
				item.visible = true;
				if (_renderHandler != null){
					_renderHandler(item, index);
				}
				_curPage = Math.max(Math.ceil((index +1) / _numItems),1);
			}else {
				item.visible = false;
			}
		}
		
		private function scroll(change:int):void {
			index += change;
		}
		
		public function refresh():void
		{
			for (var i:int = 0; i < _numItems; i++)
			{
				render(items[i], _curIndex + i);
				if (_selectable)
				{
					items[i]["selected"] = _selectedIndex == _curIndex + i;
				}
			}
			if (_btnPrevPage != null) 
			{
				_btnPrevPage.disable = (_curIndex == 0);
			}
			if (_btnNextPage != null) 
			{
				_btnNextPage.disable = (_curIndex + _numItems >= _length);
			}
			if (_btnPrev != null)
			{
				_btnPrev.disable = _curIndex <= 0;
			}
			if (_btnNext != null)
			{
				_btnNext.disable = _curIndex >= (_length - _numItems);
			}
			if (_txtPage != null)
			{
				_txtPage.text = _curPage + "/" + _totalPage;
			}
		}
		
		override public function destroy():void 
		{
			if (_selectable)
			{
				selectable = false;
			}
			super.destroy();
		}
	}

}