package  gemini.view.boiler
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import gemini.component.BaseObject;
	import gemini.view.bitmap.IBitmapDraw;
	/**
	 * ...
	 * @author gemini
	 */
	public class BitmapBoiler extends BaseObject
	{
		public var softFiled:String;
		public var reDraw:Boolean;
		public var drawOffest:Point = new Point(0, 0);
		public var itemColorTransform:ColorTransform;
		
		protected var _mouseChildren:Vector.<DisplayObject>;
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _backgroundColor:uint;
		protected var _mouseOverObj:Dictionary = new Dictionary();
		protected var _mouseDownObj:Dictionary = new Dictionary();
		protected var _isMouseDown:Boolean;
		
		public function BitmapBoiler(width:int, height:int,transparent:Boolean = true,fillColor:uint = 0xffffff) 
		{
			_backgroundColor = fillColor;
			_bitmapData = new BitmapData(width, height, transparent, fillColor);
			_bitmap = new Bitmap(_bitmapData);
			addChild(_bitmap);
			_mouseChildren = new Vector.<DisplayObject>();
			
			
		}
		
		override protected function init():void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			_isMouseDown = false;
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			_isMouseDown = true;
		}
		
		override public function addObject(obj:BaseObject):void 
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
							newObjects.splice(i, 0, obj);
							minPriority = false;
							break;
						}
					}
					if (minPriority)
					{
						newObjects.push(obj);
					}
				}
			}
		}
		
		override public function removeObject(obj:BaseObject):void 
		{
			var objIndex:int;
			if ( obj !== null)
			{
				objIndex = newObjects.indexOf(obj);
				if (objIndex != -1)
				{
					newObjects.splice(objIndex, 1);
				}
			}
		}
		
		public function addObjects(objs:Array):void
		{
			for (var i:int = 0, len:int = objs.length; i < len; i++)
			{
				addDisplayObj(DisplayObject(objs[i]));
			}
		}
		
		public function addDisplayObj(obj:DisplayObject):void
		{
			if (obj == null)
				return;
			newObjects.push(obj);
		}
		
		public function addDisplayObjAt(obj:DisplayObject, index:int):void
		{
			newObjects.splice(index, 0, obj);
		}
		
		public function removeDisplayObj(obj:DisplayObject):void
		{
			var index:int = newObjects.indexOf(obj);
			if (index != -1)
			{
				newObjects.splice(index, 1);
			}
		}
		
		public function render():void
		{
			if (reDraw)
				_bitmapData.fillRect(_bitmapData.rect,_backgroundColor)
			
			_bitmapData.lock();
			for (var i:int = 0, len:int = newObjects.length; i < len; i++)
			{
				drawChild(newObjects[i] as DisplayObject);
			}
			
			_bitmapData.unlock();
		}
		
		override public function tick(intervalTime:uint):void 
		{
			render();
			if (mouseEnabled)
			{
				dispatchMouseEvent();
			}
		}
		
		private function drawChild(obj:DisplayObject):void
		{
			if (obj is IBitmapDraw)
			{
				IBitmapDraw(obj).drawToBitmapData(_bitmapData, drawOffest.x, drawOffest.y);
			}
			else
			{
				var m:Matrix = getMatrixAt(obj as DisplayObject,this);
				if (!m)
					m = (obj as DisplayObject).transform.matrix;
				
				if (drawOffest)
					m.translate(drawOffest.x,drawOffest.y);
				_bitmapData.draw(obj as DisplayObject, m, itemColorTransform);
			}
			
			
			if (mouseEnabled)
			{
				if (obj.hitTestPoint(mouseX, mouseY))
				{
					_mouseChildren.push(obj);
				}
			}
		}
		
		private function dispatchMouseEvent():void
		{
			
			if (mouseEnabled)
			{
				_mouseChildren.forEach(dispatch);
				
				for ( var obj:* in _mouseOverObj)
				{
					if ( _mouseChildren.indexOf(obj) < 0)
					{
						delete _mouseOverObj[obj];
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
						obj.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					}
				}
				if (!_isMouseDown)
				{
					for (obj in _mouseDownObj)
					{
						delete _mouseDownObj[obj];
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
					}
				}
			}
			_mouseChildren.length = 0;
		}
		
		private function dispatch(item:DisplayObject, index:int, vector:Vector.<DisplayObject>):void
		{
			if (!_mouseOverObj[item])
			{
				item.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
				item.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				_mouseOverObj[item] = true;
			}
			if (_isMouseDown && !_mouseDownObj[item])
			{
				_mouseDownObj[item] = true;
				item.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}

		
		private function dispatchDown(item:DisplayObject, index:int, vector:Vector.<DisplayObject>):void 
		{
			item.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		private function getMatrixAt(obj:DisplayObject, container:DisplayObject):Matrix
		{
			if (obj == container)
				return new Matrix();
			else if (obj.stage != null)
			{
				var m1:Matrix = obj.transform.concatenatedMatrix;
				var m2:Matrix = container.transform.concatenatedMatrix;
				m2.invert();
				m1.concat(m2);
				return m1;
			}
			else 
			{
				m1 = obj.transform.matrix;
				var curObj:DisplayObject = obj.parent;
				while (container != curObj)
				{
					if (curObj == null)
						return null
					else
					{
						m1.concat(curObj.transform.matrix);
						curObj = curObj.parent;
					}
				}
				return m1;
			}
		}
	}

}