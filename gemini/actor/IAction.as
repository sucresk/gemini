package gemini.actor 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface IAction 
	{
		function get name():String;
		function get isPlaying():Boolean;
		function tick(intervalTime:uint):void;
		function play():void;
		function stop():void;
		
	}
	
}