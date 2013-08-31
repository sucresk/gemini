package gemini.component 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class SliderV extends BaseObject
	{
		private var _cursor:MovieClip;
		private var _pole:MovieClip;
		private var _value:Number;
		private var _totalHeight:Number;
		private var _bindingObj:Object;
		private var _bindingParam:String;
		private var _instantChange:Boolean = true;
		
		public function SliderV(skin:*) 
		{
			super(skin, true);
			_cursor = getChildMovieClip("cursor");
			_pole = getChildMovieClip("pole");
			_totalHeight = _pole.height - _cursor.height;
			_cursor.buttonMode = true;
			_cursor.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			_cursor.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			_cursor.startDrag(false, new Rectangle(_cursor.x, _pole.y, 0, _pole.height - _cursor.height));
			tickEnable = true;
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			_cursor.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			_cursor.stopDrag();
			tickEnable = false;
			if (!_instantChange && _bindingObj != null && _bindingParam != null)
			{
				_bindingObj[_bindingParam] = _value;
			}
		}
		
		public function bindObj(obj:Object, param:String):void
		{
			_bindingObj = obj;
			_bindingParam = param;
		}
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		public function get instantChange():Boolean 
		{
			return _instantChange;
		}
		
		public function set instantChange(value:Boolean):void 
		{
			_instantChange = value;
		}
		
		public function reset():void
		{
			_cursor.y = 0;
			_value = 0;
		}
		override public function tick(intervalTime:uint):void 
		{
			_value = _cursor.y / _totalHeight;
			if (_instantChange && _bindingObj != null && _bindingParam != null)
			{
				_bindingObj[_bindingParam] = _value;
			}
		}
		
		
	}

}