package gemini.manager 
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class FontsManager 
	{
		public static var embedFonts:Object = new Object();
		
		public function FontsManager() 
		{
		}
		
		public static function registerEmbedFont(fontName:String, alias:String):void
		{
			embedFonts[fontName] = alias;
		}
		
		public static function setStrictSized(txt:TextField):void
		{
			txt.selectable = false;
            txt.mouseEnabled = false;
            //txt.wordWrap = false;
			setEmbedfont(txt);
		}
		
		public static function setFixedWidth(txt:TextField):void
		{
			txt.selectable = false;
            txt.mouseEnabled = false;
			
			if (txt.defaultTextFormat.align != "justify")
			{
				txt.autoSize = txt.defaultTextFormat.align;
			}
			txt.multiline = false;
			setEmbedfont(txt);
		}
		
		private static function setEmbedfont(txt:TextField):void
		{
			var f:TextFormat = new TextFormat();
			var fontName:String = txt.defaultTextFormat.font;
			if (embedFonts[fontName] != null)
			{
				var tf:TextFormat = txt.defaultTextFormat;
				tf.font = embedFonts[fontName];
				txt.defaultTextFormat = tf;
				txt.embedFonts = true;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				return;
			}
			txt.embedFonts = false;
		}
		
	}

}