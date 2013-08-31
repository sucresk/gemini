package gemini 
{
	import adobe.utils.CustomActions;
	import gemini.component.ITick;
	import gemini.manager.AssetManager;
	import gemini.manager.TickManager;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.core.StatsDisplay;
	/**
	 * ...
	 * @author 
	 */
	public class StarlingApp extends Sprite implements ITick
	{
		public static var stage:Stage;
		public static var STAGE_W:int;
		public static var STAGE_H:int;
		
		private static var _instance:StarlingApp;
		public static function get instance():StarlingApp
		{
			return _instance;
		}
		
		public var assetManager:AssetManager;
		public var debug:Boolean = true;
		
		public var tooltipLayer:Sprite;
		public var menuLayer:Sprite;
		public var appLayer:Sprite;
		public var popupLayer:Sprite;
		
		private var _tickEnable:Boolean;
		public var ide:Boolean = false;
		
		public function StarlingApp() 
		{
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			StarlingApp.stage = stage;
			assetManager = AssetManager.instance;
			//层级设置
			tooltipLayer = new Sprite();
			tooltipLayer.touchable = false;
			menuLayer = new Sprite();
			appLayer = new Sprite();
			popupLayer = new Sprite();
			
			addChild(appLayer);
			addChild(popupLayer);
			addChild(menuLayer);
			addChild(tooltipLayer);
			
			preGameStart(null);
		}
		
		private function preGameStart(e:*):void 
		{
			assetManager.removeEventListener(AssetManager.INIT_COMPLETE, preGameStart);
			initialize();
			//if (debug) {
				//var stats:StatsDisplay = new StatsDisplay();
				//addChild(stats);
			//}
			gameStart();
		}
		
		protected function gameStart():void
		{
			
		}
		
		protected function initialize():void 
		{
		}
		
		
		/* INTERFACE gemini.component.ITick */
		
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
		
		public function tick(intervalTime:uint):void 
		{
			
		}
		
	}

}