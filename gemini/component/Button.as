package gemini.component 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author sucre
	 */
	public class Button extends BaseObject
	{
		private const DISABLE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086000084877014, 0.6093999743461609, 0.0820000022649765, 0,
																				0,                  0.3086000084877014, 0.6093999743461609, 0.0820000022649765,
																				0,                  0,                  0.3086000084877014, 0.6093999743461609,
																				0.0820000022649765, 0,                  0,                  0,
																				0,                  0,                  1,                  0
																				]);
		
		public var id:int;
		
		private var _skin:MovieClip;
		private var _selected:Boolean;
		private var _tabType:Boolean;
		private var _buttonSequence:String;
		private var _disable:Boolean;
		private var _clickHandler:FunctionObject;
		
		public function Button(content:*, labelSuffix:String="") 
		{
			super(content,true,true);
			_skin = this.content;
			setButtonSequence(_skin, labelSuffix);
			_skin.buttonMode = true;
			_skin.stop();
			_skin.addEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
			_skin.addEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
			_skin.addEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
			_skin.addEventListener(MouseEvent.MOUSE_OVER, buttonOverListener);
			_skin.addEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
			_skin.addEventListener(MouseEvent.CLICK, buttonClickHandler);
		}
		
		public function set selected(v:Boolean):void 
		{
			if (selected == v) return;
			_selected = v;
			if (v) _skin.gotoAndStop("down" + _buttonSequence);
			else _skin.gotoAndStop("up" + _buttonSequence);
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set disable(v:Boolean):void
		{
			if (_disable == v) return;
			_disable = v;
			if (v) {
				_skin.buttonMode = false;
				_skin.removeEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
				_skin.removeEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
				_skin.removeEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
				_skin.removeEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
				_skin.removeEventListener(MouseEvent.MOUSE_OVER, buttonOverListener);
				_skin.removeEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
				_skin.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
				
				if (_skin.totalFrames >= 4)
				{
					_skin.gotoAndStop("disable" + _buttonSequence);
				}
				else
				{
					_skin.filters = [DISABLE_FILTER];
				}
			}
			else {
				_skin.buttonMode = true;
				_skin.addEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
				_skin.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
				_skin.addEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
				_skin.addEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
				_skin.addEventListener(MouseEvent.MOUSE_OVER, buttonOverListener);
				_skin.addEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
				_skin.addEventListener(MouseEvent.CLICK, buttonClickHandler);
				_skin.filters = null;
				_skin.gotoAndStop("up");
			}
		}
		
		public function set clickHandler(v:FunctionObject):void
		{
			_clickHandler = v;
		}
		
		private function setButtonSequence(btn:MovieClip, labelSuffix:String):void{
            _buttonSequence = labelSuffix;
        }
		protected function buttonDownListener(e:MouseEvent):void {
            _skin.gotoAndStop("down" + _buttonSequence);
			dispatchEvent(e);
        }
        protected function buttonUpListener(e:MouseEvent):void {
            _skin.gotoAndStop("over" + _buttonSequence);
			dispatchEvent(e);
        }
        protected function buttonOutListener(e:MouseEvent):void {
			if (_selected) return;
            _skin.gotoAndStop("up" + _buttonSequence);
			dispatchEvent(e);
        }
        protected function buttonOverListener(e:MouseEvent):void {
			if (_selected) return;
            _skin.gotoAndStop("over" + _buttonSequence);
			dispatchEvent(e);
        }
		protected function buttonClickHandler(e:MouseEvent):void 
		{
			if (_clickHandler != null)
				_clickHandler.execuse();
			dispatchEvent(e);
		}
		
		public function destory():void {
			_skin.removeEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
			_skin.removeEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
			_skin.removeEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
			_skin.removeEventListener(MouseEvent.MOUSE_OVER, buttonOverListener);
			_skin.removeEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
			_skin.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
		}
	}

}