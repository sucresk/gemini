package gemini.skeleton2D 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import gemini.skeleton2D.easing.Back;
	import gemini.skeleton2D.easing.Bounce;
	import gemini.skeleton2D.easing.Linear;
	import gemini.skeleton2D.easing.*;
	import gemini.skeleton2D.events.Skeleton2DEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Skeleton extends Bone
	{
		private var _motions:Vector.<String>;
		private var _motionDict:Object;
		private var _allBones:Vector.<Bone>;
		private var _boneDict:Object;
		private var _curMotion:String;
		
		private var _loop:int;
		private var _pause:Boolean;
		private var _yoyo:Boolean = false;
		private var _realFrame:int;
		private var _curFrame:int;
		private var _curAnimation:String;
		private var _totalFrame:int;
		private var _frameRate:int = 30;
		private var _frameTime:uint = 33;
		private var _tickTime:uint = 0;
		private var _speed:Number = 1;
		private var _smoothAnimation:Boolean = true;
		private var _curFrameScale:Number = 0;
		private var _realFrameScale:Number = 0;
		
		Back; Bounce;Circ,Cubic,EaseLookup,Elastic,Linear,Quad,Quart,Quint,RoughEase,Sine,SteppedEase,Strong
		public function Skeleton() 
		{
			x = 0;
			y = 0;
			rotation = 0;
			parent = null;
			name = "Skeletion";
			
			children = new Vector.<Bone>();
			_motions = new Vector.<String>();
			_allBones = new Vector.<Bone>();
			_boneDict = new Object();
			_motionDict = new Object();
		}
		
		/**
		 * 
		 * @param	boneXml
		 * 类似这个结构
		 * //<skeleton name="test">
				//<bone name="head" x="-13.8" y="-33.7" z="18" rotation="0" length="1">
					//<bone name="head1" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
				//</bone>
				//<bone name="arm_l" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
				//<bone name="arm_r" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
				//<bone name="leg_l" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
				//<bone name="leg_r" x="-13.8" y="-33.7" z="18" rotation="0" length="1"/>
			//</skeleton>
		 */
		public function loadBonesFromXml(boneXml:XML):void
		{
			
			name = boneXml.@name;
			
			createBonesFromXml(this, boneXml);
			_allBones.sort(sortByZ);
		}
		
		private function sortByZ(a:Bone, b:Bone):int
		{
			if (a.z > b.z)
				return 1;
			else
				return -1;
		}
		
		private function createBonesFromXml(parent:Bone, xml:XML):void
		{
			var children:XMLList = xml.child("bone");
			for (var i:int = 0, len:int = children.length(); i < len; i++)
			{
				var bone:Bone = new Bone();
				bone.name = children[i].@name;
				parent.children.push(bone);
				bone.parent = parent;
				_allBones.push(bone);
				_boneDict[bone.name] = bone;
				
				if (String(children[i].@x) != "")
				{
					bone.x = Number(children[i].@x);
				}
				if (String(children[i].@y) != "")
				{
					bone.y = Number(children[i].@y);
				}
				if (String(children[i].@z) != "")
				{
					bone.z = Number(children[i].@z);
				}
				if (String(children[i].@rotation) != "")
				{
					bone.rotation = Number(children[i].@rotation);
				}
				if (String(children[i].@scaleX) != "")
				{
					bone.scaleX = Number(children[i].@scaleX);
				}
				if (String(children[i].@scaleY) != "")
				{
					bone.scaleY = Number(children[i].@scaleY);
				}
				if (String(children[i].@alpha) != "")
				{
					bone.alpha = Number(children[i].@alpha);
				}
				if (String(children[i].@skewX) != "")
				{
					bone.skewX = Number(children[i].@skewX);
				}
				if (String(children[i].@skewY) != "")
				{
					bone.skewY = Number(children[i].@skewY);
				}
				if (String(children[i].@length) != "")
				{
					bone.length = Number(children[i].@length);
				}
				if (parent == this)//根骨骼
				{
					bone.isRoot = true;
					bone.realX = bone.x;
					bone.realY = bone.y;
					bone.realRotation = bone.rotation;
					bone.realScaleX = bone.scaleX;
					bone.realScaleY = bone.scaleY;
					bone.realSkewX = bone.skewX;
					bone.realSkewY = bone.skewY;
					bone.realAlpha = bone.alpha;
				}
				else
				{
					bone.isRoot = false;
					//bone.realX = bone.x + parent.realX;
					//bone.realY = bone.y + parent.realY;
					bone.realX = bone.parent.pinX;
					bone.realY = bone.parent.pinY;
					bone.realRotation = bone.rotation + parent.realRotation;
					bone.realScaleX = bone.scaleX * parent.realScaleX;
					bone.realScaleY = bone.scaleY * parent.realScaleY;
					bone.realSkewX = bone.skewX + parent.realSkewX;
					bone.realSkewY = bone.skewY + parent.realSkewY;
					bone.realAlpha = bone.alpha * parent.realAlpha;
				}

				if (children[i].hasOwnProperty("bone"))
				{
					createBonesFromXml(bone, children[i]);
				}
			}
		}
		
		override public function addBone(bone:Bone):void 
		{
			children.push(bone);
			bone.parent = this;
			serializeBone(bone);
			_allBones.sort(sortByZ);
		}
		
		public function serializeBone(bone:Bone):void
		{
			if (_boneDict[bone.name] != null)
			{
				trace("WARNING!!! override the same name bone!");
			}
			_boneDict[bone.name] = bone;
			if (_allBones.indexOf(bone) == -1)
			{
				_allBones.push(bone);
			}
			
			for (var i:int = 0, len:int = bone.children.length; i < len; i++)
			{
				serializeBone(bone.children[i]);
			}
		}
		
		
		public function loadAnimationFromXml(animXML:XML):void
		{
			if (_allBones.length <= 0 || animXML == null)
				return;
			var motions:XMLList = animXML.child("motion");
			var motionXml:XML;
			var partMotion:XML;
			var keyFrameXmls:XMLList;
			var keyFrameXml:XML;
			var motion:Motion;
			
			for (var i:int = 0, len:int = motions.length(); i < len; i++)
			{
				motionXml = motions[i];
				_motions.push(motionXml.@name);
				_motionDict[motionXml.@name] = int(motionXml.@totalFrame);
				for (var j:int = 0, leng:int = motionXml.children().length(); j < leng; j++)
				{
					partMotion = motionXml.children()[j];
					keyFrameXmls = partMotion.child("keyframe");
					var lengt:int = keyFrameXmls.length();
					if (lengt > 0)
					{
						motion = new Motion();
						motion.delay = int(partMotion.@delay);
						motion.name = String(motionXml.@name);
						motion.totalFrames = int(motionXml.@totalFrame);
						motion.frameRate = int(motionXml.@frameRate);
						var bone:Bone = _boneDict[partMotion.name()];
						if (bone != null)
						{
							bone.addMotion(motion);
						}
						var keyFrame:KeyFrame;
						for (var k:int = 0; k < lengt; k++)
						{
							keyFrameXml = keyFrameXmls[k];
							keyFrame = new KeyFrame();
							
							if (String(keyFrameXml.@index) != "")
							{
								keyFrame.index = int(keyFrameXml.@index);
							}
							else
							{
								continue;
							}
							if (String(keyFrameXml.@x) != "")
							{
								keyFrame.x = Number(keyFrameXml.@x);
							}
							if (String(keyFrameXml.@y) != "")
							{
								keyFrame.y = Number(keyFrameXml.@y);
							}
							if (String(keyFrameXml.@rotation) != "")
							{
								keyFrame.rotation = Number(keyFrameXml.@rotation);
							}
							if (String(keyFrameXml.@scaleX) != "")
							{
								keyFrame.scaleX = Number(keyFrameXml.@scaleX);
							}
							if (String(keyFrameXml.@scaleY) != "")
							{
								keyFrame.scaleY = Number(keyFrameXml.@scaleY);
							}
							if (String(keyFrameXml.@skewX) != "")
							{
								keyFrame.skewX = Number(keyFrameXml.@skewX);
							}
							if (String(keyFrameXml.@skewY) != "")
							{
								keyFrame.skewY = Number(keyFrameXml.@skewY);
							}
							if (String(keyFrameXml.@alpha) != "")
							{
								keyFrame.alpha = Number(keyFrameXml.@alpha);
							}
							if (String(keyFrameXml.@delay) != "")
							{
								keyFrame.delay = int(keyFrameXml.@delay);
							}
							if (String(keyFrameXml.@ease) != "")
							{
								keyFrame.ease = getEase(String(keyFrameXml.@ease));
							}
							motion.addKeyFrame(keyFrame);
						}
					}
				}
			}
		}
		
		private function getEase(ease:String):Function
		{
			var arr:Array = ease.split(".");
			try
			{
				var easeClass:Class = getDefinitionByName("skeleton2D.easing." + arr[0]) as Class;
				if (easeClass[arr[1]] is Function)
				{
					return easeClass[arr[1]];
				}
				return Linear.easeNone; 
			}
			catch (e:Error)
			{
				return Linear.easeNone;
			}
			return Linear.easeNone;
		}
		
		public function addAnimation(name:String, totalFrame:int):void
		{
			if (_motionDict[name] != null)
			{
				
			}
			else
			{
				_motions.push(name);
			}
			_motionDict[name] = totalFrame;
		}
		
		public function removeAnimation(name:String):void
		{
			delete _motionDict[name];
			for (var i:int = 0, len:int = _motions.length; i < len; i++)
			{
				if (_motions[i] == name)
				{
					_motions.splice(i, 1);
					break;
				}
			}
		}
		
		override public function setAnimation(name:String):void 
		{
			super.setAnimation(name);
			if (_motions.indexOf(name) != -1)
			{
				_curMotion = name;
				_curFrame = 0;
				_curFrameScale = 0;
				_curAnimation = name;
				if (_yoyo)
				{
					_totalFrame = _motionDict[name] * 2;
				}
				else
				{
					_totalFrame = _motionDict[name];
				}
			}
			else
			{
				trace("WARNNING there is no animtion: ",name);
				_curMotion = null;
			}
			
		}
		
		public function play(name:String,loop:int = -1,yoyo:Boolean = false):void
		{
			_yoyo = yoyo;
			setAnimation(name);
			_loop = loop;
			_tickTime = 0;
			_pause = _curMotion == null;
		}
		
		override public function tick(interval:uint):void 
		{
			if (!_pause)
			{
				if (_curAnimation != null)
				{
					_tickTime += (interval);
					while (_tickTime >= _frameTime)
					{
						_curFrameScale += _speed;
						_tickTime-= _frameTime;
						if (_curFrameScale >= _totalFrame)
						{
							dispatchEvent(new Skeleton2DEvent(Skeleton2DEvent.ANIMATION_COMPLETED, _curMotion));
							if (_loop > 0)
							{
								_loop--;
							}
							if (_loop == 0)
							{
								_pause = true;
								dispatchEvent(new Skeleton2DEvent(Skeleton2DEvent.ANIMATION_LOOP_COMPLETED,_curMotion));
								return;
							}
						}
					}
					if (_curFrameScale < 0)
					{
						_curFrameScale = _curFrameScale % _totalFrame + _totalFrame;
					}
					else
					{
						_curFrameScale = _curFrameScale % _totalFrame;
					}
					if (_yoyo)
					{
						if (_curFrameScale < _totalFrame / 2)
						{
							setFrameScale(_curFrameScale);
						}
						else
						{
							var yoyoFrame:Number = _totalFrame - _curFrameScale - 1;
							if (yoyoFrame < 0)
								yoyoFrame = 0;
							setFrameScale(yoyoFrame);
						}
					}
					else
					{
						setFrameScale(_curFrameScale);
					}
				}
			}
				
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				children[i].tick(interval);
			}
		}
		
		public function get frameRate():int 
		{
			return _frameRate;
		}
		
		public function set frameRate(value:int):void 
		{
			if (_frameRate != value)
			{
				_frameRate = value;
				_frameTime = int(1000 / _frameRate);
			}
			
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
		public function get smoothAnimation():Boolean 
		{
			return _smoothAnimation;
		}
		
		public function set smoothAnimation(value:Boolean):void 
		{
			_smoothAnimation = value;
		}
		
		public function get allBones():Vector.<Bone> 
		{
			return _allBones;
		}
		
		public function get boneDict():Object 
		{
			return _boneDict;
		}
		
		public function get pause():Boolean 
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void 
		{
			_pause = value;
		}
		
		public function get curFrame():Number 
		{
			return _curFrameScale;
		}
		
		public function set curFrame(value:Number):void 
		{
			_curFrameScale = value;
			setFrameScale(_curFrameScale);
			for (var i:int = 0, len:int = children.length; i < len; i++)
			{
				children[i].tick(0);
			}
		}
		
		public function get skeMtions():Vector.<String> 
		{
			return _motions;
		}
		
		public function get skeMotionDict():Object 
		{
			return _motionDict;
		}
		
		public function hasAnimation(name:String):Boolean
		{
			if (_motionDict[name] != null)
			{
				return true;
			}
			return false;
		}
		public function clone():Skeleton
		{
			//TODO:
			var ske:Skeleton = new Skeleton();
			return ske;
		}
	}

}