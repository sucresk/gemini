package gemini.utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		public static function getAngle(startX:Number, startY:Number, endX:Number, endY:Number):Number
		{
            var relativeX:Number = (endX - startX);
            var relativeY:Number = (startY - endY);
            if (relativeX < 0)
			{
                return ((Math.atan((relativeY / relativeX)) + Math.PI));
            };
            if (relativeX > 0)
			{
                if (relativeY < 0){
                    return (((2 * Math.PI) + Math.atan((relativeY / relativeX))));
                };
                return (Math.atan((relativeY / relativeX)));
            } else 
			{
                if (relativeY > 0)
				{
                    return ((Math.PI / 2));
                };
                if (relativeY < 0)
				{
                    return ((Math.PI + (Math.PI / 2)));
                };
            };
            return (0);
        }
		public static function rnd(min:int, max:int):int{
            
			if ( min > max) {
				var temp:int = max;
				max = min;
				min = temp;
			}
            return Math.floor(Math.random() * (max - min)) + min;
        }
		
	}

}