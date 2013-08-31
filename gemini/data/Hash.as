package gemini.data {

	public class Hash {
		
		protected var mData:Object = {};
		protected var aData:Vector.<BaseData> = new Vector.<BaseData>();
		protected var oDataClass:Class;
		
		public function Hash(dataClass:Class = null) 
		{
			oDataClass=dataClass;
		}

		public function get length():int 
		{
			return aData.length;
		}
		
		public function init(datas:Object):void 
		{
			mData={};
			aData = new Vector.<BaseData>();
			var data:BaseData;
			if(datas is Array)
			{
				for (var i:int = 0, n:int = datas.length; i < n; i++)
				{
					data = BaseData.create(datas[i], oDataClass);
					mData[data.id] = data;
					aData[i] = data;
					data.index = i;
				}
			}
			else{
				i = 0;
				for(var key:String in datas)
				{
					data = BaseData.create(datas[key], oDataClass);
					mData[data.id] = data;
					aData[i] = data;
					data.index = int(key);
					i++;
				}
			}
		}
		
		public function change(datas:Object):void 
		{
			for each(var obj:Object in datas)
			{
				var data:BaseData = getData(obj.id);
				if (data != null) 
					data.init(obj);
			}
		}
		
		public function sort(prop:String = "id", desc:Boolean = false, prop2:String = null, desc2:Boolean = false):Hash 
		{
			aData.sort(function(a:Object,b:Object):Number {
							var propA:int=a[prop];
							var propB:int=b[prop];
							if (propA == propB) 
							{
								if (prop2 == null) return 0;
								return a[prop2] < b[prop2]?(desc2?1: -1):(desc2? -1:1);
							}
							return propA < propB?(desc?1: -1):(desc? -1:1);
						});
			return this;
		}
		
		public function clone():Hash 
		{
			var hash:Hash=new Hash(oDataClass);
			for (var i:int = 0, n:int = length; i < n; i++) 
			{
				var data:BaseData = aData[i].clone();
				hash.mData[data.id] = data;
				hash.aData[i] = data;
			}
			return hash;
		}
		
		public function filter(prop:String, value:*, operation:String = "=="):Hash 
		{
			var hash:Hash=new Hash(oDataClass);
			for(var i:int=0,n:int=length;i<n;i++) {
				var congruent:Boolean=false;
				var data:BaseData=aData[i];
				switch(operation){
					case "==":congruent=data[prop]==value;break;
					case "!=":congruent=data[prop]!=value;break;
					case "<=":congruent=data[prop]<=value;break;
					case ">=":congruent=data[prop]>=value;break;
					case "<":congruent=data[prop]<value;break;
					case ">":congruent=data[prop]>value;break;
				}
				if (congruent) {
					//data=data.clone();
					hash.mData[data.id]=data;
					hash.aData.push(data);
				}
			}
			return hash;
		}
		
		public function concat(hash:Hash):Hash 
		{
			if (hash.oDataClass==oDataClass) {
				for (var i:int = 0, n:int = hash.length; i < n; i++)
				{
					var data:BaseData = hash.getDataAt(i);
					if (hasData(data.id)) continue;
					addData(data);
				}
			}
			return this;
		}
		
		public function indexOf(id:int):int 
		{
			for(var i:int=0,n:int=length;i<n;i++){
				if (aData[i].id==id)return i;
			}
			return -1;
		}
		
		public function hasData(id:int):Boolean 
		{
			return Boolean(mData[id]);
		}
		
		public function addData(data:BaseData):void 
		{
			addDataAt(data,length);
		}
		
		public function addDataAt(data:BaseData, index:int):void 
		{
			if (index > length) index = length;
			else if (index < 0) index = 0;
			if (mData[data.id] == null) mData[data.id] = data;
			else aData.splice(indexOf(data.id), 1);
			if (index == length) aData[length] = data;
			else aData.splice(index, 0, data);
		}
		
		public function getData(id:int):BaseData 
		{
			return mData[id];
		}
		
		public function getDataAt(index:int):BaseData 
		{
			if (index<0||index>=length)return null;
			return aData[index];
		}
		
		public function delData(id:int):BaseData 
		{
			return delDataAt(indexOf(id));
		}
		
		public function delDataAt(index:int):BaseData 
		{
			var data:BaseData = getDataAt(index);
			if (data == null) return null;
			aData.splice(index, 1);
			delete mData[data.id];
			return data;
		}
	}
}
