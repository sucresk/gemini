package gemini.skeleton2D.utils 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import gemini.skeleton2D.Bone;
	import gemini.skeleton2D.KeyFrame;
	import gemini.skeleton2D.Motion;
	import gemini.skeleton2D.Skeleton;
	/**
	 * ...
	 * @author 
	 */
	public class SkeletonUtil 
	{
		
		public function SkeletonUtil() 
		{
			
		}
		
		public static function createBoneXmlFromMovieClip(mc:MovieClip, name:String):XML
		{
			var xml:XML = new XML("<skeleton name=\"" + name + "\"></skeleton>");
			var i:int = 0;
			var len:int = mc.numChildren;
			var child:DisplayObject;
			
			for (i = 0; i < len; i++)
			{
				child = mc.getChildAt(i);
				if (child.name != null)
				{
					var childXml:XML = new XML("<bone name=\"" + child.name + "\" x=\"" + Math.round(child.x) + "\" y=\"" + Math.round(child.y) + "\" z=\"" + i + "\" rotation=\"" + Math.round(child.rotation) +"\" scaleX=\"" + Number(child.scaleX).toFixed(2) + "\" scaleY=\"" + Number(child.scaleY).toFixed(2) + "\" alpha=\"" + Number(child.alpha).toFixed(2) + "\" length=\"" + Math.round(mc.height) + "\"></bone>");
					xml.appendChild(childXml);
				}
			}
			trace("bone:*****************************************************\n",xml.toXMLString(),"\n****************************************************************");
			return xml;
		}
		
		public static function createAnimationXmlFromMovieClip(mc:MovieClip):XML
		{
			var animXml:XML = new XML("<animation/>");
			var animLabel:String = null;
			
			var motionXml:XML;
			var frame:int = 0;
			var totalFrames:int = mc.totalFrames;
			var mcChild:DisplayObject;
			var mcName:String;
			var partAnim:Object = new Object();
			var initFrame:int;
			for (frame = 1; frame <= totalFrames; frame++)
			{
				mc.gotoAndStop(frame);
				
					
				if (mc.currentFrameLabel != null && mc.currentFrameLabel != animLabel)
				{
					if (motionXml != null)
					{
						motionXml.@totalFrame = frame - initFrame;
					}
					animLabel = mc.currentFrameLabel;
					motionXml = new XML("<motion name=\"" + animLabel + "\" ></motion>");
					animXml.appendChild(motionXml);
					initFrame = frame;
					partAnim = new Object();
					
					for (var i:int = 0, len:int = mc.numChildren; i < len; i++)
					{
						mcChild = mc.getChildAt(i);
						mcName = mcChild.name;
						if (mcName != null)
						{
							if (partAnim[mcName] == null)
							{
								var partXml:XML = new XML("<" + mcName + "/>")
								motionXml.appendChild(partXml);
								partAnim[mcName] = { };
								partAnim[mcName].xml = partXml;
							}
						}
					}
				}
				if (partAnim != null)
				{
					for (i = 0, len = mc.numChildren; i < len; i++)
					{
						mcChild = mc.getChildAt(i);
						mcName = mcChild.name;
						if (mcName != null)
						{
							if (partAnim[mcName] != null)
							{
								createKeyFrameXml(partAnim[mcName], mcChild, frame-initFrame);
							}
						}
					}
				}
				
			}
			if (motionXml != null)
			{
				motionXml.@totalFrame = frame- initFrame;
			}
			//trace("animation:****************************************************\n",animXml.toXMLString(),"\n***********************************************************");
			return animXml;
		}
		
		private static function createKeyFrameXml(prevKey:Object, child:DisplayObject, curFrame:int):void
		{
			var hasChange:Boolean = false;
			var xChange:Boolean = false;
			var scaleXChange:Boolean = false;
			var keyFrameXml:XML = new XML("<keyframe/>");
			keyFrameXml.@index = curFrame;
			
			if (prevKey.x != Math.round(child.x) || prevKey.y != Math.round(child.y))
			{
				hasChange = true;
				xChange = true;
				prevKey.x = Math.round(child.x);
				keyFrameXml.@x = prevKey.x;
			}
			if (prevKey.y != Math.round(child.y) || xChange)
			{
				hasChange = true;
				prevKey.y = Math.round(child.y);
				keyFrameXml.@y = prevKey.y;
			}
			if (prevKey.rotation != Math.round(child.rotation))
			{
				hasChange = true;
				prevKey.rotation = Math.round(child.rotation);
				keyFrameXml.@rotation = prevKey.rotation;
			}
			if (prevKey.scaleX != Number(child.scaleX).toFixed(2) || prevKey.scaleY != Number(child.scaleY).toFixed(2))
			{
				hasChange = true;
				scaleXChange = true;
				prevKey.scaleX = Number(child.scaleX).toFixed(2);
				keyFrameXml.@scaleX = prevKey.scaleX;
			}
			if (prevKey.scaleY != Number(child.scaleY).toFixed(2) || scaleXChange)
			{
				hasChange = true;
				prevKey.scaleY = Number(child.scaleY).toFixed(2);
				keyFrameXml.@scaleY = prevKey.scaleY;
			}
			if (prevKey.alpha != Number(child.alpha).toFixed(2))
			{
				hasChange = true;
				prevKey.alpha = Number(child.alpha).toFixed(2);
				keyFrameXml.@alpha = prevKey.alpha;
			}
			//if (prevKey.skewX != Number(Math.atan(child.transform.matrix.c)).toFixed(2))
			//{
				//hasChange = true;
				//prevKey.skewX = Number(Math.atan(child.transform.matrix.c)).toFixed(2);
				//keyFrameXml.@skewX = prevKey.skewX;
			//}
			//if (prevKey.skewY != Number(Math.atan(child.transform.matrix.b)).toFixed(2))
			//{
				//hasChange = true;
				//prevKey.skewY = Number(Math.atan(child.transform.matrix.b)).toFixed(2);
				//keyFrameXml.@skewY = prevKey.skewY;
			//}
			if (hasChange)
			{
				prevKey.xml.appendChild(keyFrameXml);
			}
		}
		
		public static function exportXmlFromSkeleton(ske:Skeleton):XML
		{
			var xml:XML = new XML("<skeleton name=\"" + ske.name + "\"></skeleton>");
			exportChildXml(ske, xml);
			return xml;
		}
		
		private static function exportChildXml(bone:Bone, xml:XML):void
		{
			var childBone:Bone;
			var childXml:XML;
			for ( var i:int = 0, len:int = bone.children.length; i < len; i++)
			{
				childBone = bone.children[i];
				childXml = new XML("<bone name=\"" + childBone.name + "\" x=\"" + childBone.x + "\" y=\"" + childBone.y + "\" z=\"" + i + "\" rotation=\"" + Math.round(childBone.rotation) +"\" scaleX=\"" + childBone.scaleX + "\" scaleY=\"" + childBone.scaleY + "\" alpha=\"" + childBone.alpha + "\" length=\"" + childBone.length + "\"></bone>");
				xml.appendChild(childXml);
				if (childBone.children.length > 0)
				{
					exportChildXml(childBone, childXml);
				}
			}
		}
		
		public static function exportAnimationXml(ske:Skeleton):XML
		{
			var xml:XML = new XML("<animation name=\"" + ske.name + "\"></animation>");
			var bones:Vector.<Bone>;
			bones = ske.allBones;
			var bone:Bone;
			var motionName:String;
			var motion:Motion;
			var keyframe:KeyFrame;
			var keyframeStr:String;
			
			for (var i:int = 0, len:int = ske.skeMtions.length; i < len; i++)
			{
				motionName = ske.skeMtions[i];
				var motionXml:XML = new XML( "<motion name=\"" + motionName + "\" totalFrame=\"" +ske.skeMotionDict[motionName]+ "\" />");
				for (var j:int = 0, jLen:int = bones.length; j < jLen; j++)
				{
					bone = bones[j];
					for (var k:int = 0, kLen:int = bone.motions.length; k < kLen; k++)
					{
						motion = bone.motions[k];
						if (motion.name == motionName)
						{
							var boneXml:XML = new XML("<" + bone.name + "/>");
							for ( var l:int = 0, lLen:int = motion.keyFrames.length; l < lLen; l++)
							{
								keyframe = motion.keyFrames[l];
								boneXml.appendChild(keyframe.toXml());
								trace(keyframe.toXml().toXMLString());
							}
						}
					}
					motionXml.appendChild(boneXml);
				}
				xml.appendChild(motionXml);
			}
			return xml;
		}
	}

}