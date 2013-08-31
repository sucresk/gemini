package gemini.component 
{
	import gemini.data.Vars;
	/**
	 * ...
	 * @author sucre
	 */
	public class AnimatedObject extends BaseObject
	{
		public var nextAnimations:Array;
		public var nextAnimationsLoop:Array;
		public var frameDelay:int;
		public var curLabelIndex:int;
		public var frameTimer:int;
		public var finishAtfirstFrame:Boolean;
		public var numLoops:int = 0;
		public var pause:Boolean = false;
		
		public function AnimatedObject(skin:*,intercative:Boolean = false, autoBuild:Boolean = false):void 
		{
			nextAnimations = new Array();
			nextAnimationsLoop = new Array();
			super(skin, intercative, autoBuild);
			frameDelay = int(1000 / Vars.fps);
			//frameTimer = frameDelay;
		}
		
		public function setSequence(labelName:String):void
		{
			for (var i:int = 0; i < content.currentLabels.length; i++)
			{
				if (content.currentLabels[i].name == labelName)
				{
					content.gotoAndStop(content.currentLabels[i].frame);
					frameTimer = frameDelay;
					curLabelIndex = i;
					return;
				}
			}
		}
		
		override public function stop():void
		{
			super.stop();
			this.pause = true;
		}
		
		private function loopBackToStart():void
		{
			if (content.currentLabels.length > 0)
			{
				content.gotoAndStop(content.currentLabels[curLabelIndex].name);
			}
			else
			{
				content.gotoAndStop(1);
			}
		}
		
		public function setFrameDelay(delayTime:int):void
		{
			this.frameDelay = delayTime;
		}
		
		override public function tick(intervalTime:uint):void
		{
			if (pause)
			{
				return;
			}
			frameTimer -= intervalTime;
			while ( numLoops != 0 && frameTimer < 0)
			{
				if ( hasReachedAnimationEnd())
				{
					if ( numLoops > 0)
					{
						numLoops--;
					}
					if (numLoops != 0)
					{
						loopBackToStart();
					}
					else
					{
						if ( nextAnimations.length > 0 )
						{
							nextAnimations.splice(0, 1);
						}
						else
						{
							if ( finishAtfirstFrame)
							{
								loopBackToStart();
							}
							pause = true;
						}
					}
				}
				else
				{
					content.nextFrame();
				}
				frameTimer += frameDelay;
			}
		}
		
		public function getFrameCount():int
		{
			return content.totalFrames;
		}
		
		public function setFrame(frameIndex:int):void
		{
			if (content.currentLabels.length > 0)
			{
				content.gotoAndStop((content.currentLabels[curLabelIndex].frame + frameIndex) -1)
			}
			else
			{
				content.gotoAndStop(frameIndex);
			}
			frameTimer = frameDelay;
		}
		
		public function resume():void
		{
			this.pause = false;
		}
		
		public function hasReachedAnimationEnd():Boolean
		{
			var nextLabelIndex:int = curLabelIndex + 1;
			if (nextLabelIndex < content.currentLabels.length)
			{
				return content.currentFrame >= (content.currentLabels[nextLabelIndex].frame - 1);
			}
			return content.currentFrame >= content.totalFrames;
		}
		
		public function nextframe():void
		{
			if (hasReachedAnimationEnd())
			{
				loopBackToStart();
			}
			else
			{
				content.nextFrame();
			}
		}
		
		public function hasSequence( labelName:String):Boolean
		{
			for ( var i:int = 0; i < content.currentLabels.length; i++)
			{
				if (content.currentLabels[i].name == labelName)
				{
					return true;
				}
			}
			return false;
		}
	}

}