package gemini.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author sucre
	 */
	public class ScaleBar extends BaseObject
	{
		/**
		 * 这个类实现了条形进度条
		 */
		private var _skin:MovieClip;
		private var _bar:MovieClip;
		private var _txtDesc:TextField;
		private var _value:Number = 0;
		private var _total:Number = 1;
		
		public function ScaleBar(skin:MovieClip) 
		{
			super(skin);
			_skin = content as MovieClip;
			_skin = skin;
			_bar = _skin["bar"];
			_txtDesc = _skin["txtDesc"];
		}
		
		public function set value(v:Number):void
		{
			if (v < 0) v = 0;
			_value = v;
			if (_bar != null) {
				_bar.scaleX = _value / _total;
			}
			else {
				_skin.gotoAndStop(int(_skin.totalFrames * _value / _total));
			}
			if (_txtDesc != null) {
				_txtDesc.text = _value.toString();
			}
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set total(v:Number):void
		{
			_total = v;
			value = _value;
		}
		public function get total():Number
		{
			return _total;
		}
	}

}