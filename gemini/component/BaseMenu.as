package gemini.component 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import gemini.App;
	/**
	 * ...虚类需要继承后使用。方法
	 * a:MenuObject = new MenuObject();
	 * a.setMenu(BaseMenu.instance, data);
	 * @author
	 */
	public class BaseMenu  extends BaseObject implements IMenu
	{
		
		private var _over:Boolean;
		
		public function BaseMenu(asset:* = null, intercative:Boolean = false, autoBuild:Boolean = false) 
		{
			super(asset, intercative, autoBuild);
			
			if (content != null)
			{
				content.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
				content.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			}
		}
		
		private function mouseEventHandler(e:MouseEvent):void 
		{
			switch(e.type)
			{
				case MouseEvent.ROLL_OVER:
					_over = true;
					break;
				case MouseEvent.ROLL_OUT:
					if (_over)
					{
						_over = false;
						hide();
					}
					break;
			}
		}
		
		/* INTERFACE com.kunlun.kungfu.view.components.IMenu */
		
		public function setData(v:Object):void 
		{
			
		}
		
		public function setPosition(x:int, y:int, width:int = 0, height:int = 0):void 
		{
			
		}
		
		public function show():void 
		{
			App.instance.menuLayer.addChild(this);
		}
		
		public function hide():void 
		{
			if (this.parent != null)
			{
				parent.removeChild(this);
			}
		}
		
	}

}