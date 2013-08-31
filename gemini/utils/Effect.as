package gemini.utils 
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author sucre
	 */
	public class Effect
	{
		
		public function Effect() 
		{
			
		}
		
		static public function border(lineColor:Number = 0xffffff, lineWidth:Number = 5):BitmapFilter {
			var color:Number = lineColor;
			var alpha:Number = 3.0;
			var blurX:Number = lineWidth;
			var blurY:Number = lineWidth;
			var strength:Number = 100;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.LOW;
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		
		static public function highlight(lineWidth:Number = 8):BitmapFilter {
			var color:Number = 0xffcc00;
			var alpha:Number = 1.0;
			var blurX:Number = lineWidth;
			var blurY:Number = lineWidth;
			var strength:Number = 25;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.LOW;
			
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			
			//var colorMat:Array = [1.2,0,0,0,0,
                                      //0,1.2,0,0,0,
                                      //0,0,1.2,0,0,
                                      //0,0,0,1,0];
			//return new ColorMatrixFilter(colorMat);
		}
		
		static public function disableIcon():BitmapFilter {
			
			var matrix:Array = [0.3086, 0.6094, 0.082, 0, 0,
							    0.3086, 0.6094, 0.082, 0, 0, 
								0.3086, 0.6094, 0.082, 0, 0, 
								     0,      0,     0, 1, 0];
									 
			return new ColorMatrixFilter(matrix);
		}
		
		public function grayIcon():BitmapFilter {
			var matrix:Array = [0.37774,0.54846,0.0738,0,0,0.27774,0.64846,0.0738,0,0,0.27774,0.54846,0.1738,0,0,0,0,0,1,0];
								
			return new ColorMatrixFilter(matrix);
		}
		
	}

}