package gemini.component 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import gemini.data.FunctionObject;
	/**
	 * ...
	 * @author 
	 */
	public class GlowButton extends BaseObject
	{
		protected var _selected:Boolean;
		protected var _clickHandler:FunctionObject;
		protected var _overColor:uint;
		protected var _selectedColor:uint;
		protected var _alpha:Number;
		protected var _blurX:Number;
		protected var _blurY:Number;
		
		public function GlowButton(skin:* = null,intercative:Boolean = true, autoBuild:Boolean = false, buildLayer:int = 1) 
		{
			super(skin, intercative, autoBuild, buildLayer);
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.CLICK, buttonClickHandler);
			setStyle();
		}
		
		public function setStyle(overColor:uint = 0xffffff, selectedColor:uint = 0xff0000, alpha:Number = 0.5, blurX:int = 20, blurY:int = 20):void
		{
			_overColor = overColor;
			_selectedColor = selectedColor;
			_alpha = alpha;
			_blurX = blurX;
			_blurY = blurY;
		}
		private function buttonClickHandler(e:Event):void 
		{
			if (_clickHandler != null)
				_clickHandler.execuse();
		}
		
		private function rollOutHandler(e:Event):void 
		{
			if (_selected)
					filters = [new GlowFilter(_selectedColor, _alpha,_blurX,_blurY)];
				else
					filters = null;
		}
		
		private function rollOverHandler(e:Event):void 
		{
			this.filters = [new GlowFilter(_overColor, _alpha,_blurX,_blurY)];
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (_selected != value)
			{
				_selected = value;
				if (_selected)
					filters = [new GlowFilter(_selectedColor, _alpha,_blurX,_blurY)];
				else
					filters = null;
			}
		}
		
		public function set clickHandler(value:FunctionObject):void 
		{
			_clickHandler = value;
		}
		
		override public function destroy():void 
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			super.destroy();
		}
		
	}

}