package gemini.utils 
{
	/**
	 * ...
	 * @author sukui
	 */
	public class Lang
	{
		private static var newLine:RegExp = /[\r\n]+/;
		private static var comment:RegExp = /^\s*[#!]/;
		private static var pattern:RegExp=/\{(\d+)\}|\\(u[\da-fA-F]{4}|x[\da-fA-F]{2}|.)/g;
		private static var escapes:Object={"b":"\b","f":"\f","n":"\n","r":"\r","t":"\t"};
		private static var entries:Object = new Object();
		private static var curArgs:Array = new Array();
		
		public function Lang() 
		{
			
		}
		public static function init(content:String):void
		{
			var langArr:Array = content.split(newLine);
			var langLength:int = langArr.length;
			for ( var i:int = 0; i < langLength; i++) {
				content = langArr[i];
				if (comment.test(content)) continue;
				var index:int = content.indexOf("=");
				if (index != -1)
					entries[content.substring(0, index)] = content.substring(index + 1);
			}
		}
		public static function getLang(key:String, ...args):String
		{
			var value:String = entries[key];
			if (value == null) return key;
			if (args.length <= 0) return value;
			else {
				curArgs = args;
				return value.replace(pattern, repl);
			}
		}
		private static function repl(...args):String
		{
			trace("repl" + args);
			if (args[1]) return curArgs[int(args[1])] || "";
			var arg:String = args[2];
			if (arg.length == 1) return escapes[arg] || arg;
			return String.fromCharCode(parseInt(arg.substring(1), 16));
		}
		
	}

}