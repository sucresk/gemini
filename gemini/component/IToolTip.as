package gemini.component 
{
	
	/**
	 * ...
	 * @author sucre
	 */
	public interface IToolTip 
	{
		function setData(v:Object):void;
		function setPosition(x:int, y:int, width:int = 0, height:int = 0):void;
		function show():void;
		function hide():void;
	}
	
	
}