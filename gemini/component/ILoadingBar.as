package gemini.component 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author gemini
	 */
	public interface ILoadingBar
	{
		function show(parent:DisplayObjectContainer):void;
		function remove():void;
		function progress(v:Number):void;
	}
	
}