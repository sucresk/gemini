package gemini.component 
{
	/**
	 * ...
	 * @author gemini
	 */
	public interface ITick 
	{
		function set tickEnable(v:Boolean):void;
		function tick(intervalTime:uint):void;
		
	}

}