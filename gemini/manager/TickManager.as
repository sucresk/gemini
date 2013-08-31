package gemini.manager 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	import gemini.component.BaseObject;
	import gemini.component.ITick;
	/**
	 * ...
	 * @author gemini
	 */
	public class TickManager 
	{
		private static var _instance:TickManager;
		
		private var _tickObjects:Vector.<ITick>;
		private var _lastTickTime:uint;
		private var _curTime:uint;
		private var _stage:Stage;
		private var _newObjects:Vector.<ITick>
		
		public function TickManager() 
		{
			if (_instance != null)
			{
				throw new Error("this is a singleton");
			}
			_tickObjects = new Vector.<ITick>();
			_newObjects = new Vector.<ITick>();
		}
		
		public static function get instance():TickManager
		{
			if (_instance == null)
				_instance = new TickManager();
			return _instance;
		}
		
		public function start(stage:Stage):void
		{
			_stage = stage;
			stage.addEventListener(Event.ENTER_FRAME, tickHandler);
			_lastTickTime = getTimer();
		}
		
		private function tickHandler(e:Event):void 
		{
			_curTime = getTimer();
            var interval:int = Math.max(0, (_curTime - _lastTickTime));
            _lastTickTime = _curTime;
            tick(interval);
		}
		
		private function tick(intervalTime:uint):void
		{
			for (var i:int = 0, length:int = _tickObjects.length; i < length; i++)
			{
				_tickObjects[i].tick(intervalTime);
			}
			addAndRemoveObject();
		}
		
		private function addAndRemoveObject():void
		{
			_tickObjects.splice(0, _tickObjects.length);
			for (var i:int = 0; i < _newObjects.length; i++)
			{
				_tickObjects[i] = _newObjects[i];
			}
		}
		
		public function stop():void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, tickHandler);
		}
		
		public function registerTick(obj:ITick):void
		{
			_newObjects.push(obj);
		}
		
		public function unRegisterTick(obj:ITick):void
		{
			var index:int = _newObjects.indexOf(obj);
			if(index != -1)
				_newObjects.splice(index, 1);
		}
	}

}