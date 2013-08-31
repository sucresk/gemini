package  gemini.manager
{
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.data.LoaderMaxVars;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import gemini.App;
	import gemini.component.BaseLoadingBar;
	import gemini.component.ILoadingBar;
	/**
	 * ...
	 * @author sukui
	 */
	public class AssetManager extends EventDispatcher
	{
		public static const INIT_COMPLETE:String = "initCompleted";
		private static var _instance:AssetManager;
		private static var _loadingBarClass:Class;
		
		public var assetArr:Array = new Array();
		public var dataArr:Array = new Array();
		public var imagesArr:Array = new Array();
		
		public var langUrl:String;
		public var baseUrl:String = "";
		
		private var _loadingUrl:String;
		private var _loadingSize:uint;
		private var _loading:ILoadingBar;
		private var _allData:Object;
		
		public function AssetManager() 
		{
			_allData = new Object();
		}
		
		static public function get instance():AssetManager {
			if (_instance == null) {
				_instance = new AssetManager();
			}
			return _instance;
		}
		static public function setLoadingClass(loadingBarClass:Class):void
		{
			_loadingBarClass = loadingBarClass;
		}
		
		public function loadConfig(url:String):void
		{
			var xmlLoader:XMLLoader = new XMLLoader(baseUrl + url, { onComplete:configLoadComplete, noCache:true } );
			xmlLoader.load();
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			trace(e);
		}
		
		private function configLoadComplete(e:Event):void 
		{
			var config:XML = new XML(e.target.content);
			if (config.hasOwnProperty("asset")) {
				for each (var asset:XML in config.asset.children()) {
					var oAsset:Object = new Object();
					oAsset.url = baseUrl + asset.@url.toString();
					oAsset.id = asset.@id.toString();
					oAsset.size = asset.@id ? int(asset.@id) : 10000;
					assetArr.push(oAsset);
				}
			}
			if (config.hasOwnProperty("data")) {
				for each (var data:XML in config.data.children()) {
					var oData:Object = new Object();
					oData.url = baseUrl + data.@url.toString();
					oData.id = data.@id.toString();
					oData.size = data.@size ? int(data.@size) : 10000;
					dataArr.push(oData);
				}
			}
			if (config.hasOwnProperty("image")) {
				for each (var image:XML in config.image.children()) {
					var oImg:Object = new Object();
					oImg.url = baseUrl + image.@url.toString();
					oImg.id = image.@id.toString();
					oImg.size = image.@size ? int(image.@size) : 10000;
					imagesArr.push(oImg);
				}
			}
			
			if (config.hasOwnProperty("loading"))
			{
				_loadingUrl = baseUrl + config.loading.children()[0].@url.toString();
				_loadingSize = config.loading.children()[0].@size ? uint(config.loading.children()[0].@size) : 10000;
			}
			
			var loaderMaxVars:LoaderMaxVars = new LoaderMaxVars();
			loaderMaxVars.onProgress(progressHandler);
			loaderMaxVars.onComplete(allCompletedHandler);
			loaderMaxVars.auditSize(false);
			var loaderMax:LoaderMax = new LoaderMax(loaderMaxVars);
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			
			if(_loadingUrl != null)
				loaderMax.append( new SWFLoader(_loadingUrl, { context:loaderContext, onComplete:showLoading, estimatedBytes:_loadingSize } ));
			
			var i:int = 0;
			var len:int = 0;
			for (i = 0,len = assetArr.length; i < len; i++)
			{
				loaderMax.append( new SWFLoader(assetArr[i].url, { context:loaderContext, estimatedBytes:assetArr[i].size} ));
			}
			for (i = 0,len = dataArr.length; i < len; i++)
			{
				loaderMax.append( new BinaryDataLoader(dataArr[i].url,{name:dataArr[i].id, onComplete:dataCompletedHandler, estimatedBytes:dataArr[i].size}));
			}
			for (i = 0,len = imagesArr.length; i < len; i++)
			{
				loaderMax.append( new ImageLoader(imagesArr[i].url,{name:imagesArr[i].id, onComplete:imgCompletedHandler, estimatedBytes:imagesArr[i].size}));
			}
			loaderMax.load();
		}
		
		private function showLoading(e:Event):void
		{
			App.stage.removeChildAt(0);
			if (_loadingBarClass != null)
			{
				_loading = new _loadingBarClass();
				_loading.show(App.stage);
			}
			
		}
		//private function loadLang(url:String):void
		//{
			//var langLoader:URLLoader = new URLLoader( new URLRequest(url));
			//langLoader.addEventListener(Event.COMPLETE, langLoadedHandler);
			//langLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		//}
		
		private function progressHandler(e:Event):void
		{
			if (_loading != null)
			{
				_loading.progress(e.target.progress);
			}
		}
		
		private function dataCompletedHandler(e:Event):void
		{
			_allData[e.target.name] =  (e.target.content);
		}
		
		private function imgCompletedHandler(e:Event):void
		{
			_allData[e.target.name] =  (e.target.content.rawContent);
		}
		
		private function allCompletedHandler(e:Event):void
		{
			dispatchEvent( new Event(INIT_COMPLETE));
		}
		//private function langLoadedHandler(e:Event):void 
		//{
			//Lang.init(e.currentTarget.data);
			//e.currentTarget.removeEventListener(Event.COMPLETE, langLoadedHandler);
			//e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			//if (assetUrls.length > 0) {
				//swfsLoader = new BatchSwfLoader(assetUrls);
				//swfsLoader.addEventListener(Event.COMPLETE, swfsLoadedHandler);
			//}
		//}
		//private function swfsLoadedHandler(e:Event):void 
		//{
			//e.currentTarget.removeEventListener(Event.COMPLETE, swfsLoadedHandler);
			//dispatchEvent( new Event(INIT_COMPLETE));
			//
		//}
		public function removeLoading():void
		{
			if (_loading != null)
			{
				_loading.remove();
			}
		}
		public function getData(dataId:String):Object
		{
			return _allData[dataId];
		}
		
		public function getXML(name:String):XML
		{
			var data:Object = getData(name);
			if (data)
			{
				return XML(data);
			}
			return null;
		}
		public function getImage(name:String):Bitmap
		{
			return _allData[name] as Bitmap;
		}
		
		public function getMovieClip(name:String):MovieClip {
			return newAsset(name) as MovieClip;
		}
		public function getSprite(name:String):Sprite {
			return newAsset(name) as Sprite;
		}
		
		public function getBitmap(name:String):Bitmap
		{
			var bmp:Bitmap = new Bitmap();
			var bmpD:BitmapData;
			
			try
			{
				var assetClass:Class = getDefinitionByName(name) as Class;
				if (assetClass==null)return null;
				bmpD = new assetClass(0, 0);
				if (bmpD != null)
				{
					bmp.bitmapData = bmpD;
				}
			}
			catch (e:Error)
			{
				trace(e);
			}
			
			return bmp;
		}
		
		public function getFont(name:String):Class
		{
			try 
			{
				var fontClass:Class = getDefinitionByName(name) as Class;
				return fontClass;
			}
			catch (e:Error)
			{
				trace(e);
			}
			return null;
		}
		public function newAsset(name:String):* {
			try
			{
				var assetClass:Class = getDefinitionByName(name) as Class;
				if (assetClass==null)return null;
				return new assetClass();
			}
			catch (e:Error)
			{
				trace(e);
			}
		}
		public function getClass(className:String):Class
		{
			try
			{
				var c:Class = getDefinitionByName(className) as Class;
				if (c)
				{
					return c;
				}
				else
				{
					return null;
				}
			}
			catch (e:Error)
			{
				trace(e);
				return null;
			}
			return null;
		}
		
	}

}