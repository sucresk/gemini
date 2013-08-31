package gemini.view.effects.bitmap 
{
	import flash.display.Bitmap;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gemini
	 */
	public class Residual 
	{
		
		public function Residual() 
		{
			
		}
		
		public static function create(target:Bitmap,alpha:Number = 0.8, blurX:Number = 10,blurY:Number = 10):void
		{
			target.bitmapData.colorTransform(target.bitmapData.rect, new ColorTransform(1, 1, 1, alpha));
			target.bitmapData.applyFilter(target.bitmapData, target.bitmapData.rect, new Point(), new BlurFilter(blurX, blurY));
		}
		
	}

}