package gemini.skeleton2D 
{
	import gemini.skeleton2D.easing.Linear;
	import gemini.skeleton2D.utils.EaseUtils;
	/**
	 * ...
	 * @author 
	 */
	public class KeyFrame 
	{
		public var index:int;
		public var flag:String;
		
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var skewX:Number;
		public var skewY:Number;
		public var alpha:Number;
		public var delay:int;
		public var ease:Function = Linear.easeNone;
		
		public function KeyFrame() 
		{
			//<Keyframe index="11" flag="run" rotation="0" x="3.0" y="1.75" scaleX="1" scaleY="1" skewX="0" skewY="0" />
		}
		
		public function toXml():XML
		{
			var str:String = "<keyframe index=\"" + index.toString() +"\" ";
			if (!isNaN(x))
			{
				str += "x=\"" + x.toString(2) + "\" ";
			}
			if (!isNaN(y))
			{
				str += "y=\"" + y.toString(2) + "\" ";
			}
			if (!isNaN(rotation))
			{
				str += "rotation=\"" + rotation.toString() + "\" ";
			}
			if (!isNaN(scaleX))
			{
				str += "scaleX=\"" + scaleX.toString(2) + "\" ";
			}
			if (!isNaN(scaleY))
			{
				str += "scaleY=\"" + scaleY.toString(2) + "\" ";
			}
			if (!isNaN(skewX))
			{
				str += "skewX=\"" + skewX.toString(2) + "\" ";
			}
			if (!isNaN(skewY))
			{
				str += "skewY=\"" + skewY.toString(2) + "\" ";
			}
			if (!isNaN(alpha))
			{
				str += "alpha=\"" + alpha.toString(2) + "\" ";
			}
			//if (!isNaN(delay))
			//{
				//str += "x=\"" + x.toString(2) + "\" ";
			//}
			if (ease != Linear.easeNone && ease != Linear.easeIn && ease != Linear.easeInOut && ease != Linear.easeOut)
			{
				str += "ease=\"" + EaseUtils.getName(ease) + "\" ";
			}
			
			str += "/>";
			return new XML(str);
		}
		
	}

}