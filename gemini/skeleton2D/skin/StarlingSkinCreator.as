package gemini.skeleton2D.skin 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import gemini.manager.AssetManager;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.Skeleton;
	import gemini.skeleton2D.utils.TextureMix;
	import gemini.skeleton2D.utils.TexturePacker;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author 
	 */
	public class StarlingSkinCreator 
	{
		private var _skeletion:Skeleton;
		private var _allBones:Vector.<Bone>;
		private var _parent:Sprite;
		
		public function StarlingSkinCreator(skeleton:Skeleton, parent:Sprite) 
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
			if (!textureMix.texture) {
				textureMix.texture = Texture.fromBitmapData(textureMix.bitmapData);
			}
			var bone:Bone;
			var skin:StarlingSkin;
			var img:Image;
			for (var i:int = 0, len:int = _allBones.length; i < len; i++)
			{
				bone = _allBones[i];
				img = getTextureDisplay(textureMix, bone.name);
				if (_parent != null)
				{
					_parent.addChild(img);
				}
				skin = new StarlingSkin(img);
				skin.bind(bone);
				skin.render();
			}
		}
		
		private function getTextureDisplay(textureMix:TextureMix, fullName:String):Image {
			var texture:XML = textureMix.getTexture(fullName);
			if (texture) {
				var rect:Rectangle = new Rectangle(int(texture.@x), int(texture.@y), int(texture.@width), int(texture.@height));
				var img:Image = new Image(new SubTexture(textureMix.texture as Texture, rect));
				img.pivotX = -int(texture.@frameX);
				img.pivotY = -int(texture.@frameY);
				return img;
			}
			return null;
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
			
			var t:TextureAtlas = new TextureAtlas(Texture.fromBitmap(bitmap), sheetXml);
			
			_allBones = _skeletion.allBones;
			
			var bone:Bone;
			var skin:StarlingSkin;
			var img:Image;
			for (var i:int = 0, len:int = _allBones.length; i < len; i++)
			{
				bone = _allBones[i];
				if (t.getTexture(bone.name) != null)
				{
					img = new Image(t.getTexture(bone.name));
					img.name = bone.name;
					img.rotation = sheetObj[img.name]["rotate"] / 180 * Math.PI;
					if (_parent != null)
					{
						_parent.addChild(img);
					}
					skin = new StarlingSkin(img);
					skin.bind(bone);
					skin.render();
				}
				else
				{
					trace(bone.name);
				}
			}
		}
	}

}