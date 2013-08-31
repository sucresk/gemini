package gemini.skeleton2D.skin 
{
	import flash.display.DisplayObject;
	import gemini.skeleton2D.Bone;
	/**
	 * ...
	 * @author 
	 */
	public class MovieClipSkin implements ISkin
	{
		private var _bone:Bone;
		private var _mc:DisplayObject;
		
		public function MovieClipSkin(mc:DisplayObject) 
		{
			_mc = mc;
		}
		
		/* INTERFACE skeleton2D.skin.ISkin */
		
		public function bind(bone:Bone):void 
		{
			_bone = bone;
			bone.skin = this;
		}
		
		public function render():void 
		{
			_mc.x = _bone.realX;
			_mc.y = _bone.realY;
			_mc.rotation = _bone.realRotation;
			_mc.scaleX = _bone.realScaleX;
			_mc.scaleY = _bone.realScaleY;
			_mc.alpha = _bone.realAlpha;
		}
		
	}

}