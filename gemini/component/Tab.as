package gemini.component 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author sucre
	 */
	public class Tab extends EventDispatcher
	{
		private var _btnArr:Array;
		private var _selected:int = -1;
		public function get selected():int
		{
			return _selected;
		}
		public function Tab(buttons:Array) 
		{
			_btnArr = new Array();
			for ( var i:int = 0, length:int = buttons.length; i < length; i++)
			{
				if ( buttons[i] is MovieClip) {
					var tabButton:Button = new Button(buttons[i]);
					tabButton.id = i;
					tabButton.addEventListener(MouseEvent.CLICK, clickHandler);
					_btnArr.push(tabButton);
				}
			}
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			_selected = e.currentTarget.id;
			
			for ( var i:int = 0, length:int = _btnArr.length; i < length; i++) {
				if (_selected == i) {
					Button(_btnArr[i]).selected = true;	
				}
				else {
					Button(_btnArr[i]).selected = false;
				}
				
			}
			dispatchEvent(e);
		}
		
		public function refresh():void
		{
			if (_selected >= 0) {
				Button(_btnArr[_selected]).selected = false;
				_selected = -1;
			}
		}
		
		public function destory():void 
		{
			for ( var i:int = 0, length:int = _btnArr.length; i < length; i++)
			{
				_btnArr[i].removeEventListener(MouseEvent.CLICK, clickHandler);
				_btnArr[i].destory();
			}
			_btnArr.splice(0, _btnArr.length);
		}
	}

}