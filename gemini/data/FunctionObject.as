package gemini.data 
{
	/**
	 * ...
	 * @author sukui
	 */
	public class FunctionObject
	{
		public var fun:Function;
		public var params:Array;
		
		public function FunctionObject(fun:Function, params:Array = null) 
		{
			this.fun = fun;
			this.params = params;
		}
		
		public function execuse():*{
			if (fun == null) return;
			return fun.apply(null, params);
		}
		
		public function destory():void {
			fun = null;
			params = null;
		}
	}

}