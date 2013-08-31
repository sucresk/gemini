package gemini.skeleton2D 
{
	import flash.events.EventDispatcher;
	import gemini.skeleton2D.skin.ISkin;
	/**
	 * ...
	 * @author 
	 */
	public class Bone extends EventDispatcher
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:int = 0;
		public var rotation:Number = 0;
		public var length:int = 0;
		public var parent:Bone;
		public var children:Vector.<Bone>;
		public var name:String;
		public var skin:ISkin;
		public var realX:Number = 0;
		public var realY:Number = 0;
		public var realRotation:Number = 0;
		public var realScaleX:Number = 1;
		public var realScaleY:Number = 1;
		public var skewX:Number = 0;
		public var skewY:Number = 0;
		public var alpha:Number = 1;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var realSkewX:Number = 0;
		public var realSkewY:Number = 0;
		public var realAlpha:Number = 1;
		public var isRoot:Boolean;
		
		private var _motions:Vector.<Motion>;
		private var _motionDict:Object;
		
		private var _loop:Boolean = true;
		private var _curMotion:Motion;
		private var _realFrame:int;
		private var _curFrame:int;
		private var _curAnimation:String;
		private var _totalFrame:int;
		private var _curFrameScale:Number = 0;
		private var _realFrameScale:Number = 0;
		private var _delay:int;
		private var _pinX:Number;
		private var _pinY:Number;
		
		public function Bone() 
		{
			_motions = new Vector.<Motion>();
			_motionDict = new Object();
			children = new Vector.<Bone>();
			//<bone name="forearm_l" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
		}
		
		public function addBone(bone:Bone):void
		{
			children.push(bone);
			bone.parent = this;
		}
		
		public function removeBone(bone:Bone):void
		{
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				if (children[i] == bone)
				{
					children.splice(i, 1);
					return;
				}
			}
		}
		
		public function addMotion(motion:Motion):void
		{
			_motions.push(motion);
			_motionDict[motion.name] = motion;
			if (_totalFrame < motion.totalFrames)
			{
				_totalFrame = motion.totalFrames;
			}
		}
		
		public function removeMotion(name:String):void
		{
			_curMotion = null;
			delete _motionDict[name];
			for (var i:int = 0, len:int = _motions.length; i < len; i++)
			{
				if (_motions[i].name == name)
				{
					_motions.splice(i, 1);
					break;
				}
			}
		}
		
		public function setAnimation(name:String):void
		{
			_curMotion = _motionDict[name];
			_curAnimation = name;
			_curFrame = 0;
			_curFrameScale = 0;
			if (_curMotion == null)
			{
			}
			else
			{
				_totalFrame = _curMotion.totalFrames;
				_delay = _curMotion.delay;
			}
			
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				children[i].setAnimation(name);
			}
		}
		
		protected function setFrameScale(frame:Number):void
		{
			if (_curMotion != null)
			{
				_curFrameScale = frame - _delay;
				_realFrameScale = _curFrameScale;
				if (_curFrameScale >= _totalFrame)
				{
					if (_loop)
					{
						_realFrameScale = _curFrameScale % _totalFrame;
					}
					else
					{
						_realFrameScale = _totalFrame - 1;
					}
				}
				if (_curFrameScale < 0)
				{
					if (_loop)
					{
						_realFrameScale = _curFrameScale % _totalFrame + _totalFrame;
					}
					else
					{
						_realFrameScale = 0;
					}
				}
				var prop:Number;
				prop = _curMotion.getXScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realX = x = prop;
				}
				prop = _curMotion.getYScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realY = y = prop;
				}
				
				prop = _curMotion.getRotationScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realRotation = rotation = prop;
				}
				
				prop = _curMotion.getAlphaScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realAlpha = alpha = prop;
				}
				
				prop = _curMotion.getScaleXScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realScaleX = scaleX = prop;
				}
				prop = _curMotion.getScaleYScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realScaleY = scaleY = prop;
				}
				
				prop = _curMotion.getSkewXScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realSkewX = skewX = prop;
				}
				prop = _curMotion.getSkewYScale(_realFrameScale);
				if (!isNaN(prop))
				{
					realSkewY = skewY = prop;
				}
				
			}
			
			if (parent != null)
			{
				realX = parent.pinX;
				realY = parent.pinY;
				if (parent is Skeleton)
				{
					realX += x;
					realY += y;
				}
				realRotation = parent.realRotation + rotation;
				realScaleX = parent.realScaleX * scaleX;
				realScaleY = parent.realScaleY * scaleY;
				realAlpha = parent.realAlpha * alpha;
				realSkewX = parent.realSkewX + skewX;
				realSkewY = parent.realSkewY + skewY;
			}
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				children[i].setFrameScale(frame);
			}
		}
		
		public function tick(interval:uint):void
		{
			if (skin != null)
			{
				skin.render();
			}
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				children[i].tick(interval);
			}
		}
		
		public function get pinX():Number 
		{
			var angle:Number = realRotation * Math.PI / 180;
			_pinX = realX + Math.cos(angle) * length;
			return _pinX;
		}
		
		public function get pinY():Number 
		{
			var angle:Number = realRotation * Math.PI / 180;
			_pinY = realY + Math.sin(angle) * length;
			return _pinY;
		}
		
		public function get motions():Vector.<Motion> 
		{
			return _motions;
		}
		
		public function get motionDict():Object 
		{
			return _motionDict;
		}
		
	}

}