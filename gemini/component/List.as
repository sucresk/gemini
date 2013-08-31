package gemini.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author sucre
	 */
	public class List extends BaseObject
	{
		public var items:Vector.<DisplayObject>;
		
		
		private var _numItems:int;
		private var _curIndex:int;
		private var _length:int;
		private var _curPage:int = 1;
		
		private var _btnPrevPage:Button;
		private var _btnNextPage:Button;
		private var _renderHandler:Function;
		
		public function List(skin:*) 
		{
			super(skin);
			initItems();
		}
		
		private function initItems():void
		{
			var item:MovieClip;
			for (var i:int = 0; (item = getChildMovieClipInstance("item" + i)) != null; i++)
			{
				items.push(item);
			}
			_numItems = items.length;
			
			var btn:MovieClip = getChildMovieClipInstance("btnPrevPage");
			if (btn != null)
			{
				_btnPrevPage = new Button(btn);
				_btnPrevPage.clickHandler = new FunctionObject(scroll, [-1]);
			}
			btn = getChildMovieClipInstance("btnNextPage");
			if (btn != null)
			{
				_btnNextPage = new Button(btn);
				_btnNextPage.clickHandler = new FunctionObject(scroll, [1]);
			}
			btn = null;
			
			index = 0;
			page = 1;
		}
		
		public function set renderHandler(v:Function):void
		{
			_renderHandler = v;
		}
		
		public function get length():int 
		{
			return _length;
		}
		
		public function set length(v:int):void 
		{
			_length = v;
			//totalPage = ((_length % _numItems) == 0 ? _length / _numItems : (_length / _numItems + 1));
			totalPage = Math.ceil(_length / _numItems);
			refresh();
		}
		
		public function get page():int
		{
			return _curPage;
		}
		
		public function set page(v:int):void
		{
			v = (v <= 1 ? 1 : (v >= totalPage ? totalPage : v));
			_curPage = v;
			if (_btnPrevPage != null) {
				_btnPrevPage.disabled = (_page == 1);
				_btnPrevPage.visible  = (totalPage > 1);
			}
			if (_btnNextPage) {
				_btnNextPage.disabled = (_page == totalPage);
				_btnNextPage.visible = (totalPage > 1);
			}
			for (var i:int = 0; i < _numItems; i++){
				render(items[i], (_page - 1) * _numItems + i);
			}
		}
		
		private function render(item:DisplayObject, index:int):void {
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
			page += change;
		}
		
		public function refresh():void
		{
			page = _curPage;
		}
	}

}