/**
 * @ author:sukui
 * @ date:2010-4-6
 * @ 这个类完成列表显示功能，有滚动效果，能够自定义显示的行数量和列数量，还有每次滚动的行数，或者列数
 * @ example： var itemMenu:ItemMenu = new ItemMenu(new ItemLayout(ItemLayout.HORIZONTAL, 4, 3), 60, 80, 1 10)
 * 				itemMenu.addItem(xxx);
 * 				itemMenu.setPage();
 * example中创建了一个列表是 三行四列的水平列表，列表中的每个item宽是60，高时80，间隙为10，每次滚动1列。
 * ItemLayout布局类的使用方法参见ItemLayout类的说明
 * 
 * */
package gemini.component
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gemini.utils.AssetManager;
	
	public class ItemMenu
	{
		// the items layout rules
		private var itemLayout:ItemLayout;
		
		// array for storing the items
		private var items:Array = new Array();
		
		// item's size: width and height
		public var itemWidth:Number;
		public var itemHeight:Number;
		
		protected var skin:DisplayObject;
		
		// the number for sliding the items
		private var slideCount:int;
		
		// the padding of the container
		private var padding:Number = 10;
		private var container:Sprite;
		
		// the mask for the menu
		private var itemMask:Shape;
		private var maskWidth:Number;
		private var maskHeight:Number;
		
		private var _currentIndex:int;
		private var pageIndex:int = 0;
		private var leftBtn:MovieClip;
		private var rightBtn:MovieClip;
		private var initX:Number;
		private var initY:Number;
		
		public function ItemMenu(skinName:String)
		{
			this.skin = AssetManager.instance.getMovieClip(skinName);
			
			if(this.skin.hasOwnProperty("itemContainer"))
			{
				container = (skin["itemContainer"] as Sprite)
			}
			if(this.skin.hasOwnProperty("upArrow"))
			{
				leftBtn = (skin["upArrow"] as MovieClip);
				leftBtn.stop();
				leftBtn.buttonMode = true;
				leftBtn.addEventListener(MouseEvent.CLICK, leftBtnClickHandler);
			}
			if(this.skin.hasOwnProperty("downArrow"))
			{
				rightBtn = (skin["downArrow"] as MovieClip);
				rightBtn.stop();
				rightBtn.buttonMode = true;
				rightBtn.addEventListener(MouseEvent.CLICK, rightBtnClickHandler);
			}
			leftBtn.buttonMode = false;
			//leftBtn.filters = [ColorMatrixFilterProxy.createSaturationFilter(0)];
			rightBtn.buttonMode = false;
			//rightBtn.filters = [ColorMatrixFilterProxy.createSaturationFilter(0)];
			initX = container.x;
			initY = container.y;
			
		}

		public function setLayout(itemLayout:ItemLayout, 
								 itemW:Number = 1, 
								 itemH:Number = 1, 
								 slideCount:int = 1,
								 padding:Number = 10):void
		{
			this.itemLayout = itemLayout;
			this.itemWidth = itemW;
			this.itemHeight = itemH;
			this.padding = padding;
			
			maskWidth = (itemWidth + padding) * itemLayout.columnCount;
			maskHeight = (itemHeight + padding) * itemLayout.rowCount + padding;
			
			if(itemLayout.type == ItemLayout.HORIZONTAL)
			{
				if(slideCount > itemLayout.columnCount)
				{
					this.slideCount = itemLayout.columnCount;
				}
				else
				{
					this.slideCount = slideCount;
				}
			}
			else
			{
				if(slideCount > itemLayout.rowCount)
				{
					this.slideCount = itemLayout.rowCount;
				}
				else
				{
					this.slideCount = slideCount;
				}
			}
			itemMask = new Shape();
			itemMask.graphics.beginFill(0xffffff, 1);
			itemMask.graphics.drawRect(0, 0, maskWidth, maskHeight);
			itemMask.graphics.endFill();
			itemMask.x = container.x;
			itemMask.y = container.y;
			container.parent.addChild(itemMask);
			container.mask = itemMask;					 	
		}
		private function setBtnEnable():void
		{
			if(_currentIndex <= 0)
			{
				leftBtn.buttonMode = false;
				leftBtn.mouseEnabled = false;
				//leftBtn.filters = [ColorMatrixFilterProxy.createSaturationFilter(0)];
			}
			else
			{
				leftBtn.buttonMode = true;
				leftBtn.mouseEnabled = true;
				leftBtn.filters = null;
			}
			if( currentPage >= totalPage)
			{
				rightBtn.buttonMode = false;
				rightBtn.mouseEnabled = false;
				//rightBtn.filters = [ColorMatrixFilterProxy.createSaturationFilter(0)];
			}
			else
			{
				rightBtn.buttonMode = true;
				rightBtn.mouseEnabled = true;
				rightBtn.filters = null;
			}
			
		}
		//向前滚动
		private function moveForward(slide:int = 1):void
		{
			var lastIndex:int;
			var target:Number;
			if(itemLayout.type == ItemLayout.HORIZONTAL)
			{
				if(items.length < (itemLayout.columnCount * itemLayout.rowCount)) return;
				else
				{
					if(_currentIndex >= slide) _currentIndex -= slide;
					else _currentIndex = 0;
				}
				showPrevPage();
				target = this.itemMask.x - _currentIndex *(itemWidth + padding);
				TweenUtil.to(this.container, 500, {x:target, onComplete:hideNextPage});
			}
			else
			{
				if(items.length < (itemLayout.rowCount * itemLayout.columnCount)) return;
				else
				{
					if(_currentIndex >= slide) _currentIndex -= slide;
					else _currentIndex = 0;
				}
				showPrevPage();
				target = this.itemMask.y - _currentIndex * (itemHeight + padding);
				TweenUtil.to(this.container, 500, {y:target, onComplete:hideNextPage});
			}
			setBtnEnable();
		}
		//向后滚动
		private function moveBack(slide:int = 1):void
		{
			var lastIndex:int;
			var target:Number;
			if( itemLayout.type == ItemLayout.HORIZONTAL)
			{
				if(items.length < (itemLayout.columnCount * itemLayout.rowCount)) return;
				else
				{
					if( itemLayout.arrayDir == ItemLayout.DIR_TB)
					{
						pageIndex = Math.ceil(items.length / itemLayout.rowCount);	
					}
					else
					{
						pageIndex = Math.ceil(items.length /(itemLayout.columnCount * itemLayout.rowCount)) * itemLayout.columnCount;
					}
					lastIndex = pageIndex - (_currentIndex + slide);
					if(lastIndex > itemLayout.columnCount)
					{
						_currentIndex += slide;
					}
					else _currentIndex = pageIndex - itemLayout.columnCount;
					showNextPage();
					target = itemMask.x - _currentIndex * (itemWidth + padding);
					//TweenUtil.to(container, 500, {x:target, onComplete:hidePrevPage});
					TweenLite.to(container, 500, {x:target, onComplete:hidePrevPage} );
				}
			}
			else
			{
				if( items.length < (itemLayout.rowCount * itemLayout.columnCount)) return;
				else
				{
					if( itemLayout.arrayDir == ItemLayout.DIR_LR)
					{
						pageIndex = Math.ceil(items.length / itemLayout.columnCount);
					}
					else
					{
						pageIndex = Math.ceil(items.length / (itemLayout.columnCount * itemLayout.rowCount)) * itemLayout.rowCount;	
					}
					lastIndex = pageIndex - (_currentIndex + slide);
					if( lastIndex > itemLayout.rowCount) _currentIndex += slide;
					else _currentIndex += lastIndex;
					target = itemMask.y - _currentIndex * (itemHeight + padding);
					showNextPage();
					//TweenUtil.to(container, 500, {y:target, onComplete:hidePrevPage});
					TweenLite.to(container, 500, {y:target, onComplete:hidePrevPage});
				}
			}
			setBtnEnable();
		}
		//添加item
		public function addItem(item:DisplayObject):void
		{
			items.push(item);
			setItemPosition(item, items.length - 1);
			//container.addChild(item);
			//setBtnEnable();
		}
		public function setPage():void
		{
			showNextPage();
			setBtnEnable();
		}
		private function showNextPage():void
		{
			var numOfItemInPage:int = Math.min(itemLayout.rowCount * itemLayout.columnCount, items.length - (itemLayout.rowCount * itemLayout.columnCount*(currentPage - 1)));
			for( var i:int = 0; i < numOfItemInPage; i++)
			{
				container.addChild(items[(itemLayout.rowCount * itemLayout.columnCount*(currentPage-1)) + i]);
			}
		}
		private function showPrevPage():void
		{
			//var numOfItemOutPage:int = Math.min(itemLayout.rowCount * itemLayout.columnCount, items.length - (itemLayout.rowCount * itemLayout.columnCount * (totalPage - currentPage)))
			for( var i:int = 0; i < itemLayout.rowCount * itemLayout.columnCount; i++)
			{
				var aa:int = (itemLayout.rowCount * itemLayout.columnCount*(currentPage-1)) + i;
				container.addChild(items[(itemLayout.rowCount * itemLayout.columnCount*(currentPage-1)) + i]);
			}
		}
		private function hidePrevPage():void
		{
			var numOfItemOutPage:int = Math.min(itemLayout.rowCount * itemLayout.columnCount, items.length - (itemLayout.rowCount * itemLayout.columnCount * (totalPage - currentPage + 2)))
			for( var i:int = 0; i < numOfItemOutPage; i++)
			{
				var aa:int = (itemLayout.rowCount * itemLayout.columnCount*(currentPage-2)) + i;
				container.removeChild(items[(itemLayout.rowCount * itemLayout.columnCount*(currentPage-2)) + i]);
			}
			rightBtn.buttonMode = true;
			rightBtn.mouseEnabled = true;
			setBtnEnable();
		}
		private function hideNextPage():void
		{
			var numOfItemInPage:int = Math.min(itemLayout.rowCount * itemLayout.columnCount, items.length - (itemLayout.rowCount * itemLayout.columnCount*(currentPage)));
			for( var i:int = 0; i < numOfItemInPage; i++)
			{
				var aa:int = (itemLayout.rowCount * itemLayout.columnCount*(currentPage)) + i;
				container.removeChild(items[(itemLayout.rowCount * itemLayout.columnCount*(currentPage)) + i]);
			}
			leftBtn.buttonMode = true;
			leftBtn.mouseEnabled = true;
			setBtnEnable();
		}
		public function removeAllItems():void
		{
			var itemLength:int = items.length;
			for( var i:int = 0; i < itemLength; i++)
			{
				if(items[i].parent != null)
					container.removeChild(items[i]);
			}
			items.splice(0, items.length);
			container.x = initX;
			container.y = initY;
			_currentIndex = 0;
			//setBtnEnable();
		}
		//设置item的位置
		private function setItemPosition(item:DisplayObject, index:int):void
		{
			var position:Point = itemLayout.getItemPosition(index);
			item.x = position.x * (itemWidth + padding) + padding;
			item.y = position.y * (itemHeight + padding) + padding;
		}
		//mouseEvent handler
		private function leftBtnClickHandler(e:MouseEvent):void
		{
			moveForward(slideCount);
			leftBtn.buttonMode = false;
			leftBtn.mouseEnabled = false;
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function rightBtnClickHandler(e:MouseEvent):void
		{
			moveBack(slideCount);
			rightBtn.buttonMode = false;
			rightBtn.mouseEnabled = false;
			dispatchEvent(new Event(Event.CHANGE));
		}
		//setter and getter
		//返回当前的页数
		public function get currentPage():int
		{
			if( itemLayout.type == ItemLayout.HORIZONTAL)
			{
				return Math.floor((_currentIndex + itemLayout.columnCount - 1) / itemLayout.columnCount) + 1;
			}
			else
			{
				return Math.floor((_currentIndex + itemLayout.rowCount - 1) / itemLayout.rowCount) + 1;
			}
		}
		//返回总页数
		public function get totalPage():int
		{
			return Math.ceil(items.length / (itemLayout.rowCount * itemLayout.columnCount));
		}
		
		public function destory():void
		{
			removeAllItems();
			super.destory();
		}
	}
}