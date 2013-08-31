package gemini.component 
{
	/**
	 * ...
	 * @author gemini
	 */
	public class BaseAnimation extends BaseObject
	{
		public var nextAnimations:Array;
		public var nextAnimationsLoop:Array;
		public var frameDelay:int;
		public var curLabelIndex:int;
		public var frameTimer:int;
		public var finishAtfirstFrame:Boolean;
		public var numLoops:int = 0;
		public var pause:Boolean;
		
		private var _removeAfterFinish:Boolean;
		
		public function BaseAnimation(skin:*) 
		{
			super(skin);
			frameDelay = 33;
			stop();
			tickEnable = true;
		}
		
		public function playCount(num:int, removeAfterFinish:Boolean):void
		{
			pause = false;
			_removeAfterFinish = removeAfterFinish;
		}
		
		public function setFrameRate(rate:int):void
		{
			frameDelay = int(1000 / rate);
		}
		public function setFrameDelay(delayTime:int):void
		{
			this.frameDelay = delayTime;
		}
		
		override public function stop():void
		{
			super.stop();
			this.pause = true;
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
						content.gotoAndStop(1);
					}
					else
					{
						if (_removeAfterFinish)
						{
							destroy();
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
		
		public function hasReachedAnimationEnd():Boolean
		{
			return content.currentFrame >= content.totalFrames;
		}
		
		public function destory():void
		{
			if (this.parent != null)
			{
				if (this.parent is BaseObject)
				{
					BaseObject(parent).removeObject(this);
				}
				else
				{
					parent.removeChild(this);
				}
				tickEnable = false;
			}
		}
		
	}

}