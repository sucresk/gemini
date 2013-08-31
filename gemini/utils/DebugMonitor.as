package gemini.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author sucre
	 */
	public class DebugMonitor extends Sprite
	{
		public static const MKMODE_T:String = "MKMODE_T";
		public static const MKMODE_B:String = "MKMODE_B";
		public static const MKMODE_L:String = "MKMODE_L";
		public static const MKMODE_R:String = "MKMODE_R";
		public static const MKMODE_TL:String = "MKMODE_TL";
		public static const MKMODE_TR:String = "MKMODE_TR";
		public static const MKMODE_BL:String = "MKMODE_BL";
		public static const MKMODE_BR:String = "MKMODE_BR";
		
		private var monitorTf:TextField;
		private var lastTime:int = getTimer();
		private var mode:String;
		
		public function DebugMonitor(mode:String) 
		{
			this.mode = mode;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			monitorTf = new TextField();
			monitorTf.selectable = false;
			monitorTf.background = true;
			monitorTf.textColor = 0xffffff;
			monitorTf.backgroundColor = 0x000000;
			monitorTf.autoSize = TextFieldAutoSize.LEFT;
			
			var monitorFormat:TextFormat = new TextFormat();
			monitorFormat.font = "Tahoma";
			monitorFormat.size = 10;
			monitorTf.setTextFormat(monitorFormat);
			monitorTf.text = "loading...";
			addChild(monitorTf);
			stage.addEventListener(Event.ENTER_FRAME, tick);
			
			switch (mode) {
				case MKMODE_T:
					monitorTf.x = stage.stageWidth / 2 - monitorTf.width / 2;
					monitorTf.y = 0;
				break;
				case MKMODE_B:
					monitorTf.x = stage.stageWidth / 2 - monitorTf.width / 2;
					monitorTf.y = stage.stageHeight - monitorTf.height;
				break;
				case MKMODE_L:
					monitorTf.x = 0;
					monitorTf.y = stage.stageHeight / 2 - monitorTf.height / 2;
				break;
				case MKMODE_R:
					monitorTf.x = stage.stageWidth - monitorTf.width;
					monitorTf.y = stage.stageHeight / 2 - monitorTf.height / 2;
				break;
				case MKMODE_TL:
					monitorTf.x = 0;
					monitorTf.y = 0;
				break;
				case MKMODE_TR:
					monitorTf.x = stage.stageWidth - monitorTf.width;
					monitorTf.y = 0;
				break;
				case MKMODE_BL:
					monitorTf.x = 0;
					monitorTf.y = stage.stageHeight - monitorTf.height;
				break;
				case MKMODE_BR:
					monitorTf.x = stage.stageWidth - monitorTf.width;
					monitorTf.y = stage.stageHeight - monitorTf.height;
				break;
				default:
				break;
			}
		}
		
		private function tick(e:Event):void 
		{
			var curTime:int = getTimer();
			var deltaTime:int = curTime - lastTime;
			lastTime = curTime;
			var fps:Number = 1 / deltaTime * 1000;
			monitorTf.text = "FPS: " + fps.toFixed(1);
			monitorTf.appendText("\nMem: " + Number(System.totalMemory / 1024 / 1024).toFixed(3) + "M");
		}
		
	}

}