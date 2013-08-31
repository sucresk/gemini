package gemini.skeleton2D.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class Skeleton2DEvent extends Event
	{
		static public const ANIMATION_LOOP_COMPLETED:String = "animationLoopCompleted";
		static public const ANIMATION_COMPLETED:String = "animtionCompleted";
		
		public var animName:String;
		public function Skeleton2DEvent(type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			animName = name;
			
		}
		
	}

}