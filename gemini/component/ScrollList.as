package gemini.component 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author sucre
	 */
	public class ScrollList extends BaseObject
	{
		public var items:Vector.<BaseObject>;
		
		private var _cacheItems:Vector.<BaseObject>;
		private var _numItems:int;
		private var _curIndex:int;
		private var _oldIndex:int;
		private var _length:int;
		private var _curPage:int = 1;
		
		private var _btnPrevPage:Button;
		private var _btnNextPage:Button;
		private var _btnPrev:Button;
		private var _btnNext:Button;
		private var _renderHandler:Function;
		private var _renderClass:Class;
		private var _totalPage:int;
		private var _panelWidth:Number;
		private var _padding:Number;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _itemPanel:Sprite;
		private var _mask:Shape;
		
		public function ScrollList(skin:*, renderClass:Class) 
		{
			super(skin);
			_renderClass = renderClass;
			items = new Vector.<BaseObject>();
			_itemPanel = new Sprite();
			addChild(_itemPanel);
			initItems();
		}
		
		private function initItems():void
		{
			var item:MovieClip;
			for (var i:int = 0; (item = getChildMovieClipInstance("item" + i)) != null; i++)
			{
				var renderItem:BaseObject;
				renderItem = new _renderClass(item)
				items.push(renderItem);
				_itemPanel.addChild(renderItem);
			}
			_numItems = items.length;
			
			_cacheItems = new Vector.<BaseObject>(_numItems);
			for (i = 0; i < _numItems; i++)
			{
				_cacheItems[i] = new _renderClass();
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
			_oldIndex = 0;
			index = 0;
			_itemWidth = items[0].width;
			_itemHeight = items[0].height;
			if(_numItems > 1)
				_padding = (items[items.length - 1].x - items[0].x - _itemWidth * (_numItems - 1)) / (_numItems - 1);
			else
				_padding = 0;
			_panelWidth = (_itemWidth + _padding) * _numItems;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0, 0, (_itemWidth + _padding) * _numItems - _padding + 2, _itemHeight);
			_mask.x = items[0].x;
			_mask.y = items[0].y;
			addChild(_mask);
			_itemPanel.mask = _mask;
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
				_curIndex = v;
				if (v < 0)
					v = 0;
				_curPage = int(v / _numItems);
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
			//totalPage = ((_length % _numItems) == 0 ? _length / _numItems : (_length / _numItems + 1));
			_totalPage = Math.ceil(_length / _numItems);
			refresh();
		}
		
		private function render(item:BaseObject, index:int):void {
			if (index < _length) {
				item.visible = true;
				if (_renderHandler != null){
					_renderHandler(item, index);
				}
			}else {
				item.visible = false;
			}
		}
		
		private function scroll(change:int):void {
			index += change;
		}
		
		public function refresh():void
		{
			setupItems();
			for (var i:int = 0; i < _numItems; i++){
				render(items[i], _curIndex + i);
			}
			scrollAnim();
		}
		
		private function setupItems():void
		{
			var directionOffset:int = _curIndex - _oldIndex;
			var i:int = 0;
			if (directionOffset > 0)
			{
				for (i = 0; i < directionOffset; i++)
				{
					pushItem();
				}
			}
			else if (directionOffset < 0)
			{
				for (i = 0; i > directionOffset; i--)
				{
					unShiftItem();
				}
			}
		}
		
		private function scrollAnim():void
		{
			disableButtons();
			var directionOffset:int = _curIndex - _oldIndex;
			_oldIndex = _curIndex;
			var targetX:Number = _itemPanel.x - (directionOffset * (_itemWidth + _padding));
			TweenLite.to(_itemPanel, 0.5, {x:targetX, onComplete:scrollCompletedHandler,ease:Strong.easeOut} );
		}
		
		private function scrollCompletedHandler():void
		{
			setButtons();
		}
		
		private function pushItem():void
		{
			var item:BaseObject = _cacheItems.pop();
			var lastItem: BaseObject = items[items.length - 1];
			item.x = lastItem.x + _itemWidth + _padding;
			items.push(item);
			var delItem:BaseObject = items.shift();
			_cacheItems.unshift(delItem);
			_itemPanel.addChild(item);
			//_itemPanel.removeChild(delItem);
		}
		
		private function unShiftItem():void
		{
			var item:BaseObject = _cacheItems.pop();
			var lastItem: BaseObject = items[0];
			item.x = lastItem.x - _itemWidth - _padding;
			items.unshift(item);
			var delItem:BaseObject = items.pop();
			_cacheItems.unshift(delItem);
			_itemPanel.addChild(item);
			//_itemPanel.removeChild(delItem);
		}
		
		private function setButtons():void
		{
			if (_btnPrevPage != null) {
				_btnPrevPage.disable = (_curIndex == 0);
			}
			if (_btnNextPage != null) {
				_btnNextPage.disable = (_curIndex + _numItems >= _length);
			}
			if (_btnPrev != null)
			{
				_btnNext.disable = _curIndex <= 0;
			}
			if (_btnNext != null)
			{
				_btnNext.disable = _curIndex >= (_length - _numItems);
			}
		}
		private function disableButtons():void
		{
			if (_btnPrevPage != null) {
				_btnPrevPage.disable = true;
			}
			if (_btnNextPage != null) {
				_btnNextPage.disable = true;
			}
			if (_btnPrev != null)
			{
				_btnNext.disable = true;
			}
			if (_btnNext != null)
			{
				_btnNext.disable = true;
			}
		}
	}

}