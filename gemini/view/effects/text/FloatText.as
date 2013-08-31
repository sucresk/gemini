package gemini.view.effects.text 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.text.TextField;
	import gemini.component.BaseObject;
	/**
	 * ...
	 * @author gemini
	 */
	public class FloatText extends BaseObject
	{
		private var _text:String;
		private var _arr:Array;
		
		public function FloatText(text:String) 
		{
			_text = text;
			_arr = new Array();
			
			var i:int;
			var len:int = _text.length;
			for (i = 0; i < len; i++)
			{
				var t:TextField = new TextField();
				t.text = _text.substr(i, 1);
				_arr.push(t);
				if (i > 0)
				{
					t.x = _arr[i - 1].x + _arr[i - 1].textWidth;
				}
				addChild(t);
			}
			
			var tl:TimelineLite = new TimelineLite({stagger:0.1});
			tl.appendMultiple(TweenMax.allFrom(_arr, 0.8, { y:50, alpha:0, ease:Elastic.easeOut }, 0.02));
			tl.appendMultiple(TweenMax.allTo(_arr, 0.8, { y: -50, alpha:0,delay:1 },0,destroy));
		}
		
		override public function destroy():void 
		{
			TweenMax.killAll(true);
			_text = null;
			_arr.length = 0;
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
	}

}