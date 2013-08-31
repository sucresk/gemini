package gemini.skeleton2D.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.game_develop.animation.gpu.display.GpuObj2d;
	/**
	 * ...
	 * @author 
	 */
	public class Are2DSpriteSheetUtil extends SpriteSheetUtil
	{
		
		public function Are2DSpriteSheetUtil(bmpD:BitmapData, atlasXml:XML) 
		{
			super(bmpD, atlasXml);
		}
		
		public function getGpuObj2d(name:String):GpuObj2d
		{
			var bmp:BitmapData = getBmpD(name);
			var frame:Rectangle = getFrame(name);
			var offsetX:Number = frame == null ? 0: frame.x;
			var offsetY:Number = frame == null ? 0: frame.y;
			var g:GpuObj2d = new GpuObj2d(bmp.width, bmp.height, bmp, offsetX,offsetY);
			return g;
		}
	}

}