package gemini.skeleton2D.utils 
{
	import gemini.skeleton2D.easing.*;
	/**
	 * ...
	 * @author 
	 */
	public class EaseUtils 
	{
		
		public static function getName(fun:Function):String
		{
			switch(fun)
			{
				case Back.easeIn:
				return "Back.easeIn";
					break;
				
					case Back.easeInOut:
					return "Back.easeInOut";
					break;
				
					case Back.easeOut:
					return "Back.easeOut";
					break;
				
					case Bounce.easeIn:
					return "Bounce.easeIn";
					break;
				
					case Bounce.easeInOut:
					return "Bounce.easeInOut";
					break;
				
					case Bounce.easeOut:
					return "Bounce.easeOut";
					break;
				
					case Circ.easeIn:
					return "Circ.easeIn";
					break;
				
					case Circ.easeInOut:
					return "Circ.easeInOut";
					break;
				
					case Circ.easeOut:
					return "Circ.easeOut";
					break;
				
					case Cubic.easeIn:
					return "Cubic.easeIn";
					break;
				
					case Cubic.easeInOut:
					return "Cubic.easeInOut";
					break;
				
					case Cubic.easeOut:
					return "Cubic.easeOut";
					break;
				
					case Elastic.easeIn:
					return "Elastic.easeIn";
					break;
				
					case Elastic.easeInOut:
					return "Elastic.easeInOut";
					break;
				
					case Elastic.easeOut:
					return "Elastic.easeOut";
					break;
				
					case Expo.easeIn:
					return "Expo.easeIn";
					break;
				
					case Expo.easeInOut:
					return "Expo.easeInOut";
					break;
				
					case Expo.easeOut:
					return "Expo.easeOut";
					break;
				
					case Linear.easeIn:
					return "Linear";
					break;
				
					case Linear.easeInOut:
					return "Linear";
					break;
				
					case Linear.easeOut:
					return "Linear";
					break;
					
				case Linear.easeNone:
					return "Linear";
					break;
					
					case Quad.easeIn:
					return "Quad.easeIn";
					break;
				
					case Quad.easeInOut:
					return "Quad.easeInOut";
					break;
				
					case Quad.easeOut:
					return "Quad.easeOut";
					break;
				
					case Quart.easeIn:
					return "Quart.easeIn";
					break;
				
					case Quart.easeInOut:
					return "Quart.easeInOut";
					break;
				
					case Quart.easeOut:
					return "Quart.easeOut";
					break;
				
					case Quint.easeIn:
					return "Quint.easeIn";
					break;
				
					case Quint.easeInOut:
					return "Quint.easeInOut";
					break;
				
					case Quint.easeOut:
					return "Quint.easeOut";
					break;
				
					case Sine.easeIn:
					return "Sine.easeIn";
					break;
				
					case Sine.easeInOut:
					return "Sine.easeInOut";
					break;
				
					case Sine.easeOut:
					return "Sine.easeOut";
					break;
				
					case Strong.easeIn:
					return "Strong.easeIn";
					break;
				
					case Strong.easeInOut:
					return "Strong.easeInOut";
					break;
				
					case Strong.easeOut:
					return "Strong.easeOut";
					break;
				
			}
			return "Linear";
		}
		
		public static function getFunction(name:String):Function
		{
			switch(name)
			{
				case "Back.easeIn":
					return Back.easeIn;
					break;
				case "Back.easeInOut":
					return Back.easeInOut;
					break;
				case "Back.easeOut":
					return Back.easeOut;
					break;
				case "Bounce.easeIn":
					return Bounce.easeIn;
					break;
				case "Bounce.easeInOut":
					return Bounce.easeInOut;
					break;
				case "Bounce.easeOut":
					return Bounce.easeOut;
					break;
				case "Circ.easeIn":
					return Circ.easeIn;
					break;
				case "Circ.easeInOut":
					return Circ.easeInOut;
					break;
				case "Circ.easeOut":
					return Circ.easeOut;
					break;
				case "Cubic.easeIn":
					return Cubic.easeIn;
					break;
				case "Cubic.easeInOut":
					return Cubic.easeInOut;
					break;
				case "Cubic.easeOut":
					return Cubic.easeOut;
					break;
				case "Elastic.easeIn":
					return Elastic.easeIn;
					break;
				case "Elastic.easeInOut":
					return Elastic.easeInOut;
					break;
				case "Elastic.easeOut":
					return Elastic.easeOut;
					break;
				case "Expo.easeIn":
					return Expo.easeIn;
					break;
				case "Expo.easeInOut":
					return Expo.easeInOut;
					break;
				case "Expo.easeOut":
					return Expo.easeOut;
					break;
				case "Linear":
					return Linear.easeIn;
					break;
				case "Linear.easeInOut":
					return Linear.easeInOut;
					break;
				case "Linear.easeOut":
					return Linear.easeOut;
					break;
				case "Quad.easeIn":
					return Quad.easeIn;
					break;
				case "Quad.easeInOut":
					return Quad.easeInOut;
					break;
				case "Quad.easeOut":
					return Quad.easeOut;
					break;
				case "Quart.easeIn":
					return Quart.easeIn;
					break;
				case "Quart.easeInOut":
					return Quart.easeInOut;
					break;
				case "Quart.easeOut":
					return Quart.easeOut;
					break;
				case "Quint.easeIn":
					return Quint.easeIn;
					break;
				case "Quint.easeInOut":
					return Quint.easeInOut;
					break;
				case "Quint.easeOut":
					return Quint.easeOut;
					break;
				case "Sine.easeIn":
					return Sine.easeIn;
					break;
				case "Sine.easeInOut":
					return Sine.easeInOut;
					break;
				case "Sine.easeOut":
					return Sine.easeOut;
					break;
				case "Strong.easeIn":
					return Strong.easeIn;
					break;
				case "Strong.easeInOut":
					return Strong.easeInOut;
					break;
				case "Strong.easeOut":
					return Strong.easeOut;
					break;
				
			}
			return Linear.easeIn;
		}
		
		public function EaseUtils() 
		{
			
		}
		
	}

}