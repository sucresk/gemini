package gemini.view.boiler 
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author gemini
	 */
	public class FireBoiler extends ResidualBoiler
	{
		private var _masks:Array;
		private var _displacementMapFilter:DisplacementMapFilter;
		private var _maskBitmapData:BitmapData;
		private var _cacheNum:int;
		
		public function FireBoiler(width:int, height:int, cacheNumber:int = 5) 
		{
			super(width, height);
			
			this.residualSpeed = 0.9;
			blurX = blurY = 4;
			offset = new Point(0,-4);
			itemColorTransform = new ColorTransform(0, 0, 0, 1, 255);
			
			_masks = new Array();
			_cacheNum = cacheNumber;
			for (var i:int = 0;i < cacheNumber;i++)
			{
				var bmd:BitmapData = new BitmapData(width,height);
				bmd.perlinNoise(16, 16, 1, getTimer(), false,true,BitmapDataChannel.RED | BitmapDataChannel.GREEN);
				_masks[_masks.length] = bmd;
			}
			
			_maskBitmapData = new BitmapData(width, height);
			_displacementMapFilter = new DisplacementMapFilter(_maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		
		override public function render():void 
		{
			super.render();
			
			var source:BitmapData = _masks[int(Math.random() * _cacheNum)];
			_maskBitmapData.copyPixels(source, source.rect, new Point());
			
			_bitmapData.applyFilter(_bitmapData,_bitmapData.rect,new Point(),_displacementMapFilter);
		}
		
	}

}