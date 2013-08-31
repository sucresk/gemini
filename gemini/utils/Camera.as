package  gemini.utils 
{
	import com.chifanfan.dice.BaseObject;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gemini.data.Vars;
	/**
	 * ...
	 * @author sukui
	 */
	public class Camera extends BaseObject
	{
		private var _mouseDrag:Boolean;
		private var initDrag:Boolean;
		private var focusTarget:BaseObject;
		
		public function set mouseDrag(v:Boolean):void
		{
			if (v == _mouseDrag) return;
			_mouseDrag = v;
			if (v) stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			else stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
		}
		public function get mouseDrag():Boolean
		{
			return _mouseDrag;
		}
		public function Camera(mouseDrag:Boolean = true) 
		{
			initDrag = mouseDrag;
			this.addEventListener(Event.ADDED_TO_STAGE, init); 
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.mouseDrag = initDrag;
		}
		
		private function mouseHandler(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					this.startDrag();
					break;
				case MouseEvent.MOUSE_MOVE:
					break;
				case MouseEvent.MOUSE_UP:
					this.stopDrag();
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
					break;
			}
		}
		
		public function focusOn(target:BaseObject):void {
			if (target == null) {
				focusTarget = null;
				return;
			}
			else {
				mouseDrag = false;
				focusTarget = null;
				TweenLite.to(this, 0.5, { x:( -target.x + Vars.STAGE_W / 2),
										   y:( -target.y + Vars.STAGE_H / 2),
										   onComplete:realFocusOn,
										   onCompleteParams:[target]
										  }
							);
				//focusTarget = target;
			}
			
		}
		private function realFocusOn(target:BaseObject):void {
			if (target == null) return;
			focusTarget = target;
		}
		override public function tick(intervalTime:int):void 
		{
			if ( focusTarget == null) return;
			this.x = -focusTarget.x + Vars.STAGE_W / 2;
			this.y = -focusTarget.y + Vars.STAGE_H / 2;
			//trace(this.x + " " + this.y);
		}
	}

}