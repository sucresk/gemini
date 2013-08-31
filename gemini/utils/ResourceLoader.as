package gemini.utils 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author sucre
	 */
	public class ResourceLoader extends URLLoader
	{
		private var retry:int;
		private var urlRequest:URLRequest;
		public static const LOADER_ERROR:String = "loader_error";
		public var index:int = 0;
		
		public function ResourceLoader(url:String, repetition:int) 
		{
			retry = repetition;
			urlRequest = new URLRequest(url);
			addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			super.load(urlRequest);
		}
		
		private function onErrorHandler(e:IOErrorEvent):void 
		{
			if (retry > 0)
			{
				retry--;
				super.load( urlRequest);
			}
			else
			{
				dispatchEvent( new Event(LOADER_ERROR));
			}
		}
		
	}

}