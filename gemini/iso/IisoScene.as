package gemini.iso 
{
	
	/**
	 * ...
	 * @author sukui
	 */
	public interface IisoScene extends IisoObject
	{
		function contains(node:IisoObject):Boolean;
		function get children():Array;
		function get numChildren():uint;
		function addObject(node:IisoObject):void;
		function addObjectAt(node:IisoObject, index:int):void;
		function resetObject(node:IisoObject):void;
		function getObjectIndex(node:IisoObject):int;
		function getObjectAt(index:int):IisoObject;
		function getObjectById(id:int):IisoObject;
		function setObjectIndex(node:IisoObject, index:int):void;
		function removeObject(node:IisoObject):void;
		function removeObjectAt(index:int):IisoObject;
		function removeObjectById(id:int):IisoObject;
		function removeAllObjects():void;
	}
	
}