package gemini.component 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class Progress extends BaseObject
	{
		public static const MODE_SCALEX:String = "scaleX";
		public static const MODE_SCALEY:String = "scaleY";
		public static const MODE_X:String = "x";
		public static const MODE_Y:String = "y";
		public static const MODE_WIDTH:String = "width";
		public static const MODE_HEIGHT:String = "height";
		
		public var bar:Sprite;
		
		private var _mode:String;
		private var _min:Number;
		private var _max:Number;
		private var _during:Number;
		 
		private var _percent:Number;
		private var _value:Number;
		
		public function Progress(skin:*,interactive:Boolean = false, autoBuild:Boolean = false, buildLayer:int = 1) 
		{
			super(skin, interactive, autoBuild,buildLayer);
			if (bar == null)
				bar = content;
			setProgress();
		}
		
		public function setProgress(mode:String = MODE_SCALEX, min:Number = 0, max:Number = 1):void
		{
			_mode = mode;
			_min = min;
			_max = max;
			_during = _max - min;
		}
		
		public function get percent():Number 
		{
			return _percent;
		}
		
		public function set percent(value:Number):void 
		{
			_percent = value;
			bar[_mode] = _min + _during * _percent;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			if (_value > _max)
				_value = _max;
			else if (_value < _min)
				_value = _min;
			percent = (_value - _min) / _during;
		}
		
	}

}