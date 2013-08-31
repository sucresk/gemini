package gemini.utils 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import gemini.component.BaseObject;
	import gemini.manager.FontsManager;
	/**
	 * ...
	 * @author ...
	 */
	public class AutoBuild 
	{
		
		public function AutoBuild() 
		{
			
		}
		static public function buildAll(target:BaseObject,buildChildren:int):void
		{
			var skin:DisplayObject = target.content;
			var children:Array;
			children = SearchUtil.findChildrenByClass(skin, InteractiveObject, buildChildren);
			var types:Object = ReflectUtil.getPropertyTypeList(target, true);
			for (var i:int = 0; i < children.length; i++)
			{
				var obj:DisplayObject = children[i] as DisplayObject;
				var skinName:String = obj.name;
				if (types[skinName])
				{
					
					var skinClass:Class = types[skinName] as Class;
					if (skinClass == TextField)
					{
						FontsManager.setStrictSized(obj as TextField);
						target[skinName] = obj;
					}
					else if (skinClass == MovieClip || skinClass == Sprite)
					{
						target[skinName] = obj;
					}
					else
					{
						target[skinName] = new skinClass(obj);
						target[skinName].parentObject = target;
					}
					
				}
			}
		}
	}

}