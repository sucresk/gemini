package gemini.component 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class LadderProgress extends BaseObject
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
		private var _ladderTarget:Array;
		private var _ladderValue:Array;
		private var _percent:Number;
		private var _value:Number;
		private var _totalLevel:int;
		private var _curLevel:int;
		
		public function LadderProgress(skin:*,interactive:Boolean = true, autoBuild:Boolean = false, buildLayer:int = 1) 
		{
			super(skin, interactive, autoBuild,buildLayer);
			if (bar == null)
				bar = content;
		}
		
		public function setProgress(mode:String, ladderTarget:Array, ladderValue:Array):void
		{
			_mode = mode;
			_ladderTarget = ladderTarget;
			_ladderValue = ladderValue;
			_totalLevel = ladderValue.length;
			_max = ladderValue[ladderValue.length - 1];
			_min = ladderValue[0];
			_during = _max - _min;
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
			_curLevel = _totalLevel;
			for (var i:int = 0; i < _totalLevel; i++)
			{
				if (value < _ladderValue[i])
				{
					_curLevel = i;
					break;
				}
			}
				bar[_mode] = _ladderTarget[_curLevel - 1] + (_ladderTarget[_curLevel] - _ladderTarget[_curLevel - 1]) * (_value - _ladderValue[_curLevel - 1]) / (_ladderValue[_curLevel] - _ladderValue[_curLevel - 1]);
		}
		
		public function get curLevel():int 
		{
			return _curLevel;
		}
		
	}

}