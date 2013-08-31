package gemini.component 
{
	import com.greensock.TweenLite;
	import gemini.App;
	import gemini.data.Vars;
	import gemini.manager.AssetManager;
	import gemini.manager.PopupManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sukui
	 */
	public class BasePopup extends BaseObject
	{
		private static var popupPool:Dictionary = new Dictionary();
		private var isDestroyed:Boolean;
		private var _instant:Boolean;
		
		/**
		 * 弹出框虚类，继承后使用，使用了对象池。
		 * 删除后不会从内存中删除，而是调用了destruct方法。
		 * 新建的时候也不是new的，而是使用Popup.create(类名)方法创建。创建时调用了reconstruct函数。
		 * 继承的时候重写这两个函数。
		 * 实现了弹框的队列，同时弹出两个时，不会两个同时弹出，而是一个关闭后，第二个才弹出。
		 * 特殊的弹出效果可以重写show方法来实现。
		 * 使用时必须先给PopManager的popupLayer属性赋值，否则报错
		 * @param	skin  美术资源的链接名或者movieclip
		 */
		public function BasePopup(skin:*) 
		{
			super(skin, true, true);
		}
		
		public static function create(popClass:Class, isInstant:Boolean = false):BasePopup {
			if (popClass==null)return null;
			var popups:Array = popupPool[popClass];
			if (popups==null) {
				popups = new Array();
				popupPool[popClass] = popups;
			}
			var popup:BasePopup;
			if (popups.length==0) {
				popup = new popClass();
			}
			else {
				popup = popups.pop();
				popup.reconstruct();
				popup.isDestroyed = false;
			}
			popup._instant = isInstant;
			if(!isInstant)
				PopupManager.instance.addPopup(popup);
			else
				PopupManager.instance.addInstantPopup(popup);
			return popup;
		}
		
		public function show(parent:DisplayObjectContainer):void {
			x = (App.STAGE_W - width) / 2;
			y = (App.STAGE_H - height) / 2;
			parent.addChild(this);
			TweenLite.from(this, 0.2, { x:App.STAGE_W / 2,
										y:App.STAGE_H / 2,
										scaleX:0,
										scaleY:0,
										alpha:0
									  } 
						   );
		}
		
		public function remove():void {
			if (parent != null) {
				parent.removeChild(this);
			}
		}
		
		override public function destroy():void {
			PopupManager.instance.removePopup(this);
			
			if (isDestroyed)return;
			isDestroyed=true;
			var popupClass:Class=Object(this).constructor as Class;
			var popups:Array = popupPool[popupClass];
			if (popups==null)popups=popupPool[popupClass]=new Array();
			popups.push(this);
			destruct();
		}
		
		protected function reconstruct():void {
			
		}
		
		protected function destruct():void {
			
		}
		
		public function get instant():Boolean 
		{
			return _instant;
		}
	}

}