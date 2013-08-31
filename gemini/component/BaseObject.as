package gemini.component 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import gemini.manager.AssetManager;
	import gemini.manager.TickManager;
	import gemini.utils.AutoBuild;
	/**
	 * ...
	 * @author sucre
	 */
	public class BaseObject extends Sprite implements ITick
	{
		public static const FLIP_VERTICAL:int = 1;
		public static const FLIP_HORIZONTAL:int = 2;
		
		public static const ALIGN_LEFT:int = 1 << 0
		public static const ALIGN_RIGHT:int = 1 << 1;
		public static const ALIGN_HCENTER:int = 1 << 2;
		public static const ALIGN_TOP:int = 1 << 3;
		public static const ALIGN_BOTTOM:int = 1 << 4;
		public static const ALIGN_VCENTER:int = 1 << 5;
		public static const ALIGN_CENTER:int = ALIGN_VCENTER | ALIGN_HCENTER;
		
		public var baseObjects:Array;
		public var newObjects:Array;
		public var parentObject:BaseObject;
		public var content:Sprite;
		
		private var _drawPriority:int;
		private var _tooltipVars:Object;
		private var _tooltip:IToolTip;
		private var _tickEnable:Boolean;
		private var _interactiveEnable:Boolean = true;
		
		public function BaseObject(content:* = null,intercative:Boolean = true, autoBuild:Boolean = false, buildLayer:int = 1) 
		{
			baseObjects = new Array();
			newObjects = new Array();
			interactiveEnable = intercative;
			if (content != null)
			{
				setSkin(content);
			}
			if (autoBuild)
			{
				AutoBuild.buildAll(this,buildLayer);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			init();
		}
		
		protected function init():void
		{
			
		}
		
		protected function setSkin(skin:*):void
		{
			if (skin is String)
			{
				this.content = AssetManager.instance.getMovieClip(String(skin));
				if (this.content != null)
				{
					addChild(this.content);
				}
			}
			else if (skin is Sprite)
			{
				if (skin.parent != null)
				{
					var index:int = skin.parent.getChildIndex(skin);
					skin.parent.addChildAt(this, index);
					this.x = skin.x;
					this.y = skin.y;
					skin.x = 0;
					skin.y = 0;
				}
				this.content = skin;
				if (content is MovieClip)
					MovieClip(content).stop();
				addChild(this.content);
			}
		}
		
		public function get interactiveEnable():Boolean 
		{
			return _interactiveEnable;
		}
		
		public function set interactiveEnable(value:Boolean):void 
		{
			if (_interactiveEnable != value)
			{
				_interactiveEnable = value;
				if (_interactiveEnable)
				{
					mouseChildren = true;
					mouseEnabled = true;
				}
				else
				{
					mouseChildren = false;
					mouseEnabled = false;
				}
			}
		}
		
		/**
		 * 
		 * @param	obj 需要添加的BaseObject
		 */
		public function addObject( obj:BaseObject):void
		{
			var minPriority:Boolean = true;
			if (obj != null)
			{
				if ( newObjects.indexOf(obj) == -1)
				{
					if ( (obj.parent != null) && ( obj.parent is BaseObject))
					{
						BaseObject(obj.parent).removeObject(obj);
					}
					for (var i:int = 0; i < newObjects.length; i++)
					{
						if (newObjects[i].drawPriority > obj.drawPriority)
						{
							addChildAt(obj, getChildIndex(newObjects[i]));
							newObjects.splice(i, 0, obj);
							minPriority = false;
							break;
						}
					}
					if (minPriority)
					{
						newObjects.push(obj);
						addChild(obj);
					}
				}
			}
		}
		
		public function stop():void
		{
			if (content != null && content is MovieClip)
			{
				MovieClip(content).stop();
			}
		}
		
		public function destroy():void
		{
			if(_tooltip != null)
				setTip(null);
		}
		
		/**
		 * 
		 * @param	method 0回复原大小，1水平翻转，2垂直翻转
		 */
		public function manipulate( method:int):void
		{
			var tempMarix:Matrix;
			tempMarix = this.transform.matrix;
			if ( method == 0)
			{
				tempMarix.a = 1;
				tempMarix.b = 1;
				this.transform.matrix = tempMarix;
			}
			else if ( method == FLIP_VERTICAL)
			{
				if (scaleX > 0)
				{
					scaleX = -scaleX;
				}
			}
			else if ( method == FLIP_HORIZONTAL)
			{
				if (scaleY > 0)
				{
					scaleY = -scaleY;
				}
			}
		}
		
		public function removeObject(obj:BaseObject):void
		{
			var objIndex:int;
			if ( obj !== null)
			{
				objIndex = newObjects.indexOf(obj);
				if (objIndex != -1)
				{
					newObjects.splice(objIndex, 1);
					if ( (obj.parent != null) && (obj.parent == this))
					{
						removeChild(obj);
					}
					
				}
			}
		}
		
		/**
		 * 
		 * @param	xPox 设置x轴坐标
		 * @param	yPox 设置y轴坐标
		 * @param	mode 注册点模式 ALIGH_RIGHT,ALIGHT_TOP...
		 */
		public function setAlignPosition( xPox:Number , yPox:Number, mode:int = 0):void
		{
			if (( mode & ALIGN_RIGHT ) != 0)
			{
				x = xPox - width;
			}
			else if ( (mode & ALIGN_HCENTER) != 0)
			{
				x = xPox - width / 2;
			}
			else
			{
				x = xPox;
			}
			if ( ( mode & ALIGN_BOTTOM) != 0)
			{
				y = yPox - height;
			}
			else if ( (mode & ALIGN_VCENTER) != 0)
			{
				y = yPox - height / 2;
			}
			else
			{
				y = yPox;
			}
			
		}

		/**
		 * 
		 * @param	mcName 是content中的子的MovieClip的实例名
		 * @return 返回这个mc如果没有返回null
		 */
		public function getChildMovieClipInstance(mcName:String):MovieClip
		{
			if (content != null)
			{
				return (MovieClip(content[mcName]));
			}
			return null;
		}

		/**
		 * 设置优先级
		 */
		public function set drawPriority(priority:int):void
		{
			if ( _drawPriority != priority)
			{
				_drawPriority = priority;
				if ( (parent != null) && ( parent is BaseObject ))
				{
					BaseObject(parent).reinsert(this);
				}
			}
		}
		public function get drawPriority():int
		{
			return _drawPriority;
		}
		/**
		 * 
		 * @param	interval 间隔时间
		 * 这个方法调用了这个BaseObject的所有的字的tick
		 */
		public function tickBase( interval:int):void
		{
			var tempObject:BaseObject;
			for (var i:int ; i < baseObjects.length; i++ )
			{
				tempObject = baseObjects[i];
				if ( newObjects.indexOf(tempObject) != -1)
				{
					tempObject.tickBase(interval);
				}
			}
			tick(interval);
			addAndRemoveObject();
		}
		
		/**
		 * basetick时调用,当addObject的时候先加到newObjects里,当tick时,newObject就复制到BaseObjects里
		 */
		public function addAndRemoveObject():void
		{
			baseObjects.splice(0, baseObjects.length);
			for (var i:int = 0; i < newObjects.length; i++)
			{
				baseObjects[i] = newObjects[i];
			}
		}
		
		/**
		 * 
		 * @param	aBaseObject 插入的baseobject
		 */
		private function reinsert( aBaseObject:BaseObject):void
		{
			var aIndex:int;
			if ( aBaseObject.parent == this)
			{
				aIndex = newObjects.indexOf(aBaseObject);
				if ( aIndex != -1)
				{
					newObjects.splice( aIndex, 1);
					removeChild(aBaseObject);
				}
				var added:Boolean = false;
				for ( var i:int = 0; i < newObjects.length; i++)
				{
					if ( (aBaseObject.drawPriority < newObjects[i].drawPriority) && (contains(newObjects[i])))
					{
						addChildAt( aBaseObject, getChildIndex(newObjects[i]));
						newObjects.splice(i, 0, aBaseObject);
						added = true;
						break;
					}
				}
				if ( !added)//说明它的优先级最大
				{
					addChild( aBaseObject);
					newObjects.push(aBaseObject);
				}	
			}
		}

		/**
		 * 
		 * @param	textFiledName 此baseObject包含的textFiled的名字
		 * @return  返回这个textFilled
		 */
		public function getChildTextFieldInstance( textFiledName:String):TextField
		{
			if ( content != null)
			{
				return content[textFiledName];
			}
			return null;
		}
		
		public function tick(intervalTime:uint):void
		{
			
		}
		
		public function setTip(tooltip:IToolTip,vars:Object = null):void
		{
			if (_tooltip != null)
				_tooltip.hide();
				
			_tooltip = tooltip;
			_tooltipVars = vars;
			if (tooltip == null)
			{
				removeEventListener(MouseEvent.ROLL_OVER, showTooltipHandler);
				removeEventListener(MouseEvent.ROLL_OUT, hideTooltipHandler);
			}
			else
			{
				addEventListener(MouseEvent.ROLL_OVER, showTooltipHandler, false, 0, true);
				addEventListener(MouseEvent.ROLL_OUT, hideTooltipHandler, false, 0, true);
			}	
			
		}
		
		public function changeTip(vars:Object):void
		{
			if (_tooltip != null)
			{
				_tooltipVars = vars;
				_tooltip.setData(_tooltipVars);
			}
		}
		private function hideTooltipHandler(e:MouseEvent):void 
		{
			if (_tooltip != null)
				_tooltip.hide();
		}
		
		private function showTooltipHandler(e:MouseEvent):void 
		{
			if (_tooltip != null)
			{
				_tooltip.setData(_tooltipVars);
				var globalPos:Point = this.localToGlobal(new Point());
				_tooltip.setPosition(globalPos.x, globalPos.y, this.width, this.height);
				_tooltip.show();
			}
		}
		
		public function set tickEnable(v:Boolean):void
		{
			if (_tickEnable != v)
			{
				_tickEnable = v;
				if(v)
					TickManager.instance.registerTick(this);
				else
					TickManager.instance.unRegisterTick(this);
			}
			
		}
		
		public function set scale(v:Number):void
		{
			scaleX = scaleY = v;
		}
		//private static function buttonDownListener(e:MouseEvent):void{
            //var btn:MovieClip = MovieClip(e.currentTarget);
            //btn.gotoAndStop(("down" + btn["buttonSequence"]));
        //}
        //private static function buttonUpListener(e:MouseEvent):void{
            //var btn:MovieClip = MovieClip(e.currentTarget);
            //btn.gotoAndStop(("over" + btn["buttonSequence"]));
        //}
        //private static function buttonOutListener(e:MouseEvent):void{
            //var btn:MovieClip = MovieClip(e.currentTarget);
            //btn.gotoAndStop(("up" + btn["buttonSequence"]));
        //}
        //private static function buttonOverListener(e:MouseEvent):void{
            //var btn:MovieClip = MovieClip(e.currentTarget);
            //btn.gotoAndStop(("over" + btn["buttonSequence"]));
        //}
        //public static function setButtonSequence(btn:MovieClip, labelSuffix:String):void{
            //btn["buttonSequence"] = labelSuffix;
        //}
		//public static function setButtonMode(btn:MovieClip, mode:Boolean, labelSuffix:String=""):void{
            //if (btn != null){
                //setButtonSequence(btn, labelSuffix);
                //btn.gotoAndStop(("up" + btn["buttonSequence"]));
                //if (mode){
                    //btn.buttonMode = true;
                    //btn.addEventListener(MouseEvent.MOUSE_UP, buttonUpListener, false, 0, true);
                    //btn.addEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener, false, 0, true);
                    //btn.addEventListener(MouseEvent.ROLL_OVER, buttonOverListener, false, 0, true);
                    //btn.addEventListener(MouseEvent.ROLL_OUT, buttonOutListener, false, 0, true);
                    //btn.addEventListener(MouseEvent.MOUSE_OVER, buttonOverListener, false, 0, true);
                    //btn.addEventListener(MouseEvent.MOUSE_OUT, buttonOutListener, false, 0, true);
                //} else {
                    //btn.buttonMode = false;
                    //btn.removeEventListener(MouseEvent.MOUSE_UP, buttonUpListener);
                    //btn.removeEventListener(MouseEvent.MOUSE_DOWN, buttonDownListener);
                    //btn.removeEventListener(MouseEvent.ROLL_OVER, buttonOverListener);
                    //btn.removeEventListener(MouseEvent.ROLL_OUT, buttonOutListener);
                    //btn.removeEventListener(MouseEvent.MOUSE_OVER, buttonOverListener);
                    //btn.removeEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
                    //btn.removeEventListener(MouseEvent.MOUSE_OUT, buttonOutListener);
                    //setButtonSequence(btn, null);
                //};
            //};
        //}
		
	}

}