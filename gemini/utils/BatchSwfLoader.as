package gemini.utils 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author sukui
	 */
	public class BatchSwfLoader extends EventDispatcher
	{
		private var swfUrls:Array;
		private var loadedNum:int = 0;
		private var numOfSwf:int = 0;
		
		public function BatchSwfLoader(swfUrls:Array) 
		{
			this.swfUrls = swfUrls;
			numOfSwf = swfUrls.length;
			loaderSwf(0);
		}
		
		private function loaderSwf(index:int = 0):void
		{
			trace(swfUrls[index]);
			var loader:Loader;
			var loaderRequest:URLRequest;
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

			loader = new Loader();
			
			loaderRequest = new URLRequest(swfUrls[index]);
			loader.load(loaderRequest, loaderContext);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			trace(Math.floor((e.bytesLoaded / e.bytesTotal) * (100 / numOfSwf)) +(loadedNum)/numOfSwf * 100);
		}
		private function completeHandler(e:Event):void 
		{
			loadedNum++;
			if (loadedNum >= swfUrls.length) {
				dispatchEvent(e);
			}
			else {
				loaderSwf(loadedNum);
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatchEvent(e);
		}
		
	}

}