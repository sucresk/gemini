package gemini.component 
{
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import gemini.App;
	/**
	 * ...
	 * @author sucre
	 */
	public class TipText extends BaseObject implements IToolTip
	{
		private static var _instance:TipText;
		
		private var _txtInfo:TextField;
		private var _bg:Shape;
		private var _content:String;
		private var _txtFormat:TextFormat;
		public function TipText() 
		{
			super();
			_bg = new Shape();
			addChild(_bg);
			_txtInfo = new TextField();
			_txtFormat = _txtInfo.defaultTextFormat;
			_txtFormat.align = TextFormatAlign.CENTER;
			_txtInfo.defaultTextFormat = _txtFormat;
			_txtInfo.mouseEnabled = false;
			_txtInfo.selectable = false;
			_txtInfo.wordWrap = false;
			_txtInfo.multiline = true;
			//_txtInfo.width = 100;
			//_txtInfo.border = true;
			//_txtInfo.borderColor = 0xff0000;
			_txtInfo.autoSize = TextFieldAutoSize.LEFT;
			addChild(_txtInfo);
			mouseChildren = false;
			mouseEnabled = false;
			
		}
		
		
		public static function get instance():TipText
		{
			if (_instance == null)
				_instance = new TipText();
			return _instance;
		}
		
		/* INTERFACE gemini.component.IToolTip */
		
		public function setData(v:Object):void
		{
			_content = String(v);
			_txtInfo.text = _content;
			_bg.graphics.clear();
			_bg.graphics.beginFill(0xffffff);
			_bg.graphics.drawRoundRect(0, 0, _txtInfo.textWidth + 6, _txtInfo.textHeight + 3, 10);
			_bg.graphics.endFill();
		}
		
		public function setPosition(x:int, y:int, width:int = 0, height:int = 0):void
		{
			this.x = x + (width - _bg.width) * 0.5;
			this.y = y - _bg.height - 5;
			
			if (this.y < 0)
			{
				this.y = y + height + 10;
			}
			show();
		}
		
		public function show():void
		{
			App.stage.addChild(this);
		}
		
		public function hide():void
		{
			if (parent != null)
				parent.removeChild(this);
		}
		
	}

}