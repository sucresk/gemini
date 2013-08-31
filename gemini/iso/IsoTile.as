package gemini.iso 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoTile extends IsoSprite
	{
		private static var _size:uint = 0;
		
		public static function get size():uint
		{
			return _size;
		}
		
		public static function set size(v:uint):void
		{
			if (_size > 0)
				throw new Error("size can only set once");
			_size = v;
		}
		
		private var _tileX:int;
		private var _tileY:int;
		
		public function IsoTile(tileX:int = 0, tileY:int = 0) 
		{
			if (_size <= 0)
				throw new Error("pleaset set the size first");
			this.tileX = tileX;
			this.tileY = tileY;
		}
		
		//setter and getter
		public function set tileX(v:int):void
		{
			if (_tileX != v)
			{
				_tileX = v;
				x = size * _tileX;
			}
		}
		
		public function get tileX():int
		{
			return _tileX;
		}
		
		public function set tileY(v:int):void
		{
			if (_tileY != v)
			{
				_tileY = v;
				y = size * _tileY;
			}
		}
		
		public function get tileY():int
		{
			return _tileY;
		}
		
		//debug draw
		override public function debugDraw(colour:uint = 0xEEEEEE):void
		{
			var _container:Sprite = container as Sprite;
			_container.graphics.clear();
			_container.graphics.lineStyle(0);
			_container.graphics.beginFill(colour);
			_container.graphics.moveTo(0, 0);
			_container.graphics.lineTo(-size, size * 0.5);
			_container.graphics.lineTo(0, size);
			_container.graphics.lineTo(size, size * 0.5);
			_container.graphics.lineTo(0, 0);
		}
		
		override public function debugDrawAsBox(colour:uint = 0xEEEEEE):void
		{
			var _container:Sprite = container as Sprite;
			var h:Number = size * 1.2247448713915892;
			var red:uint = colour >> 16;
			var green:uint = colour >> 8 & 0xff;
			var blue:uint = colour & 0xff;
			
			var leftShadow:uint = (red * 0.5) << 16 | (green * 0.5) << 8 | (blue * 0.5);
			var rightShadow:uint = (red * 0.75) << 16 | (green * 0.75) << 8 | (blue * 0.75);
			//var h:Number = size * Y_CORRECT;
			_container.graphics.clear();
			_container.graphics.lineStyle(0);
			//top
			_container.graphics.beginFill(colour);
			_container.graphics.moveTo(0, -h);
			_container.graphics.lineTo(-size, size * 0.5 - h);
			_container.graphics.lineTo(0, size - h);
			_container.graphics.lineTo(size, size * 0.5 - h);
			_container.graphics.lineTo(0, -h);
			//left
			_container.graphics.beginFill(leftShadow);
			_container.graphics.moveTo( -size, size * 0.5 - h);
			_container.graphics.lineTo( -size, size * 0.5);
			_container.graphics.lineTo(0, size);
			_container.graphics.lineTo(0, size - h);
			_container.graphics.lineTo( -size, size * 0.5 - h);
			//right
			_container.graphics.beginFill(rightShadow);
			_container.graphics.moveTo(0, size - h);
			_container.graphics.lineTo(0, size);
			_container.graphics.lineTo(size, size * 0.5);
			_container.graphics.lineTo(size, size * 0.5 - h);
			_container.graphics.lineTo(0, size - h);
		}
	}

}