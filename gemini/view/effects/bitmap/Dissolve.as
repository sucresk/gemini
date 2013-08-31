package gemini.view.effects.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gemini
	 */
	public class Dissolve 
	{
		
		public function Dissolve() 
		{
			
		}
		
		public static function apply(target:DisplayObject, deep:Number):Bitmap
		{
			var bmp:Bitmap = new Bitmap(new BitmapData(target.width, target.height));
			//bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0x00ffff);
			bmp.bitmapData.draw(target, new Matrix(target.transform.matrix.a,0,0,target.transform.matrix.d,0,0));
			bmp.bitmapData.pixelDissolve(bmp.bitmapData, bmp.bitmapData.rect, new Point(), 1, (1 - deep) * bmp.bitmapData.width * bmp.bitmapData.height);
			bmp.transform.matrix = new Matrix(1,0,0,1,target.transform.matrix.tx,target.transform.matrix.ty)
			return bmp;
		}
	}

}