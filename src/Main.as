package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import gemini.App;
	import gemini.component.BaseObject;
	
	/**
	 * ...
	 * @author 
	 */
	[SWF(width=300,height=400)]
	public class Main extends App 
	{
		
		public function Main():void 
		{
			
		}
		
		override protected function gameStart():void 
		{
			super.gameStart();
			var a:BaseObject = new BaseObject(new Sprite());
		}
		
	}
	
}