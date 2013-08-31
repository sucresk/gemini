package gemini.manager  
{
	import flash.display.DisplayObjectContainer;
	import gemini.component.State;
	/**
	 * ...
	 * @author 
	 */
	public class StateManager 
	{
		private static var _instance:StateManager;
		public static function get instance():StateManager
		{
			if (_instance == null)
				_instance = new StateManager();
			return _instance;
		}
		
		public var stateView:DisplayObjectContainer;
		
		private var _curState:State;
		
		public function StateManager() 
		{
			
		}
		
		public function switchState(state:State):void
		{
			if (_curState != state)
			{
				if (_curState != null)
				{
					_curState.destroy();
					if (stateView != null)
					{
						stateView.removeChild(_curState);
					}
				}
				
				_curState = state;
				if (stateView != null)
				{
					stateView.addChild(_curState);
				}
			}
			
			
		}
	}

}