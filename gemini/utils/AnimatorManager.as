package gemini.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sukui
	 */
	public class AnimatorManager extends EventDispatcher
	{
		public var urls:Array;
		private var numOfLoaded:int = 0;
		private var data:Array = new Array();
		private var objectNames:Dictionary = new Dictionary(true);
		private var animatorNames:Dictionary = new Dictionary(true);
		private var numOfObjects:int = 0;
		private var numOfAnimator:int = 0;
		public function AnimatorManager() 
		{
			
		}
		public function loadAnimatorXml(urls:Array,objects:Array,animators:Array):void
		{
			this.urls = urls;
			for ( var i:int = 0; i < objects.length; i++)
			{
				objectNames[objects[i]] = i;
			}
			for ( var j:int = 0; j < animators.length; j++)
			{
				animatorNames[animators[j]] = j;
			}
			data = new Array(objects.length * animators.length);
			loadXml(urls[0]);
		}
		private function loadXml(url:String):void
		{
			var xmlLoader:ResourceLoader = new ResourceLoader(url, 1);
			xmlLoader.addEventListener(Event.COMPLETE, loadedHandler);
		}
		
		private function loadedHandler(e:Event):void 
		{
			data[keys[numOfLoaded]] = new XML(e.currentTarget.data);
			numOfLoaded++;
			if (numOfLoaded >= urls.length) dispatchEvent(new Event(Event.COMPLETE));
			else loadXml(urls[numOfLoaded]);
		}
		
	}

}