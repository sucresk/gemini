package gemini.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import gemini.App;
	import gemini.component.BasePopup;
	/**
	 * ...
	 * @author sukui
	 */
	public class PopupManager
	{
		private static var _instance:PopupManager;
		
		private var mask:Bitmap;
		public var popupLayer:DisplayObjectContainer;
		
		private var allPopups:Array = new Array();
		private var _instantPopups:Vector.<BasePopup> = new Vector.<BasePopup>();
		private var popupList:Dictionary = new Dictionary();
		private var _curPopup:BasePopup;
		
		/**
		 * 弹框的管理类，主要实现了队列，控制弹框一个一个的弹出
		 * 使用时必须先给popupLayer属性赋值，否则报错
		 */
		public static function get instance():PopupManager {
			if (_instance == null) _instance = new PopupManager();
			return _instance;
		}
		
		public function PopupManager() 
		{
			mask = new Bitmap(new BitmapData(1, 1, true, 0x00999900));
			mask.width = App.stage.stageWidth;
			mask.height = App.stage.stageHeight;
			App.stage.addEventListener(Event.RESIZE, onResize);
			popupLayer = App.instance.popupLayer;
		}
		
		public function hasPopup(popup:BasePopup):Boolean {
			return popup.parent == popupLayer || popupList[popup];
		}
		
		public function addPopup(popup:BasePopup):void {
			addPopupAt(popup, allPopups.length);
		}
		
		public function addInstantPopup(popup:BasePopup):void
		{
			_instantPopups.push(popup);
			showPopup(popup);
		}
		
		public function addPopupAt(popup:BasePopup,index:int=0):void {
			if (index<0)index=0;
			if (popupLayer.numChildren == 0) 
				showPopup(popup);
			else {
				if (index < allPopups.length) 
					allPopups.splice(index, 0, popup);
				else 
					allPopups[allPopups.length] = popup;
				popupList[popup]=true;
			}
		}
		
		public function showPopup(popup:BasePopup):void {
			popupLayer.addChild(mask);
			popup.show(popupLayer);
			_curPopup = popup;
		}
		
		public function removePopup(popup:BasePopup):void {
			if (hasPopup(popup) == false) 
				return;
			if (popup.instant)
			{
				_instantPopups.splice(_instantPopups.indexOf(popup), 1);
			}
			if (popupList[popup]) 
				removeFromList(popup);
			else 
			{
				popup.remove();
				if (popupLayer.numChildren > 1) 
				{
					popupLayer.setChildIndex(mask, popupLayer.numChildren - 2);
					_curPopup = popupLayer.getChildAt(popupLayer.numChildren - 1) as BasePopup;
					return;
				}
				if (allPopups.length == 0)
				{
					_curPopup = null;
					popupLayer.removeChild(mask);
				}
				else 
					showPopup(allPopups.shift());
			}
		}
		
		private function removeFromList(popup:BasePopup):void 
		{
			delete popupList[popup];
			for (var i:int = 0, length:int = allPopups.length; i < length; i++) 
			{ 
				if (allPopups[i] == popup)
				{
					allPopups.splice(i,1);
					return;
				}
			}
		}
		
		private function onResize(event:Event):void 
		{
			mask.width = App.stage.stageWidth + 100;
			mask.height = App.stage.stageHeight + 100;
			mask.x = (App.stage.stageWidth - mask.width) / 2;
			mask.y = (App.stage.stageHeight - mask.height) / 2;
		}
		
	}

}