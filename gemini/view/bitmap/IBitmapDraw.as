package gemini.view.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author gemini
	 */
	public interface IBitmapDraw 
	{
		function drawToBitmapData(bmpD:BitmapData,offsetX:Number, offsetY:Number):void
	}
	
}