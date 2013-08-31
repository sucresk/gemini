package gemini.skeleton2D.skin 
{
	import flash.display.Bitmap;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.Skeleton;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author 
	 */
	public class StarlingAvatar extends Sprite
	{
		private var _skeletion:Skeleton;
		private var _allBones:Vector.<Bone>;
		private var _boneDict:Object;
		
		private var _mapTexture:Object;
		private var _mapOffset:Object;
		
		public function StarlingAvatar(skeleton:Skeleton) 
		{
			_skeletion = skeleton;
			_allBones = _skeletion.allBones;
			_boneDict = _skeletion.boneDict;
			_mapTexture = new Object();
			_mapOffset = new Object();
		}
		
		public function setPartTexture(part:String,texture:Texture,atlasXml:XML,offsetX:int = 0,offsetY:int = 0):void
		{
			var ta:TextureAtlas = new TextureAtlas(texture, atlasXml);
			_mapTexture[part] = ta;
			_mapOffset[part] = { x:offsetX, y:offsetY };
		}
		
		public function changePartById(name:String, id:int):void
		{
			var ta:TextureAtlas = _mapTexture[name];
			var textureName:String;
			
			if (ta != null)
			{
				textureName = getTextureId(name, id);
				var img:Image = new Image(ta.getTexture(textureName));
				img.pivotX = _mapOffset[name].x;
				img.pivotY = _mapOffset[name].y;
				changePart(name, img);
			}
		}
		
		public function changeAvatar(avatarId:int):void
		{
			for (var name:String in _boneDict)
			{
				changePartById(name, avatarId);
			}
		}
		private function getTextureId(name:String, id:int):String
		{
			var tId:String;
			if (id < 10)
			{
				tId = "000" + id.toString();
			}
			else if (id < 100)
			{
				tId = "00" + id.toString();
			}
			else if ( id < 1000)
			{
				tId = "0" + id.toString();
			}
			else if ( id < 10000)
			{
				tId = "" + id.toString();
			}
			else
			{
				tId = "" + id.toString();
			}
			return name + tId;
		}
		
		public function changePart(name:String, skin:Image):void
		{
			var bone:Bone = _boneDict[name];
			var oldSkin:StarlingSkin;
			var depth:int = 0;
			if (bone != null)
			{
				if (bone.skin != null)
				{
					oldSkin = bone.skin as StarlingSkin;
					
					if (oldSkin)
					{
						if (oldSkin.img.parent)
						{
							depth = oldSkin.img.parent.getChildIndex(oldSkin.img);
							oldSkin.img.parent.removeChild(oldSkin.img);
							
						}
						oldSkin.img = skin;
						addChildAt(skin,depth);
						oldSkin.render();
					}
				}
				else
				{
					oldSkin = new StarlingSkin(skin);
					oldSkin.bind(bone);
					oldSkin.render();
				}
			}
		}
		
	}

}