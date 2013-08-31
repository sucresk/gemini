package gemini.iso 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author sukui
	 */
	public interface IisoObject 
	{
		function get id():int;
		function set id(v:int):void;
		
		function get data():Object;
		function set data(v:Object):void
		
		function get owner():IisoScene;
		function set owner(v:IisoScene):void;
		function get hasOwner():Boolean;
		function get IsInvalidated():Boolean;
		function render():void;
		function moveTo(x:Number, y:Number, z:Number):void;
		function moveBy(x:Number, y:Number, z:Number):void;
		function set x(v:Number):void;
		function get x():Number;
		function set y(v:Number):void;
		function get y():Number;
		function set z(v:Number):void;
		function get z():Number;
		function get screenX():Number;
		function get screenY():Number;
		function get depth():Number;
		function get drawPriority():int;
		function set drawPriority(v:int):void;
		function setDrawPriority():void;
		function setSize(length:uint, width:uint, heigh:uint):void;
		function get length():uint;
		function set length(v:uint):void;
		function get width():uint;
		function set width(v:uint):void;
		function get height():uint;
		function set height(v:uint):void;
		function get container():DisplayObjectContainer;
		function clone():IisoObject;
		function destory():void;
		function tick(interval:uint):void;
		

		
	}
	
}