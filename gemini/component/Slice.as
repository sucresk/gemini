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
			
			_items = new Vector.<DisplayObject>();
			var i:int;
			var len:int;
			for (i = 0, len = arr.length; i < len; i++)
			{
				if (arr[i] is DisplayObject)
				{
					_items.push(arr[i]);
				}
			}
			for (i = 1, len = _items.length; i < len; i++)
			{
				_items[i].visible = false;
			}
		}
		
		public function set index(v:int):void
		{
			if (v != _curIndex)
			{
				show(v);
			}
			
		}
		
		public function get index():int
		{
			return _curIndex;
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