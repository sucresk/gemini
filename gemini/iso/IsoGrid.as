package iso 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoGrid extends Sprite
	{
		private var _parent:DisplayObjectContainer;
		private var _size:int;
		
		public function IsoGrid(parent:DisplayObjectContainer, size:int, startX:int = 0, startY:int = 0, numX:int = 0, numY:int = 0,colour:uint = 0x000000) 
		{
			_size = size;
			draw(startX, startY, numX, numY, colour);
			show(parent);
		}
		
		public function draw(startX:int, startY:int, numX:int, numY:int, colour:uint):void
		{
			var i:int = 0;
			this.graphics.clear();
			this.graphics.lineStyle(0, colour);
			var screenPoint:Point
			//draw row: x
			for ( i = startX; i <= startX + numY; i++)
			{
				screenPoint = IsoMath.isoToScreen(new IsoPoint(startX * _size, i * _size));
				this.graphics.moveTo(screenPoint.x, screenPoint.y);
				screenPoint = IsoMath.isoToScreen(new IsoPoint((startX + numY) * _size, i * _size))
				this.graphics.lineTo(screenPoint.x, screenPoint.y);
			}
			//draw line y
			for ( i = startY; i <= startY + numX; i++)
			{
				screenPoint = IsoMath.isoToScreen(new IsoPoint(i * _size, startY * _size));
				this.graphics.moveTo(screenPoint.x, screenPoint.y);
				screenPoint = IsoMath.isoToScreen(new IsoPoint(i * _size, (startY + numX) * _size));
				this.graphics.lineTo(screenPoint.x, screenPoint.y);
			}
		}
		public function show(parent:DisplayObjectContainer):void
		{
			if (_parent != parent)
			{
				_parent = parent;
				_parent.addChild(this);
			}
		}
	}

}