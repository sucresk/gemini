package gemini.component 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...可以弹出menu的object
	 * @author ...
	 */
	public class MenuObject extends BaseObject
	{
		private var _menu:IMenu;
		private var _menuVars:Object;
		
		public function MenuObject(asset:* = null, intercative:Boolean = true, autoBuild:Boolean = false) 
		{
			super(asset, intercative, autoBuild);
		}
		
		public function setMenu(menu:IMenu,vars:Object = null):void
		{
			if (_menu != null)
				_menu.hide();
				
			_menu = menu;
			_menuVars = vars;
			if (menu == null)
			{
				buttonMode = false;
				removeEventListener(MouseEvent.CLICK, hideMenuHandler);
			}
			else
			{
				buttonMode = true;
				interactiveEnable = true;
				addEventListener(MouseEvent.CLICK, showMenuHandler, false, 0, true);
			}	
		}
		
		public function changeMenu(vars:Object):void
		{
			if (_menu != null)
			{
				_menuVars = vars;
				_menu.setData(_menuVars);
			}
		}
		
		private function hideMenuHandler(e:MouseEvent):void 
		{
			if (_menu != null)
				_menu.hide();
			if (stage != null)
			{
				stage.removeEventListener(MouseEvent.CLICK, hideMenuHandler);
			}
		}
		
		private function showMenuHandler(e:MouseEvent):void 
		{
			if (_menu != null)
			{
				_menu.setData(_menuVars);
				var globalPos:Point = this.localToGlobal(new Point());
				_menu.setPosition(globalPos.x, globalPos.y, this.width, this.height);
				e.stopPropagation();
				if (stage != null)
				{
					stage.addEventListener(MouseEvent.CLICK, hideMenuHandler);
				}
			}
		}
	}

}