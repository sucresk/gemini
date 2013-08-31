package gemini.data
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	registerClassAlias("Data", BaseData);
	
	public class BaseData {
		
		public static var numNoid:int;
		
		public var id:int = -1;
		public var index:int;
		
		public static function create(value:Object, dataClass:Class = null):BaseData
		{
			if (dataClass == null)
				dataClass = BaseData;
			var data:BaseData = new dataClass();
			data.init(value);
			return data;
		}
		
		public function init(data:Object):void 
		{
			for (var prop:String in data)
			{
				if (hasOwnProperty(prop)) 
				{
					if (this[prop] is Hash) 
					{
						Hash(this[prop]).init(data[prop]);
					}
					else if (this[prop] is BaseData)
					{
						BaseData(this[prop]).init(data[prop]);
					}
					else 
					{
						this[prop]=data[prop];
					}
				}
			}
			if (id == -1)
			{
				numNoid++;
				id = -numNoid;
			}
		}
		
		public function clone():BaseData 
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeObject(this);
			bytes.position=0;
			return bytes.readObject();
		}
		
		public function getProp(prop:String):* 
		{
			return hasOwnProperty(prop) ? this[prop] : null;
		}
	}
}
