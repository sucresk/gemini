package gemini.skeleton2D.skin 
{
	import flash.display.DisplayObjectContainer;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.Skeleton;
	/**
	 * ...
	 * @author 
	 */
	public class DefaultSkinCreator 
	{
		private var _skeletion:Skeleton;
		private var _allBones:Vector.<Bone>;
		private var _boneDict:Object;
		private var _parent:DisplayObjectContainer;
		
		public function DefaultSkinCreator(skeletion:Skeleton, container:DisplayObjectContainer) 
		{
			_skeletion = skeletion;
			_parent = container;
			_allBones = new Vector.<Bone>();
			_boneDict = new Object();
		}
		
		public function create():void
		{
			_allBones = _skeletion.allBones;
			//findBones(_skeletion);
			createSkin();
		}
		
		private function findBones(bone:Bone):void
		{
			var i:int = 0;
			var len:int = bone.children.length;
			var subBone:Bone;
			
			for (i = 0; i < len; i++)
			{
				subBone = bone.children[i];
				if (subBone != null)
				{
					_allBones.push(subBone);
					_boneDict[subBone.name] = subBone;
					if (subBone.children.length > 0)
					{
						findBones(subBone);
					}
				}
			}
			_allBones.sort(sortByZ);
		}
		
		private function sortByZ(a:Bone, b:Bone):int
		{
			if (a.z > b.z)
				return 1;
			else
				return -1;
		}
		
		private function createSkin():void
		{
			var skin:DefaultSkin;
			
			for ( var i:int = 0, len:int = _allBones.length; i < len; i++)
			{
				skin = new DefaultSkin();
				_parent.addChild(skin);
				skin.bind(_allBones[i]);
				skin.render();
				
			}
		}
	}

}