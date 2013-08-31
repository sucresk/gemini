package gemini.actor 
{
	import gemini.component.AnimatedObject;
	/**
	 * ...
	 * @author 
	 */
	public class BaseActor extends AnimatedObject
	{
		private var _actions:Vector.<IAction>;
		private var _actionsMap:Object;
		
		public function BaseActor(skin:*) 
		{
			super(skin);
			_actions = new Vector.<IAction>();
			_actionsMap = new Object();
		}
		
		public function addAction(action:IAction):void
		{
			_actions.push(action);
			_actionsMap[action.name] = action;
		}
		
		public function removeAction(action:IAction):void
		{
			var index:int = _actions.indexOf(action);
			if (index > -1)
				_actions.splice(index, 1);
			if (_actionsMap[action.name] != null)
			{
				_actionsMap[action.name] = null;
				delete _actionsMap[action.name];
			}
		}
		
		override public function tick(intervalTime:uint):void 
		{
			super.tick(intervalTime);
			for each( var action:IAction in _actions)
			{
				if (action.isPlaying)
				{
					action.tick(intervalTime);
				}
			}
		}
		
	}

}