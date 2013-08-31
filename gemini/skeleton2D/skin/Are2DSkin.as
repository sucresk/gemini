package gemini.skeleton2D.skin 
{
	import gemini.skeleton2D.Bone;
	import net.game_develop.animation.gpu.display.GpuObj2d;
	/**
	 * ...
	 * @author 
	 */
	public class Are2DSkin implements ISkin
	{
		public var img:GpuObj2d;
		
		private var _bone:Bone;
		private var _baseR:Number;
		
		public function Are2DSkin(skin:GpuObj2d) 
		{
			this.img = skin;
			_baseR = img.rotation;
			img.rotation = 0;
		}
		
		/* INTERFACE skeleton2D.skin.ISkin */
		
		public function bind(bone:Bone):void 
		{
			_bone = bone;
			bone.skin = this;
			//_baseR -= bone.realRotation* Math.PI / 180;
		}
		
		public function render():void 
		{
			this.img.x = _bone.realX;
			this.img.y = _bone.realY;
			this.img.rotation = _bone.realRotation + _baseR;
			//this.img.rotation = _baseR;
			this.img.scaleX = _bone.realScaleX;
			this.img.scaleY = _bone.realScaleY;
			//this.skin.skewX = _bone.realSkewX;
			//this.skin.skewY = _bone.realSkewY;
			this.img.alpha = _bone.realAlpha;
		}
		
	}

}