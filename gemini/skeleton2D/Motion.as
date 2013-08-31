package gemini.skeleton2D 
{
	import gemini.skeleton2D.easing.Linear;
	/**
	 * ...
	 * @author 
	 */
	public class Motion 
	{
		public var name:String;
		
		private var _keyFrames:Vector.<KeyFrame>;
		private var subMotions:Vector.<Motion>;
		private var curFrame:KeyFrame;
		private var nextFrame:KeyFrame;
		
		private var t:Number;//time// 过了几帧 时间控制
		private var d:Number;//duration//总共几帧 时间控制
				
		private var b:Number;//begin//初始数值 数值控制
		private	var c:Number;//change//改变量 数值控制
		
		private var ease:Function;
		
		public var totalFrames:int = 0;
		public var frameRate:int;
		public var delay:int;
		
		public function Motion() 
		{
			_keyFrames = new Vector.<KeyFrame>();
		}
		
		public function addKeyFrame(frame:KeyFrame):void
		{
			if (totalFrames < frame.index + 1)
			{
				totalFrames = frame.index + 1;
			}
			
			for (var i:int = 0, len:int = _keyFrames.length; i < len; i++)
			{
				if (_keyFrames[i].index == frame.index)
				{
					_keyFrames.splice(i, 1, frame);
					return;
				}
				if (_keyFrames[i].index > frame.index)
				{
					_keyFrames.splice(i, 0, frame);
					return;
				}
			}
			_keyFrames.push(frame);
		}
		
		public function removeKeyFrame(frameIndex:int):void
		{
			for (var i:int = 0, len:int = _keyFrames.length; i < len; i++)
			{
				if (_keyFrames[i].index == frameIndex)
				{
					_keyFrames.splice(i, 1);
					return;
				}
			}
		}
		
		private function setFrame(frame:int):void
		{
			if (_keyFrames.length == 0)
				return;
			else if (_keyFrames.length == 1)
			{
				curFrame = nextFrame = _keyFrames[0];
				return;
			}
			else
			{
				if (nextFrame != null && curFrame != nextFrame && frame < nextFrame.index && frame > curFrame.index)
				{
					t = frame - curFrame.index;
					return;
				}
				else
				{
					for (var i:int = 0, len:int = _keyFrames.length; i < len; i++)
					{
						if (_keyFrames[i].index == frame)
						{
							curFrame = _keyFrames[i];
							if (i < len - 1)
							{
								nextFrame = _keyFrames[i + 1];
							}
							else
							{
								nextFrame = curFrame;
							}
							ease = curFrame.ease;
							d = nextFrame.index - curFrame.index;
							t = frame - curFrame.index;
							return;
						}
						else if (_keyFrames[i].index > frame)
						{
							nextFrame = _keyFrames[i];
							if (i > 0)
							{
								curFrame = _keyFrames[i - 1];
							}
							else
							{
								curFrame = nextFrame;
							}
							ease = curFrame.ease;
							d = nextFrame.index - curFrame.index;
							t = frame - curFrame.index;
							return;
						}
						
					}
					curFrame = nextFrame = _keyFrames[i-1];
				}
			}
			
		}
		
		//对帧速缩放，只缩小，用于在慢动作的时候平滑动画
		
		private function setFrameScale(frame:Number):void
		{
			if (_keyFrames.length == 0)
				return;
			else if (_keyFrames.length == 1)
			{
				curFrame = nextFrame = _keyFrames[0];
				return;
			}
			else
			{
				if (nextFrame != null && curFrame != nextFrame && frame < nextFrame.index && frame > curFrame.index)
				{
					ease = curFrame.ease;
					t = frame - curFrame.index;
					return;
				}
				else
				{
					for (var i:int = 0, len:int = _keyFrames.length; i < len; i++)
					{
						if (_keyFrames[i].index == frame)
						{
							curFrame = _keyFrames[i];
							if (i < len - 1)
							{
								nextFrame = _keyFrames[i + 1];
							}
							else
							{
								nextFrame = curFrame;
							}
							ease = curFrame.ease;
							d = nextFrame.index - curFrame.index;
							t = frame - curFrame.index;
							return;
						}
						else if (_keyFrames[i].index > frame)
						{
							nextFrame = _keyFrames[i];
							if (i > 0)
							{
								curFrame = _keyFrames[i - 1];
							}
							else
							{
								curFrame = nextFrame;
							}
							ease = curFrame.ease;
							d = nextFrame.index - curFrame.index;
							t = frame - curFrame.index;
							return;
						}
						
					}
					curFrame = nextFrame = _keyFrames[i-1];
				}
			}
			
		}
		
		private function getFramePropScale(prop:String, frame:Number):Number
		{
			setFrameScale(frame);
			if (curFrame == null)
				return NaN;
			if (frame == 0.0)
			{
				return curFrame[prop];
			}
			if (isNaN(curFrame[prop]) || isNaN(nextFrame[prop]))
			{
				return NaN;
			}
			if (curFrame == nextFrame)
			{
				return curFrame[prop];
			}
			else
			{
				b = curFrame[prop];
				c = nextFrame[prop] - b;
				if (d == 0)
				{
					return b;
				}
				else
				{
					return ease(t, b, c, d);
				}
			}
		}
		
		private function getFrameProp(prop:String, frame:int):Number
		{
			setFrame(frame);
			if (curFrame == null)
				return NaN;
			if (frame == 0)
			{
				return curFrame[prop];
			}
			if (isNaN(curFrame[prop]) || isNaN(nextFrame[prop]))
			{
				return NaN;
			}
			if (curFrame == nextFrame)
			{
				return curFrame[prop];
			}
			else
			{
				b = curFrame[prop];
				c = nextFrame[prop] - b;
				if (d == 0)
				{
					return b;
				}
				else
				{
					return ease(t, b, c, d);
				}
				//percent = (frame - curFrame.index) / (nextFrame.index - curFrame.index);
				//return (nextFrame[prop] - curFrame[prop]) * percent + curFrame[prop];
			}
		}
		
		public function getX(frame:int):Number
		{
			return getFrameProp("x", frame);
		}
		
		public function getY(frame:int):Number
		{
			return getFrameProp("y", frame);
		}
		
		public function getRotation(frame:int):Number
		{
			return getFrameProp("rotation", frame);
		}
		
		public function getScaleX(frame:int):Number
		{
			return getFrameProp("scaleX", frame);
		}
		
		public function getScaleY(frame:int):Number
		{
			return getFrameProp("scaleY", frame);
		}
		
		public function getSkewX(frame:int):Number
		{
			return getFrameProp("skewX", frame);
		}
		
		public function getSkewY(frame:int):Number
		{
			return getFrameProp("skewY", frame);
		}
		
		public function getAlpha(frame:int):Number
		{
			return getFrameProp("alpha", frame);
		}
		
		public function getXScale(frame:Number):Number
		{
			return getFramePropScale("x", frame);
		}
		
		public function getYScale(frame:Number):Number
		{
			return getFramePropScale("y", frame);
		}
		
		public function getRotationScale(frame:Number):Number
		{
			return getFramePropScale("rotation", frame);
		}
		
		public function getScaleXScale(frame:Number):Number
		{
			return getFramePropScale("scaleX", frame);
		}
		
		public function getScaleYScale(frame:Number):Number
		{
			return getFramePropScale("scaleY", frame);
		}
		
		public function getSkewXScale(frame:Number):Number
		{
			return getFramePropScale("skewX", frame);
		}
		
		public function getSkewYScale(frame:Number):Number
		{
			return getFramePropScale("skewY", frame);
		}
		
		public function getAlphaScale(frame:Number):Number
		{
			return getFramePropScale("alpha", frame);
		}
		
		public function get keyFrames():Vector.<KeyFrame> 
		{
			return _keyFrames;
		}
		
	}

}