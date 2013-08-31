package gemini.skeleton2D.skin 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gemini.skeleton2D.Bone;
	/**
	 * ...
	 * @author 
	 */
	public class DefaultSkin extends Sprite implements ISkin
	{
		private var _bone:Bone;
		
		public function DefaultSkin() 
		{
			
		}
		
		/* INTERFACE skeleton2D.ISkin */
		
		public function bind(bone:Bone):void 
		{
			_bone = bone;
			bone.skin = this;
			this.graphics.clear();
			this.graphics.beginFill(0x0000ff, 0.5);
			graphics.moveTo( 0, -5);
			graphics.lineTo( 0, 5);
			graphics.lineTo( _bone.length, 0);
			graphics.lineTo( 0, -5);
			this.graphics.endFill();
			this.graphics.beginFill(0xff0000, 0.5);
			this.graphics.drawCircle(0, 0, 5);
			this.graphics.endFill();
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		private function downHandler(e:MouseEvent):void 
		{
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		private function moveHandler(e:MouseEvent):void 
		{
			var dx:Number = stage.mouseX - _bone.realX;
			var dy:Number = -stage.mouseY + _bone.realY;
			var r:Number = Math.atan2(dx , dy);
			
			_bone.rotation = r / Math.PI * 180 - 90 - _bone.parent.realRotation;
		}
		
		public function render():void 
		{
			
			this.x = _bone.realX;
			this.y = _bone.realY;
			this.rotation = _bone.realRotation;
			this.scaleX = _bone.realScaleX;
			this.scaleY = _bone.realScaleY;
			this.alpha = _bone.realAlpha;
		}
		
	}

}