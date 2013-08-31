package gemini.actor 
{
	import gemini.data.Vars;
	/**
	 * ...
	 * @author 
	 */
	public class RunAction implements IAction
	{
		private var _name:String = "run";
		private var _isPlaying:Boolean;
		private var _speed:Number;
		private var _target:BaseActor;
		
		public function RunAction(target:BaseActor, speed:Number) 
		{
			_speed = speed;
			_target = target;
		}
		
		/* INTERFACE gemini.actor.IAction */
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function tick(intervalTime:uint):void 
		{
			if (!_isPlaying)
				return;
			_target.x += int(_speed * intervalTime);
		}
		
		public function play():void 
		{
			_isPlaying = true;
			_target.numLoops = -1;
			_target.setSequence("run");
		}
		
		public function stop():void 
		{
			_isPlaying = false;
		}
		
	}

}