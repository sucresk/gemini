package gemini.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author ...
	 */
	public class SliderV extends BaseObject
	{
		private var _cursor:Button;
		private var _pole:MovieClip;
		private var _value:Number;
		private var _totalHeight:Number;
		private var _bindingObj:Object;
		private var _bindingParam:String;
		private var _instantChange:Boolean = true;
		private var _btnUp:Button;
		private var _btnDown:Button;
		private var _step:Number = 0.1;
		private var _initY:Number;
		private var _curY:Number;
		private var _enableMouseWheel:Boolean;
		
		public function SliderV(skin:*) 
		{
			super(skin, true);
			_cursor = new Button(getChildMovieClipInstance("cursor"));
			_pole = getChildMovieClipInstance("pole");
			_initY = _cursor.y;
			_curY = _initY;
			_totalHeight = _pole.height - _cursor.height;
			_cursor.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			var btn:MovieClip = getChildMovieClipInstance("btnUp");
			if (btn)
			{
				_btnUp = new Button(btn);
				_btnUp.clickHandler = new FunctionObject(clickHandler, [-_step]);
			}
			btn = getChildMovieClipInstance("btnDown");
			if (btn)
			{
				_btnDown = new Button(btn);
				_btnDown.clickHandler = new FunctionObject(clickHandler, [_step]);
			}
		}
		
		public function setRange(pageItems:int, totalItems:int):void
		{
			reset();
			if (pageItems >= totalItems)
			{
				_cursor.height = _pole.height;
				_totalHeight = 0;
				interactiveEnable = false;
				if (_btnDown)
					_btnDown.disable = true;
				if (_btnUp)
					_btnUp.disable = true;
				tickEnable = false;
			}
			else
			{
				var range:Number = pageItems / totalItems;
				if (range < 0.2)
					range = 0.2;
				_cursor.height = int(_pole.height * range);
				_totalHeight = _pole.height - _cursor.height;
				interactiveEnable = true;
				setButtonState();
				tickEnable = true;
			}
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			_cursor.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			_cursor.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			_cursor.startDrag(false, new Rectangle(_cursor.x, _pole.y, 0, _pole.height - _cursor.height));
			tickEnable = true;
		}
		
		private function moveHandler(e:MouseEvent):void 
		{
			tick(0);
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			_cursor.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			_cursor.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			_cursor.stopDrag();
			tickEnable = false;
			if (!_instantChange && _bindingObj != null && _bindingParam != null)
			{
				_bindingObj[_bindingParam] = _value;
			}
		}
		
		private function clickHandler(s:Number):void
		{
			_curY += _pole.height * s;
			if (_curY > _initY + _totalHeight)
			{
				_curY = _initY + _totalHeight;
			}
			else if (_curY < _initY)
			{
				_curY = _initY;
			}
			_cursor.y =  _curY;
			tick(0);
		}
		
		public function bindObj(obj:Object, param:String):void
		{
			if (_enableMouseWheel)
			{
				enableMouseWheel = false;
				_bindingObj = obj;
				_bindingParam = param;
				enableMouseWheel = true;
			}
			else
			{
				_bindingObj = obj;
				_bindingParam = param;
			}
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			if (value <= 0)
			{
				value = 0;
			}
			else if (value >= 1)
			{
				value = 1;
			}
			if (_value != value)
			{
				_value = value;
			}
			
		}
		
		public function get instantChange():Boolean 
		{
			return _instantChange;
		}
		
		public function set instantChange(value:Boolean):void 
		{
			_instantChange = value;
		}
		
		public function get step():Number 
		{
			return _step;
		}
		
		public function set step(value:Number):void 
		{
			_step = value;
		}
		
		public function get enableMouseWheel():Boolean 
		{
			return _enableMouseWheel;
		}
		
		public function set enableMouseWheel(value:Boolean):void 
		{
			if (_enableMouseWheel != value)
			{
				_enableMouseWheel = value;
				if (_bindingObj != null && _bindingObj is DisplayObject)
				{
					if (_enableMouseWheel)
					{
						DisplayObject(_bindingObj).addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
					}
					else
					{
						DisplayObject(_bindingObj).removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
					}
				}
			}
		}
		
		private function mouseWheelHandler(e:MouseEvent):void 
		{
			if (e.delta > 0)
			{
				clickHandler(-_step);
			}
			else
			{
				clickHandler(_step);
			}
		}
		
		public function reset():void
		{
			_cursor.y = _initY;
			_value = 0;
		}
		public function setButtonState():void
		{
			if (_totalHeight <= 0)
			{
				if (_btnUp)
					_btnUp.disable = false;
				if (_btnDown)
					_btnDown.disable = false;
			}
			else
			{
				if (_value <= 0)
				{
					if (_btnUp)
						_btnUp.disable = true;
					if (_btnDown)
						_btnDown.disable = false;
				}
				else if (_value >= 1)
				{
					if (_btnUp)
						_btnUp.disable = false;
					if (_btnDown)
						_btnDown.disable = true;
				}
				else
				{
					if (_btnUp)
						_btnUp.disable = false;
					if (_btnDown)
						_btnDown.disable = false;
				}
			}
			
		}
		
		override public function tick(intervalTime:uint):void 
		{
			_curY = _cursor.y;
			value = (_cursor.y - _pole.y) / _totalHeight;
			setButtonState();
			if (_instantChange && _bindingObj != null && _bindingParam != null)
			{
				_bindingObj[_bindingParam] = _value;
			}
		}
		
		
	}

}