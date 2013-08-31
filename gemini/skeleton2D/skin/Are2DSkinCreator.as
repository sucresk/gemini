package gemini.skeleton2D.skin 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import gemini.manager.AssetManager;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.Skeleton;
	import gemini.skeleton2D.utils.Are2DSpriteSheetUtil;
	import gemini.skeleton2D.utils.TextureMix;
	import gemini.skeleton2D.utils.TexturePacker;
	import net.game_develop.animation.gpu.display.GpuObj2d;
	import net.game_develop.animation.gpu.display.GpuSpriteLayer;
	/**
	 * ...
	 * @author 
	 */
	public class Are2DSkinCreator 
	{
		private var _skeletion:Skeleton;
		private var _allBones:Vector.<Bone>;
		private var _parent:GpuObj2d;
		
		public function Are2DSkinCreator(skeleton:Skeleton, parent:GpuObj2d) 
		{
			_skeletion = skeleton;
			_parent = parent;
		}
		
		public function createFromMovieClip(mc:MovieClip):void
		{
			_allBones = _skeletion.allBones;
			var picker:TexturePacker = new TexturePacker();
			picker.addTexturesFromContainer(mc);
			var textureMix:TextureMix = picker.packTextures(128, 2);
			var bone:Bone;
			var skin:Are2DSkin;
			var img:GpuObj2d;
			for (var i:int = 0, len:int = _allBones.length; i < len; i++)
			{
				bone = _allBones[i];
				img = getTextureDisplay(textureMix, bone.name);
				if (_parent != null)
				{
					_parent.add(img);
				}
				skin = new Are2DSkin(img);
				skin.bind(bone);
				skin.render();
			}
		}
		
		private function getTextureDisplay(textureMix:TextureMix, fullName:String):GpuObj2d {
			
			var ssUtil:Are2DSpriteSheetUtil = new Are2DSpriteSheetUtil(textureMix.bitmapData, textureMix.xml);
			
			return ssUtil.getGpuObj2d(fullName);
		}
		
		public function createSkin(bitmap:Bitmap, sheetXml:XML):void
		{
			var sheetObj:Object = { };
			for each (var subTexture:XML in sheetXml.SubTexture)
            {
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x"));
                var y:Number           = parseFloat(subTexture.attribute("y"));
                var width:Number       = parseFloat(subTexture.attribute("width"));
                var height:Number      = parseFloat(subTexture.attribute("height"));
                var frameX:Number      = parseFloat(subTexture.attribute("frameX"));
                var frameY:Number      = parseFloat(subTexture.attribute("frameY"));
                var rotate:Number      = parseFloat(subTexture.attribute("rotate"));
                sheetObj[name] = { rotate:rotate };
            }
			
			var t:Are2DSpriteSheetUtil = new Are2DSpriteSheetUtil(bitmap.bitmapData, sheetXml);
			
			_allBones = _skeletion.allBones;
			
			var bone:Bone;
			var skin:Are2DSkin;
			var img:GpuObj2d;
			for (var i:int = 0, len:int = _allBones.length; i < len; i++)
			{
				bone = _allBones[i];
				if (t.getFrame(bone.name) != null)
				{
					img = t.getGpuObj2d(bone.name);
					//img.name = bone.name;
					img.rotation = sheetObj[bone.name]["rotate"] / 180 * Math.PI;
					if (_parent != null)
					{
						_parent.add(img);
					}
					skin = new Are2DSkin(img);
					skin.bind(bone);
					skin.render();
				}
				else
				{
					trace(bone.name + " is not avilible");
				}
			}
		}
	}

}