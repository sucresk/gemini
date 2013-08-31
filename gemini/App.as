package  gemini
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import gemini.component.ITick;
	import gemini.component.State;
	import gemini.debug.Stats;
	import gemini.manager.AssetManager;
	import gemini.manager.PopupManager;
	import gemini.manager.StateManager;
	import gemini.manager.TickManager;
	/**
	 * ...
	 * @author sukui
	 */
	public class App extends Sprite implements ITick
	{
		
		public static var stage:Stage;
		public static var STAGE_W:int;
		public static var STAGE_H:int;
		
		private static var _instance:App;
		public static function get instance():App
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
		
		public function App() 
		{
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		/* INTERFACE gemini.component.ITick */
		
		public function tick(intervalTime:uint):void 
		{
			
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
		
		protected function addToStageHandler(e:Event):void 
		{
			App.stage = stage;
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			assetManager = AssetManager.instance;
			initVars(loaderInfo.parameters);
			//层级设置
			tooltipLayer = new Sprite();
			tooltipLayer.mouseChildren = false;
			tooltipLayer.mouseEnabled = false;	
			menuLayer = new Sprite();
			appLayer = new Sprite();
			popupLayer = new Sprite();
			
			addChild(appLayer);
			addChild(popupLayer);
			addChild(menuLayer);
			addChild(tooltipLayer);
			
			PopupManager.instance.popupLayer = popupLayer;
			StateManager.instance.stateView = appLayer;
			
			//使用sdk编译
			if (!ide)
			{
				assetManager.loadConfig("resource.xml");
				assetManager.addEventListener(AssetManager.INIT_COMPLETE, preGameStart);
			}
			else
			{
				//使用ide编译
				preGameStart(null);
			}
			
		}
		
		private function preGameStart(e:Event):void 
		{
			assetManager.removeEventListener(AssetManager.INIT_COMPLETE, preGameStart);
			gameStart();
			if (debug) {
				var s:Stats = new Stats();
				s.x = stage.stageWidth - 70;
				addChild(s);
			}
		}
		
		protected function gameStart():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			TickManager.instance.start(stage);
			trace("Gemini app start!");
		}
		
		public function set state(state:State):void
		{
			StateManager.instance.switchState(state);
		}
		protected function initVars(vars:Object):void
		{
			
		}
		
	}

}