package gemini.manager 
{
	/**
	 * ...
	 * @author ...
	 */
	public class LangManager 
	{
		private static var _instance:LangManager;
		
		private var langMap:Object;
		
		public function LangManager() 
		{
			langMap = new Object();
		}
		
		static public function get instance():LangManager 
		{
			if (_instance == null)
				_instance = new LangManager();
			return _instance;
		}
		
		public function init(content:XML):void
		{
			for each( var item:XML in content..text)
			{
				var key:uint = uint(item.@id);
				var value:String = item;
				langMap[key] = value;
			}
		}
		
		public function getLang(id:uint, ...args):String
		{
			var text:String = langMap[id] || "null";
			if (args.length > 0)
			{
				text = text.replace(/{(\d+)}/g, 
								function(a:String, b:int, c:int, d:String):String
								{
									return b < args.length ? args[b] : a;
								}
								);
			}
			
			text = text.replace(/\\n/g, "\n");
			return text;
		}
	}

}