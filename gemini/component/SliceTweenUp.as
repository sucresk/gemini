package gemini.component 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class SliceTweenUp extends Slice
	{
		private var _sliceHeight:Number;
		
		public function SliceTweenUp(arr:Array) 
		{
			super(arr);
			if (_items.length > 0)
			{
				_sliceHeight = _items[0].height;
			}
		}
		
		override protected function perShow():void 
		{
			TweenLite.killTweensOf(_items[_curIndex], true);
		}
		override protected function showEffect():void 
		{
			var oldItem:DisplayObject = _items[_oldIndex];
			var curItem:DisplayObject = _items[_curIndex];
			oldItem.visible = false;
			TweenLite.from(curItem, 0.2, { y:curItem.y - _sliceHeight } );
			curItem.visible = true;
		}
	}

}