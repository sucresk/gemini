package gemini.component 
{
	import flash.text.TextField;
	import gemini.component.BaseObject;
	import gemini.component.Button;
	/**
	 * ...
	 * @author sucre
	 */
	public class TextButton extends Button
	{
		
		private var txtLabel:TextField;
		
		public function TextButton(content:*) 
		{
			super(content);
			
			txtLabel = getChildTextFieldInstance("txtLabel");
			txtLabel.mouseEnabled = false;
			txtLabel.selectable = false;
			if (txtLabel == null)
				throw new Error(content + " is not a ButtonText!");
		}
		
		public function set label(v:String):void
		{
			txtLabel.text = v;
		}
		public function get label():String
		{
			return txtLabel.text;
		}
	}

}