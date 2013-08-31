package gemini.skeleton2D.skin 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.Skeleton;
	/**
	 * ...
	 * @author 
	 */
	public class MovieClipSkinCreator 
	{
		private var _skeletion:Skeleton;
		private var _boneDict:Object;
		private var _skin:MovieClip;
		
		public function MovieClipSkinCreator(skeletion:Skeleton, skinMc:MovieClip) 
		{
			_skeletion = skeletion;
			_skin = skinMc;
			_boneDict = new Object();
		}
		
		public function create():void
		{
			_boneDict = _skeletion.boneDict
			createSkin();
		}
		
		private function createSkin():void
		{
			var i:int = 0;
			var len:int = _skin.numChildren;
			var skin:DisplayObject;
			var bone:Bone;
			
			for ( i = 0; i < len; i++)
			{
				skin = _skin.getChildAt(i);
				if (skin.name != null)
				{
					bone = _boneDict[skin.name] as Bone;
					if (bone != null)
					{
						var mcSkin:MovieClipSkin = new MovieClipSkin(skin);
						mcSkin.bind(bone);
						mcSkin.render();
					}
				}
			}
			
		}
		
	}

}