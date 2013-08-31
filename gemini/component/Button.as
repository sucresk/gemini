package gemini.component 
{
	import com.darkforrest.config.ResourceUrl;
	import com.darkforrest.utils.sound.SoundManager;
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
		private const FRAME_UP:int = 1;
		private const FRAME_OVER:int = 2;
		private const FRAME_DOWN:int = 3;
		private const FRAME_DISABLE:int = 4;
		private const FRAME_SELECTED_UP:int = 5;
		private const FRAME_SELECTED_OVER:int = 6;
		private const FRAME_SELECTED_DOWN:int = 7;
		private const FRAME_SELECTED_DISABLE:int = 8;
		
		public var id:int;
		
		private var _skin:MovieClip;
		private var _selected:Boolean;
		private var _tabType:Boolean;
		private var _disable:Boolean;
		private var _clickHandler:FunctionObject;
		public var mouseEnableWhenDisable:Boolean = false;
		
		public function Button(content:*) 
		{
			super(content);
			_skin = this.content as MovieClip;
			_skin.buttonMode = true;
			_skin.stop();
			_skin.addEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
			_skin.addEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
			_skin.addEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
			_skin.addEventListener(MouseEvent.CLICK, buttonClickHandler);
		}
		
		public function set selected(v:Boolean):void 
		{
			if (selected == v) return;
			_selected = v;
			if (v) _skin.gotoAndStop(FRAME_DOWN);
			else _skin.gotoAndStop(FRAME_UP);
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
				if (!mouseEnableWhenDisable)
				{
					mouseEnabled = false;
					mouseChildren = false;
				}
				if (_skin.totalFrames >= 4)
				{
					_skin.gotoAndStop(FRAME_DISABLE);
				}
				else
				{
					_skin.filters = [DISABLE_FILTER];
				}
			}
			else {
				_skin.buttonMode = true;
				mouseEnabled = true;
				mouseChildren = true;
				_skin.filters = null;
				_skin.gotoAndStop(FRAME_UP);
			}
		}
		
		public function set clickHandler(v:FunctionObject):void
		{
			_clickHandler = v;
		}
		
		protected function buttonDownListener(e:MouseEvent):void {
            _skin.gotoAndStop(FRAME_DOWN);
        }
        protected function buttonUpListener(e:MouseEvent):void {
            _skin.gotoAndStop(FRAME_OVER);
        }
        protected function buttonOutListener(e:MouseEvent):void {
			if (_selected) return;
            _skin.gotoAndStop(FRAME_UP);
        }
        protected function buttonOverListener(e:MouseEvent):void {
			if (_selected) return;
            _skin.gotoAndStop(FRAME_OVER);
			SoundManager.instance.playEffect("buttonOver", ResourceUrl.systemSound+"ui/aniu_jinguo.mp3");
        }
		protected function buttonClickHandler(e:MouseEvent):void 
		{
			SoundManager.instance.playEffect("buttonDown", ResourceUrl.systemSound+"ui//aniu_anxia.mp3");
			if (_clickHandler != null)
				_clickHandler.execuse();
		}
		
		public function destory():void {
			_skin.removeEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
			_skin.removeEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
			_skin.removeEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
			_skin.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
		}
	}

}