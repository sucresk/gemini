package gemini.view.boiler 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author gemini
	 */
	public class MotionBlurBoiler extends ResidualBoiler
	{
		
		public function MotionBlurBoiler(width:int, height:int, level:int = 3) 
		{
			super(width, height);
			this.itemColorTransform = new ColorTransform(1,1,1,1 - 1 / level);
			residualSpeed = 1 - 1 / level;
		}
		
	}

}