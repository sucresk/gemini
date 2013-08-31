package gemini.component 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 
	 */
	public class BitmapTextField extends BaseObject
	{
		public static const ALIGN_CENTER:int = 0;
		public static const ALIGN_LEFT:int = 1;
		public static const ALIGN_RIGHT:int = 2;
		
		private var _textBmpD:BitmapData;
		private var _texts:Array;
		private var _textBmpDs:Vector.<BitmapData>;
		private var _size:Number;
		private var _inactiveBmps:Vector.<Bitmap>;
		private var _activeBmps:Vector.<Bitmap>;
		private var _align:int = 0;
		private var _initWidth:Number;
		
		public function BitmapTextField(skin:Sprite,intercative:Boolean = false, autoBuild:Boolean = false) 
		{
			super(skin, intercative, autoBuild);
			_inactiveBmps = new Vector.<Bitmap>();
			_activeBmps = new Vector.<Bitmap>();
		}
		
		override protected function setSkin(skin:*):void 
		{
			super.setSkin(skin);
			_initWidth = content.width;
			var bmpD:BitmapData = new BitmapData(content.width, content.height,true,0);
			bmpD.draw(content);
			textBmpD = bmpD;
		}
		
		public function set textBmpD(b:BitmapData):void
		{
			if (content == null)
			{
				content = new Sprite();
				addChild(content);
			}
			_textBmpD = b;
			if (_texts && _texts.length > 0)
				parse();
		}
		
		public function set containText(t:String):void
		{
			_texts = t.split("");
			if (_textBmpD)
				parse();
		}
		
		private function parse():void
		{
			var w:Number = _textBmpD.width / _texts.length;
			_size = w;
			var h:Number = _textBmpD.height;
			if (_textBmpDs == null)
				_textBmpDs = new Vector.<BitmapData>();
			else
				_textBmpDs.length = 0;
			var b:BitmapData;
			
			for (var i:int = 0, len:int = _texts.length; i < len; i++)
			{
				b = new BitmapData(w, h);
				b.copyPixels(_textBmpD, new Rectangle(i * w, 0, w, h), new Point());
				_textBmpDs.push(b);
			}
		}
		
		public function set text(t:String):void
		{
			clear();
			var b:Bitmap;
			for (var i:int = 0; i < t.length; i++)
			{
				b = createBmp(t.charAt(i));
				if (b)
				{
					b.x = _size * i;
					content.addChild(b);
				}
			}
			if (_align == ALIGN_CENTER)
			{
				content.x = (_initWidth-content.width) / 2;
			}
			else if (_align == ALIGN_LEFT)
			{
				content.x = 0;
			}
			else
			{
				content.x = (_initWidth - content.width);
			}
		}
		
		public function get align():int 
		{
			return _align;
		}
		
		public function set align(value:int):void 
		{
			_align = value;
		}
		
		private function clear():void
		{
			while (content.numChildren > 0)
				destoryBmp(content.getChildAt(0));
		}
		
		public function createBmp(t:String):Bitmap
		{
			var index:int = _texts.indexOf(t)
			if (index >= 0)
			{
				var b:Bitmap;
				if (_activeBmps.length > 0)
					b = _activeBmps.pop();
				else 
					b = new Bitmap();
				b.bitmapData = _textBmpDs[index];
				return b;
			}
			return null;
		}
		
		public function destoryBmp(b:DisplayObject):void
		{
			if (b.parent)
				b.parent.removeChild(b);
			if (b is Bitmap)
				_inactiveBmps.push(b);
		}
		
		override public function destroy():void 
		{
			clear();
			for (var i:int = _textBmpDs.length - 1; i >= 0; i--)
			{
				_textBmpDs[i].dispose();
			}
			_textBmpDs.length = 0;
			_textBmpD.dispose();
			_textBmpD = null;
			super.destroy();
		}
	}

}