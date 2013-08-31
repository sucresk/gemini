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
		
		//大小不超过背景
		public var fitToBg:Boolean = false;
		/**
		 * true,最小scale对齐，不超过边界，false最大scale对齐，超过边界
		 */
		public var fitToMin:Boolean = true;
		public var keepScale:Boolean = false;
		public var cacheToBmp:Boolean = true;
		
		private var _picContainer:Sprite;
		private var _url:String;
		private var _gap:int = 5;
		
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		private var _loader:Loader;
		private var _loading:Boolean;
		private var _changeUrl:String;
		
		
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
			if (_loading)
			{
				_changeUrl = v;
				return;
			}
			if (_url != v)
			{
				clearPicContainer();
				_url = v;
				if (v == null)
					return;
				if (_cacheBitmaps[_url] != null)
				{
					addBitmap(_cacheBitmaps[_url]);
				}
				else
				{
					//if (_loading)
					//{
						//_loader.unload();
						//_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedCompletedHandler);
						//_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
						//_loader = null;
					//}
					
					if (_loader == null)
					{
						_loader = new Loader();
					}
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedCompletedHandler);
					_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					_loader.load(new URLRequest(_url));
					
					_loading = true;
				}
			}
			
		}
		
		public function get offsetX():Number 
		{
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void 
		{
			_offsetX = value;
		}
		
		public function get offsetY():Number 
		{
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void 
		{
			_offsetY = value;
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			trace(e);
		}

		private function loadedCompletedHandler(e:Event):void 
		{
			
			try 
			{
				var bitmapData:BitmapData = new BitmapData(_loader.width, _loader.height,true,0);
				bitmapData.draw(_loader.content);
				addBitmap(bitmapData);
				if (cacheToBmp && _cacheNum < MAX_CACHE)
				{
					_cacheBitmaps[_url] = bitmapData;
					_cacheNum++;
				}
				_loader.unload();
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedCompletedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				//_loader = null;
			}
			catch (e:Error)
			{
				addLoader(_loader);
			}
			_loading = false;
			if (_changeUrl != null && _changeUrl != _url)
			{
				url = _changeUrl;
			}
			_changeUrl = null;
		}
		
		private function addBitmap(bitmapData:BitmapData):void
		{
			var bitmap:Bitmap = new Bitmap(bitmapData);
			clearPicContainer();
			_picContainer.addChild(bitmap);
			alignToCenter();
		}
		
		public function addBmp(bmp:Bitmap):void
		{
			clearPicContainer();
			_picContainer.addChild(bmp);
			alignToCenter();
		}
		public function addSimpleIcon(icon:BaseObject):void
		{
			clearPicContainer();
			_picContainer.addChild(icon);
			alignToCenter();
		}
		
		private function addLoader(loader:Loader):void
		{
			clearPicContainer();
			_picContainer.addChild(loader);
			alignToCenter();
		}
		
		private function alignToCenter():void
		{
			if (fitToBg)
			{
				if (keepScale)
				{
					scaleTo(_picContainer, content.width - _gap, content.height - _gap);
				}
				else
				{
					_picContainer.width = content.width - _gap;
					_picContainer.height = content.height - _gap;
				}
			}
			_picContainer.x = (content.width - _picContainer.width) * 0.5 + _offsetX;
			_picContainer.y = (content.height - _picContainer.height) * 0.5 + _offsetY;
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
			if (!fitToMin)
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
			var scaleRateA:Number = 1;
			var scaleRateB:Number = 1;
			//if (target.width > maxWidth)
			{
				scaleRateA =  maxWidth / target.width;
			}
			//if (target.height > maxHeight)
			{
				scaleRateB = maxHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA <= scaleRateB ? scaleRateA : scaleRateB);
		}
		
		private function scaleMin(target:DisplayObject, minWidth:int, minHeight:int):void
		{
			var scaleRateA:Number = 0;
			var scaleRateB:Number = 0;
			//if (target.width < minWidth)
			{
				scaleRateA = minWidth /  target.width;
			}
			//if (target.height < minHeight)
			{
				scaleRateB = minHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA >= scaleRateB ? scaleRateA : scaleRateB);
		}
		
		override public function destroy():void 
		{
			if (_loader)
			{
				_loader.unload();
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedCompletedHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loader = null;
			}
			super.destroy();
		}
		
	}

}