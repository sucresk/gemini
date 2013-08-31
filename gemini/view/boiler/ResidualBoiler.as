package  gemini.view.boiler
{
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import gemini.view.boiler.BitmapBoiler;
	import gemini.view.effects.bitmap.Residual;
	/**
	 * ...
	 * @author gemini
	 */
	public class ResidualBoiler extends BitmapBoiler
	{
		
		public var blurX:Number;
		public var blurY:Number;
		public var offset:Point;
		public var colorTransform:ColorTransform;
		public var effects:Vector.<BitmapFilter>;
		public var residualSpeed:Number;
		
		public function ResidualBoiler(width:int, height:int,transparent:Boolean = true,fillColor:uint = 0xffffff, speed:Number = 0.8, blurX:Number = 10,blurY:Number = 10) 
		{
			super(width, height, transparent, fillColor);
			reDraw = false;
			mouseEnabled = false;
			residualSpeed = speed;
			this.blurX = blurX;
			this.blurY = blurY;
		}
		
		override public function render():void 
		{
			if (!reDraw)
			{
				if (offset)
				{
					_bitmapData.scroll(offset.x, offset.y);
				}
				if (colorTransform)
				{
					_bitmapData.colorTransform(_bitmapData.rect, colorTransform);
				}
				if (effects)
				{
					for each (var f:BitmapFilter in effects)
						_bitmapData.applyFilter(_bitmapData,_bitmapData.rect,new Point(),f);
				}
				Residual.create(_bitmap, residualSpeed, blurX, blurY);
			}
			super.render();
		}
		
	}

}