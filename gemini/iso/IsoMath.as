package gemini.iso 
{
	import flash.geom.Point;
	/**
	 * ...
	 * x1 = x - z
	 * y1 = y * 1.2247 + (x + z) * 0.5
	 * z2 = (x + z) * 0.866 - y * 0.707 
	 * @author sukui
	 */
	public class IsoMath 
	{
		public static const Y_CORRECT:Number = 1.2247448713915892;
		
		public static function isoToScreen(pos:IsoPoint):Point
		{
			var screenX:Number = pos.x - pos.y;
			var screenY:Number = pos.z * Y_CORRECT + (pos.x + pos.y) * 0.5;
			return new Point(screenX, screenY);
		}
		
		public static function screenToIso(pos:Point):IsoPoint
		{
			var isoX:Number = pos.y + pos.x * 0.5;
			var isoY:Number = pos.y - pos.x * 0.5;
			var isoZ:Number = 0;
			return new IsoPoint(isoX, isoY, isoZ);
		}
		
		public static function getDepth(x:Number, y:Number, z:Number):Number
		{
			return (x + y) * 0.866 - z * 707;
		}
		
		public function IsoMath() 
		{
			
		}
		
	}

}