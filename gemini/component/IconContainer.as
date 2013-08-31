package gemini.component 
{
	import flash.display.MovieClip;
	import gemini.component.BaseObject;
	/**
	 * ...
	 * @author gemini
	 */
	public class IconContainer extends BaseObject
	{
		private var _icon:BaseObject;
		private var _gap:int = 5;
		private var _mask:MovieClip;
		
		public function IconContainer(skin:*) 
		{
			super(skin);
			_mask = getChildMovieClipInstance("mask");
		}
		
		public function addIconByName(name:String):void
		{
			removeIcon();
			_icon = new BaseObject(name);
			scaleTo(_icon, content.width - _gap, content.height - _gap);
			_icon.setAlignPosition(content.width * 0.5, content.height * 0.5, BaseObject.ALIGN_CENTER);
			addObject(_icon);
			if (_mask != null)
			{
				_icon.mask = _mask;
			}
		}
		
		public function addIcon(icon:BaseObject):void
		{
			removeIcon();
			_icon = icon;
			scaleTo(_icon, content.width - _gap, content.height - _gap);
			_icon.setAlignPosition(content.width * 0.5, content.height * 0.5, BaseObject.ALIGN_CENTER);
			addObject(_icon);
			if (_mask != null)
			{
				_icon.mask = _mask;
			}
			
		}
		
		public function addSimpleIcon(icon:BaseObject):void
		{
			removeIcon();
			_icon = icon;
			addObject(_icon);
			if (_mask != null)
			{
				_icon.mask = _mask;
			}
		}
		
		private function removeIcon():void
		{
			if (_icon != null && _icon.parent == this)
			{
				removeObject(_icon);
				_icon = null;
			}
		}
		private function scaleMax(target:BaseObject, maxWidth:int, maxHeight:int):void
		{
			var scaleRateA:Number;
			var scaleRateB:Number;
			if (target.width > maxWidth)
			{
				scaleRateA =  maxWidth / target.width;
			}
			if (target.height > maxHeight)
			{
				scaleRateB = maxHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA <= scaleRateB ? scaleRateA : scaleRateB);
		}
		
		private function scaleMin(target:BaseObject, minWidth:int, minHeight:int):void
		{
			var scaleRateA:Number;
			var scaleRateB:Number;
			if (target.width < minWidth)
			{
				scaleRateA = minWidth /  target.width;
			}
			if (target.height < minHeight)
			{
				scaleRateB = minHeight / target.height;
			}
			target.scaleX = target.scaleY = (scaleRateA >= scaleRateB ? scaleRateB : scaleRateA);
		}
		
		private function scaleTo(target:BaseObject, strictWidth:int, strictHeight:int):void
		{
			if (target.width < strictWidth && target.height < strictHeight)
			{
				scaleMin(target, strictWidth, strictHeight);
			}
			else
			{
				scaleMax(target, strictWidth, strictHeight);
			}
		}
		
		public function set gap(value:int):void 
		{
			_gap = value;
		}
	}

}