package gemini.view.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import gemini.component.BitmapObject;
	/**
	 * ...
	 * @author gemini
	 */
	public class OnePixel extends BitmapObject implements IBitmapDraw
	{
		private var _color:uint
		public function OnePixel(color:uint,bitmap:Boolean = false) 
		{
			_color = color;
			if (bitmap)
			{
				_bmpD = new BitmapData(1, 1, true, color);
				_bmp = new Bitmap(_bmpD);
				addChild(_bmp);
			}
			
		}
		
		public function changeColor(color:uint):void
		{
			bitmapData.setPixel32(0,0,color);
		}
		
		/* INTERFACE gemini.view.bitmap.IBitmapDraw */
		
		public function drawToBitmapData(bmpD:BitmapData, offsetX:Number, offsetY:Number):void 
		{
			bmpD.setPixel32(x + offsetX, y + offsetY, _color);
		}
		
		override protected function setSkin(skin:*):void 
		{
			return;
		}
		
	}

}