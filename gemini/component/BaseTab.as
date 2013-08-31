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
	public class BaseTab extends BaseObject
	{
		private var _btnArr:Vector.<Button>;
		private var _selected:int = -1;
		private var _selectedHandler:Function;
		
		public function BaseTab(skin:*) 
		{
			super(skin);
			_btnArr = new Vector.<Button>();
			
			var item:MovieClip;
			for (var i:int = 0; (item = getChildMovieClipInstance("item" + i)) != null; i++)
			{
				var tabButton:Button = new Button(item);
				tabButton.clickHandler = new FunctionObject(clickHandler, [i]);
				_btnArr.push(tabButton);
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
		
		public function get btnArr():Vector.<Button> 
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