package gemini.manager
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author 
	 */
	public class LocalDataManager 
	{
		private static var _instance:LocalDataManager;
		public static function get instance():LocalDataManager
		{
			if (_instance == null)
			{
				_instance = new LocalDataManager();
			}
			return _instance;
		}
		
		private var _localData:SharedObject;
		
		private var _enable:Boolean = false;
		
		public function LocalDataManager() 
		{
			try{
				_localData = SharedObject.getLocal("yourdomain", "/");
				_enable = true;
			}
			catch (e:Error)
			{
				_enable = false;
				return;
			}
		}
		
		public function setValue(key:String, value:Object):void
		{
			if (_enable)
			{
				_localData.data[key] = value;
			}
			
		}
		
		public function getValue(key:String):Object
		{
			if (_enable)
			{
				return _localData.data[key];
			}
			return null;
		}
		
	}

}