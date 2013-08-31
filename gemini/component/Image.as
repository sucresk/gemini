package gemini.component 
{
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.loading.ImageLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sucre
	 */
	public class Image extends BaseObject
	{
		public static var imageCache:Object = new Object();
		
		private var _url:String;
		private var _loader:ImageLoader;
		private var _loaerVars:ImageLoaderVars;
		private var _maxWidth:int = -1;
		private var _maxHeight:int = -1;
		private var _isLoading:Boolean;
		private var _waitting:DisplayObject;
		private var _bmp:Bitmap;
		
		public function Image(url:String = null, waitting:DisplayObject = null) 
		{
			super();
			_waitting = waitting;
			this.url = url;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(v:String):void
		{
			
			if (_url != v)
			{
				_url = v;
				if (v == null)
				{
					if (_loader != null)
						_loader.unload();
					return;
				}
				else if (imageCache[_url] != null)
				{
					setBitmap(imageCache[_url] as BitmapData);
				}
				else
				{
					if (_loader != null)
						_loader.unload();
					_loaerVars = new ImageLoaderVars();
					_loaerVars.onComplete(completedHandler);
					_loader = new ImageLoader(_url, _loaerVars);
					_loader.load();
					_isLoading = true;
					if (_waitting != null)
					{
						_waitting.x = -_waitting.width / 2;
						_waitting.y = _waitting.height / 2;
						addChild(_waitting)
					}
				}
			}
		}
		
		private function setBitmap(bmpD:BitmapData):void
		{
			if (_bmp == null)
				_bmp = new Bitmap();
			_bmp.bitmapData = bmpD;
			addChild(_bmp);
		}
		private function completedHandler(e:Event):void
		{
			var bitmap:Bitmap = e.target.content.rawContent as Bitmap;
			var bmpD:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			bmpD.copyPixels(bitmap.bitmapData, bitmap.getBounds(bitmap), new Point());
			imageCache[_url] = bmpD;
			setBitmap(bmpD);
			_loader.unload();
			_isLoading = false;
			if (_waitting != null && _waitting.parent != null)
			{
				_waitting.parent.removeChild(_waitting);
			}
			if (_maxHeight > -1 && _maxWidth > -1)
			{
				setScale(_maxWidth, _maxHeight);
			}
		}
		
		public function setMaxWidthAndHeight(maxWidth:int, maxHeight:int):void
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			if (!_isLoading)
				setScale(_maxWidth, _maxHeight);
		}
		
		private function setScale(maxWidth:int, maxHeight:int):void
		{
			var scale:Number = Math.min(_maxHeight / height, _maxWidth / width);
			scaleX = scaleY = scale;
		}
		
		public function destory():void
		{
			url = null;
		}
	}

}