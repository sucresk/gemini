package gemini.component 
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	/**
	 * ...
	 * @author gemini
	 */
	public class BaseLoadingBar extends BaseObject implements ILoadingBar
	{
		private var _txtLoading:TextField;
		
		public function BaseLoadingBar() 
		{
			super("Loading");
			_txtLoading = this.getChildTextFieldInstance("txtLoading");
		}
		
		/* INTERFACE gemini.component.ILoadingBar */
		
		public function show(parent:DisplayObjectContainer):void 
		{
			parent.addChild(this);
		}
		
		public function remove():void 
		{
			if (this.parent != null)
				parent.removeChild(this);
		}
		
		public function progress(v:Number):void 
		{
			_txtLoading.text = (Math.min(int(v * 100), 99)) + "%";
		}
		
	}

}