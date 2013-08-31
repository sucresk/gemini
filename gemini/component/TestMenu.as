package com.kunlun.kungfu.view.components 
{
	import com.kunlun.kungfu.App;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class TestMenu extends CoreObject implements IMenu
	{
		
		private static var _instance:TestMenu;
		public static function get instance():TestMenu
		{
			if (_instance == null)
				_instance = new TestMenu();
			return _instance;
		}
		
		public function TestMenu() 
		{
			super(null, true);
			content = new MovieClip();
			content.graphics.beginFill(0xff00ff);
			content.graphics.drawRoundRect(0, 0, 100, 100, 10);
			content.graphics.endFill();
			addChild(content);
		}
		
		
		/* INTERFACE com.kunlun.kungfu.view.components.IMenu */
		
		public function setData(v:Object):void 
		{
			if(!hasEventListener(MouseEvent.CLICK))
				addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		private function mouseClickHandler(e:MouseEvent):void 
		{
			trace("you click me");
		}
		
		public function setPosition(x:int, y:int, width:int = 0, height:int = 0):void 
		{
			//var mousePos:Point = this.localToGlobal(new Point(mouseX, mouseY));
			alignTo(x + width, y + height);
			show();
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