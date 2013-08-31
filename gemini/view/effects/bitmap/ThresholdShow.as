package gemini.view.effects.bitmap 
{
	import gemini.view.effects.bitmap.ThresholdFillter
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author gemini
	 */
	public class ThresholdShow 
	{
		private static var _instance:ThresholdShow;
		public static function get instance():ThresholdShow
		{
			if (_instance == null)
				_instance = new ThresholdShow();
			return _instance;
		}
		
		private var _target:DisplayObject;
		private var _threshold:int;
		public function ThresholdShow() 
		{
			
		}
		
		public static function apply(target:DisplayObject, speed:Number):void
		{
			instance._target = target;
			instance.threshold = 255;
			TweenLite.to(instance, speed, {"threshold":0, onComplete:complete} );
		}
		
		private static function complete():void
		{
			_instance._target.filters = null;
		}
		
		public function set threshold(v:int):void
		{
			if (v != _threshold)
			{
				_threshold = v;
				ThresholdFillter.apply(_target, v);
			}
			
		}
		public function get threshold():int
		{
			return _threshold;
		}
	}

}