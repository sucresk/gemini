package gemini.iso 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sukui
	 */
	public class IsoSprite extends IsoObject
	{
		private var _content:Object;
		private var _bContentInvalidated:Boolean;
		private var _container:MovieClip = new MovieClip();
		private var _oldContent:Object;
		
		public function IsoSprite(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		//setter and getter
		public function set content(v:Object):void
		{
			if (v!= null && _content != v)
			{
				_oldContent = _content;
				_content = v;
				_bContentInvalidated = true;
				if (autoRender)
					render();
			}
		}
		
		public function get content():Object
		{
			return _content;
		}
		
		override public function get container():DisplayObjectContainer 
		{ 
			return _container;
		}
		
		override public function get IsInvalidated():Boolean 
		{ 
			return super.IsInvalidated || _bContentInvalidated;
		}
		
		override public function render():void 
		{
			
			if (_bContentInvalidated)
			{
				if (_content is BitmapData)
				{
					var bm:Bitmap = new Bitmap(_content as BitmapData);
					bm.cacheAsBitmap = true;
					_container.addChild(bm);
				}
				else if (_content is DisplayObject)
				{
					if (_oldContent is DisplayObject) {
						if (DisplayObject(_oldContent).parent == _container)
						{
							_container.removeChild(DisplayObject(_oldContent));
							_oldContent = null;
						}
					}
					_container.cacheAsBitmap = true;
					_container.mouseChildren = false;
					_container.addChild(DisplayObject(_content));
				}
				else if (_content is Class)
				{
					var asset:DisplayObject = DisplayObject(new _content());
					if (asset != null)
						_container.addChild(asset);
				}
				else
					throw new Error( "skin asset is not of the following types: BitmapData, DisplayObject, or Class cast as DisplayOject." );
				_bContentInvalidated = false;
			}
			if (_bPositionInvalidated)
			{
				_container.x = this.screenX;
				_container.y = this.screenY;
			}
			if (_bDepthInvalidated)
			{
				if (owner != null)
					owner.resetObject(this);
			}
			super.render();
		}
		
		override public function destory():void 
		{
			super.destory();
			while (_container.numChildren > 0)
				_container.removeChildAt(0);
			_container.graphics.clear();
			_content = null;
		}
		
		//debug draw
		public function debugDraw(colour:uint = 0xEEEEEE):void
		{
			var size:Number = 30;
			_container.graphics.clear();
			_container.graphics.lineStyle(0);
			_container.graphics.beginFill(colour);
			_container.graphics.moveTo(0, 0);
			_container.graphics.lineTo(-size, size * 0.5);
			_container.graphics.lineTo(0, size);
			_container.graphics.lineTo(size, size * 0.5);
			_container.graphics.lineTo(0, 0);
		}
		
		public function debugDrawAsBox(colour:uint = 0xEEEEEE):void
		{
			var size:Number = 30;
			var h:Number = 30;
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