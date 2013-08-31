package gemini.component 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author gemini
	 */
	public class Slice 
	{
		protected var _items:Vector.<DisplayObject>;
		protected var _curIndex:int;
		protected var _oldIndex:int;
		
		public function Slice(arr:Array) 
		{
			_items = new Vector.<DisplayObject>(arr);
			for (var i:int = 0, length:int = _items.length; i < length; i++)
			{
				_items[i].visible = false;
			}
			show(_curIndex);
		}
		
		public function set index(v:int):void
		{
			if (v != _curIndex)
			{
				_curIndex = v;
				show(_curIndex);
			}
			
		}
		
		public function set visible(v:Boolean):void
		{
			if(v)
				_items[_curIndex].visible = true;
			else
				_items[_curIndex].visible = false;
		}
		
		private function show(index:int):void
		{
			if (index < 0 || index > _items.length || index == _curIndex)
				return;
			perShow();
			_oldIndex = _curIndex;
			_curIndex = index;
			showEffect();
		}
		
		protected function perShow():void
		{
			
		}
		
		protected function showEffect():void
		{
			_items[_oldIndex].visible = false;
			_items[_curIndex].visible = true;
		}
		
		
	}

}