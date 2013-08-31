package gemini.component 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import gemini.utils.MathUtils;
	/**
	 * ...
	 * @author ...
	 */
	public class ScrollPanel extends BaseObject
	{
		private static const MAX_SCROLL_SPEED:Number = 3;
        private static const SCROLL_SPEED:Number = 1;
        private static const SCROLL_SPEED_INCREASE_TIME:int = 1500;
		
		public var scrollEnabled:Boolean = true;
		private var _accelerationX:Number = 0.2;
		
		private var _btnLeft:Button;
		private var _btnRight:Button;
		private var _viewWidth:int;
		private var _panel:Sprite;
		private var _mouseParent:Sprite;
		private var _leftBound:Number;
		private var _rightBound:Number;
		private var _totalWidth:Number;
		private var _focusX:int = -1;
		private var _moveGesture:Boolean;
		private var _mouseHeld:Boolean;
		private var _prevScrollMouseX:Number;
		private var _prevScrollMouseY:Number;
		private var _prevScrollTime:int;
		private var _scrollSpeedX:Number = 0;
		private var _leftPressed:Boolean;
		private var _rightPressed:Boolean;
		private var _step:Number = 0;
		private var _scrollSpeedIncreaseTimer:int;
		private var _snapDirection:int;
		
		public function ScrollPanel(panel:Sprite, mouseParent:Sprite, btnLeft:Button = null, btnRight:Button = null, skin:* = null) 
		{
			super(skin);
			_btnLeft = btnLeft;
			_btnRight = btnRight;

            _panel = panel;
            _mouseParent = mouseParent;
		}
		
		public function setButtons():void
		{
			 if (_mouseParent){
                _mouseParent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
                _mouseParent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
                _mouseParent.addEventListener(MouseEvent.ROLL_OUT, onMouseUp, false, 0, true);
            };
            if (_btnLeft)
			{
                _btnLeft.addEventListener(MouseEvent.MOUSE_DOWN, onLeftDown, false, 0, true);
                _btnLeft.addEventListener(MouseEvent.MOUSE_UP, onLeftUp, false, 0, true);
                _btnLeft.addEventListener(MouseEvent.MOUSE_OUT, onLeftUp, false, 0, true);
            }
            if (_btnRight)
			{
                _btnRight.addEventListener(MouseEvent.MOUSE_DOWN, onRightDown, false, 0, true);
                _btnRight.addEventListener(MouseEvent.MOUSE_UP, onRightUp, false, 0, true);
                _btnRight.addEventListener(MouseEvent.MOUSE_OUT, onRightUp, false, 0, true);
            }
        }
		
		private function onMouseDown(e:MouseEvent):void 
		{
            _focusX = -1;
            _moveGesture = false;
            _mouseHeld = true;
            _prevScrollMouseX = mouseX;
            _prevScrollMouseY = mouseY;
            _prevScrollTime = getTimer();
            if (_mouseParent)
			{
                _mouseParent.addEventListener(MouseEvent.MOUSE_MOVE, onWorldMouseMove, false, 0, true);
            }
            e.stopImmediatePropagation();
        }
		
		private function onMouseUp(e:MouseEvent):void
		{
            _mouseHeld = false;
            if (_mouseParent)
			{
                _mouseParent.removeEventListener(MouseEvent.MOUSE_MOVE, onWorldMouseMove);
            }
        }
		private function onWorldMouseMove(e:MouseEvent):void 
		{
            var intervalTime:int;
            var distanceX:Number;
            var distanceY:Number;
            if (scrollEnabled){
                intervalTime = (getTimer() - _prevScrollTime);
                _prevScrollTime = getTimer();
                distanceX = (mouseX - _prevScrollMouseX);
                distanceY = (mouseY - _prevScrollMouseY);
                _scrollSpeedX = Math.max( -2.4, Math.min(2.4, (distanceX / intervalTime)));
                _panel.x += distanceX;			
                _prevScrollMouseX = mouseX;
                if (Math.abs(distanceX) >= 4 || Math.abs(distanceY) >= 4)
				{
                    _moveGesture = true;
                }
            }
        }
		
		private function onLeftDown(e:MouseEvent):void{
            _leftPressed = true;
            e.stopImmediatePropagation();
        }
		
		private function onLeftUp(e:MouseEvent):void{
            _leftPressed = false;
        }
		
		private function onRightDown(e:MouseEvent):void{
            _rightPressed = true;
            e.stopImmediatePropagation();
        }
		
		private function onRightUp(e:MouseEvent):void{
			_rightPressed = false;
        }
		
		public function setBounds(leftBound:Number, rightBound:Number, viewWidth:Number):void
		{
            var halfDeff:Number;
            _leftBound = leftBound;
            _rightBound = rightBound;
            _viewWidth = viewWidth;
            _totalWidth = rightBound - leftBound;
			
            if (_totalWidth < _viewWidth)
			{
                halfDeff = (_viewWidth - _totalWidth) / 2;
                _viewWidth = _totalWidth;
                _leftBound += halfDeff;
                _rightBound -= halfDeff;
            }
			setButtons();
        }
		
		public function focus(targetX:int, tween:Boolean = false):void
		{
            if (!tween)//no center maybe tween?
			{
                _panel.x = (_leftBound + targetX);
                if (_panel.x <= _leftBound)
				{
                    _panel.x = _leftBound;
                }
				else if (_panel.x > _leftBound + _viewWidth)
				{
                    _panel.x = _leftBound + _viewWidth;
                }
            } 
			else 
			{
                _focusX = targetX;
            }
        }
		
		private function getCurrentMaxScrollSpeed():Number
		{
            return Math.min(MAX_SCROLL_SPEED, (Math.floor(_scrollSpeedIncreaseTimer / SCROLL_SPEED_INCREASE_TIME) * SCROLL_SPEED + SCROLL_SPEED));
        }
		
		public function setScrollStep(step:Number):void
		{
            _step = step;
        }
		
		override public function tick(interval:uint):void
		{
			var panelTargetX:Number;
			var btnPressed:Boolean;
			var speedOffset:Number;
            _scrollSpeedIncreaseTimer += interval;
            if (_rightPressed)
			{
                _focusX = -1;
                btnPressed = true;
                if (_scrollSpeedX > 0) 
				{
                    _scrollSpeedX = -_scrollSpeedX;
                } 
				else 
				{
                    _scrollSpeedX = Math.max( -getCurrentMaxScrollSpeed(), (_scrollSpeedX - _accelerationX));
                }
            } 
			else if (_leftPressed)
			{
				_focusX = -1;
				btnPressed = true;
				if (_scrollSpeedX < 0) 
				{
					_scrollSpeedX = -_scrollSpeedX;
				} else 
				{
					_scrollSpeedX = Math.min(getCurrentMaxScrollSpeed(), (_scrollSpeedX + _accelerationX));
				}
			} 
			else 
			{
                _scrollSpeedIncreaseTimer = 0;
            }
            if (_scrollSpeedX > 0)
			{
                _snapDirection = 1;
            } 
			else if (_scrollSpeedX < 0)
			{
                _snapDirection = -1;
            }//以上为确定速度
            panelTargetX = _panel.x;
            if (_focusX != -1)
			{
                panelTargetX = (_leftBound + _focusX);
                if (panelTargetX >= _leftBound) 
				{
                    panelTargetX = _leftBound;
                } 
				else if ((panelTargetX + _totalWidth) < (_leftBound + _viewWidth))
				{
                    panelTargetX = ((_leftBound + _viewWidth) - _totalWidth);
                }
				//if (panelTargetX < _leftBound) 
				//{
                    //panelTargetX = _leftBound;
                //} 
				//else if ((panelTargetX) > (_leftBound + _viewWidth))
				//{
                    //panelTargetX = _leftBound + _viewWidth;
                //}
            } 
			else 
			{
                if (!_mouseHeld && !btnPressed)
				{
                    if (_step != 0 && Math.abs(_scrollSpeedX) <= 0.8)
					{
                        if (_snapDirection > 0) {
                            panelTargetX = Math.ceil((panelTargetX - _leftBound) / _step) * _step + _leftBound;
                        } else if (_snapDirection < 0) {
							panelTargetX = Math.floor((panelTargetX - _leftBound) / _step) * _step + _leftBound;
						};
                    };
                    if (panelTargetX >= _leftBound) {
                        panelTargetX = _leftBound;
                    } else if (panelTargetX + _totalWidth < _leftBound + _viewWidth) {
						panelTargetX = _leftBound + _viewWidth - _totalWidth;
					}
					//if (panelTargetX < _leftBound) 
					//{
						//panelTargetX = _leftBound;
					//} 
					//else if ((panelTargetX) > (_leftBound + _viewWidth))
					//{
						//panelTargetX = _leftBound + _viewWidth;
					//}
                }
            }
            if (panelTargetX != _panel.x) 
			{
                _scrollSpeedX = ((panelTargetX - _panel.x) / 50) / 4;
                if (Math.abs(panelTargetX - _panel.x) < _step){
                    _scrollSpeedX = Math.max(Math.min(_scrollSpeedX, 0.8), -0.8);
                }
                if (Math.abs(_scrollSpeedX) < 0.001){
                    _focusX = -1;
                    _scrollSpeedX = 0;
                    _snapDirection = 0;
                    _panel.x = panelTargetX;
                } else {
                    _panel.x += _scrollSpeedX * interval;
                }
            } else {
                _focusX = -1;
                if (_scrollSpeedX != 0){
                    if (!_mouseHeld){
                        _panel.x += _scrollSpeedX * interval;
                        if (_panel.x >= _leftBound){
                            _panel.x = _leftBound;
                        } else if (_panel.x + _totalWidth < _leftBound + _viewWidth){
							_panel.x = _leftBound + _viewWidth - _totalWidth;
						}
						//if (panelTargetX < _leftBound) 
						//{
							//panelTargetX = _leftBound;
						//} 
						//else if ((panelTargetX) > (_leftBound + _viewWidth))
						//{
							//panelTargetX = _leftBound + _viewWidth;
						//}
                    }
                    if (!btnPressed){
                        speedOffset = (-0.25 * Math.cos(MathUtils.getAngle(0, 0, _scrollSpeedX, 0)));
                        if (_scrollSpeedX > 0){
                            _scrollSpeedX = Math.max(0, (_scrollSpeedX + speedOffset));
                        } else if (_scrollSpeedX < 0){
							_scrollSpeedX = Math.min(0, (_scrollSpeedX + speedOffset));
						}
                    }
                }
            }
        }
		
		private function resetButtons():void
		{
			if (_btnLeft){
                if (Math.floor(_panel.x) >= Math.floor(_leftBound)){
					_btnLeft.disable = true;
                } else {
                   _btnLeft.disable = false;
                }
            };
            if (_btnRight){
                if (Math.floor(_panel.x) <= Math.ceil(((_leftBound + _viewWidth) - _totalWidth))){
                    _btnRight.disable = true;
                } else {
                    _btnRight.disable = false;
                };
            };
		}
		
		override public function destroy():void 
		{
			super.destroy();
			if (_mouseParent){
                _mouseParent.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                _mouseParent.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                _mouseParent.removeEventListener(MouseEvent.ROLL_OUT, onMouseUp);
            };
            if (_btnLeft)
			{
                _btnLeft.removeEventListener(MouseEvent.MOUSE_DOWN, onLeftDown);
                _btnLeft.removeEventListener(MouseEvent.MOUSE_UP, onLeftUp);
                _btnLeft.removeEventListener(MouseEvent.MOUSE_OUT, onLeftUp);
            }
            if (_btnRight)
			{
                _btnRight.removeEventListener(MouseEvent.MOUSE_DOWN, onRightDown);
                _btnRight.removeEventListener(MouseEvent.MOUSE_UP, onRightUp);
                _btnRight.removeEventListener(MouseEvent.MOUSE_OUT, onRightUp);
            }
			tickEnable = false;
		}
	}

}