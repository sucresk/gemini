package gemini.skeleton2D.skin 
{
	import gemini.skeleton2D.Bone;
	
	/**
	 * ...
	 * @author 
	 */
	public interface ISkin 
	{
		function bind(bone:Bone):void;
		function render():void;
	}
	
}