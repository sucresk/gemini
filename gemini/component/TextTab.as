package gemini.component 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author sucre
	 */
	public class TextTab extends BaseObject
	{
		private var _btnArr:Vector.<TextButton>;
		private var _selected:int = -1;
		private var _selectedHandler:Function;
		
		public function TextTab(skin:*) 
		{
			super(skin);
			_btnArr = new Vector.<TextButton>();
			
			var item:MovieClip;
			for (var i:int = 0; (item = getChildMovieClipInstance("item" + i)) != null; i++)
			{
				var tabButton:TextButton = new TextButton(item);
				tabButton.clickHandler = new FunctionObject(clickHandler, [i]);
				_btnArr.push(tabButton);
			}
			
		}
		
		public function set labels(v:Array):void
		{
			var btnLength:int = _btnArr.length;
			
			for (var i:int = 0, len:int = v.length; i < len; i++)
			{
				if (i < btnLength)
				{
					_btnArr[i].label = v[i];
				}
			}
		}
		
		public function set selectedHandler(f:Function):void
		{
			_selectedHandler = f;
		}
		
		private function clickHandler(index:int):void 
		{
			this.index = index;
		}
		
		public function set index(v:int):void
		{
			if (_selected >= 0)
			{
				_btnArr[_selected].selected = false;
			}
			_selected = v;
			_btnArr[_selected].selected = true;
			if (_selectedHandler != null)
				_selectedHandler(_selected);
		}
		
		public function get index():int
		{
			return _selected;
		}
		
		public function get btnArr():Vector.<TextButton> 
		{
			return _btnArr;
		}
		
		public function destory():void 
		{
			for ( var i:int = 0, length:int = _btnArr.length; i < length; i++)
			{
				_btnArr[i].destory();
			}
			_btnArr.splice(0, _btnArr.length);
		}
	}

}