package gemini.component 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class PicContainer extends BaseObject
	{
		private static const MAX_CACHE:int = 100;
		
		private static var _cacheBitmaps:Object = new Object();
		private static var _cacheNum:int = 0;
		
		private var _picContainer:Sprite;
		private var _url:String;
		private var _gap:int = 5;
		
		public function PicContainer(skin:*) 
		{
			super(skin);
			_picContainer = new Sprite();
			addChild(_picContainer);
		}
		
		public function set gap(value:int):void 
		{
			_gap = value;
		}
		
		public function set url(v:String):void
		{
			clearPicContainer();
			if (v == null)
				return;
			_url = v;
			if (_cacheBitmaps[_url] != null)
			{
				addBitmap(_cacheBitmaps[_url]);
			}
			else
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedCompletedHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.load(new URLRequest(_url));
				
			}
			
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			trace(e);
		}

		private function loadedCompletedHandler(e:Event):void 
		{
			
			var loader:Loader = Loader(e.target.loader);
			try 
			{
				var bitmapData:BitmapData = new BitmapData(loader.width, loader.height);
				bitmapData.draw(loader.content);
				addBitmap(bitmapData);
				if (_cacheNum < MAX_CACHE)
				{
					_cacheBitmaps[_url] = bitmapData;
					_cacheNum++;
				}
				
			}
			catch (e:Error)
			{
				//_picContainer.addChild(loader);
				addLoader(loader);
			}
			
		}
		
		private function addBitmap(bitmapData:BitmapData):void
		{
			var bitmap:Bitmap = new Bitmap(bitmapData);
			clearPicContainer();
			_picContainer.addChild(bitmap);
			alignToCenter();
		}
		
		public function addSimpleIcon(icon:BaseObject):void
		{
			clearPicContainer();
			_picContainer.addChild(icon);
		}
		
		private function addLoader(loader:Loader):void
		{
			clearPicContainer();
			_picContainer.addChild(loader);
			alignToCenter()
		}
		
		private function alignToCenter():void
		{
			scaleTo(_picContainer, content.width - _gap, content.height - _gap);
			_picContainer.x = (content.width - _picContainer.width) * 0.5;
			_picContainer.y = (content.height - _picContainer.height) * 0.5;
		}
		
		public function clear():void
		{
			clearPicContainer();
		}
		
		private function clearPicContainer():void
		{
			while (_picContainer.numChildren > 0)
			{
				_picContainer.removeChildAt(0);
			}
			_picContainer.scaleX = _picContainer.scaleY = 1;
		}
		
		private function scaleTo(target:DisplayObject, strictWidth:int, strictHeight:int):void
		{
			if (target.width < strictWidth && target.height < strictHeight)
			{
				scaleMin(target, strictWidth, strictHeight);
			}
			else
			{
				scaleMax(target, strictWidth, strictHeight);
			}
		}
		
		private function scaleMax(target:DisplayObject, maxWidth:int, maxHeight:int):void
		{
			var scaleRateA:Number;
			var scaleRateB:Number;
			if (target.width > maxWidth)
			{
				scaleRateA =  maxWidth / target.width;
			}
			if (target.height > maxHeight)
			{
				scaleRateB = maxHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA <= scaleRateB ? scaleRateA : scaleRateB);
		}
		
		private function scaleMin(target:DisplayObject, minWidth:int, minHeight:int):void
		{
			var scaleRateA:Number;
			var scaleRateB:Number;
			if (target.width < minWidth)
			{
				scaleRateA = minWidth /  target.width;
			}
			if (target.height < minHeight)
			{
				scaleRateB = minHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA >= scaleRateB ? scaleRateA : scaleRateB);
		}
		
	}

}