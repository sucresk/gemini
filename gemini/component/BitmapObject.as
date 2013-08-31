package gemini.component 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import gemini.manager.AssetManager;
	/**
	 * ...
	 * @author gemini
	 */
	public class BitmapObject extends BaseObject
	{
		protected var _bmp:Bitmap;
		protected var _bmpD:BitmapData;
		
		public function BitmapObject(content:* = null,intercative:Boolean = false) 
		{
			super(content, intercative);
		}
		
		public function get bitmap():Bitmap
		{
			return _bmp;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bmpD;
		}
		
		override protected function setSkin(skin:*):void 
		{
			if (skin is String)
			{
				_bmp = AssetManager.instance.getBitmap(skin);
				_bmpD = _bmp.bitmapData;
			}
			else if(skin is BitmapData)
			{
				_bmpD = skin as BitmapData;
				_bmp = new Bitmap(_bmpD);
			}
			else if (skin is Bitmap)
			{
				_bmpD = Bitmap(skin).bitmapData;
				_bmp = skin;
			}
			else
			{
				throw(new Error("skin is not a bitmap"));
			}
			
			
			addChild(_bmp);
		}
	}

}