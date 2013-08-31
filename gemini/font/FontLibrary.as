package {
	import flash.display.Sprite;
	import flash.text.Font;

	public class FontLibrary extends Sprite {
		[Embed(systemFont = "DFPHaiBaoW12-GB", 
				fontName = "ChsTitle", 
				fontStyle = "normal",
				fontWeight = "normal", 
				embedAsCFF = "false", 
				advancedAntiAliasing = "true",
				//unicodeRange = "",
				mimeType="application/x-font")]
		static public var ClassName : Class;

		public function FontLibrary() {
			Font.registerFont(ClassName);
		}
	}
}