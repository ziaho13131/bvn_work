package net.play5d.game.bvn.ui.bigmap {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class BigmapClould extends Sprite {
		
		
		private var _clouds:Vector.<CloudView> = new Vector.<CloudView>();
		
		private var _createFrame:int;
		
		private var _bounds:Rectangle;
		
		public function BigmapClould(param1:Rectangle) {
			_bounds = param1;
			mouseChildren = mouseEnabled = false;
		}
		
		public function init():void {
			var _loc1_:int = 0;
			_loc1_ = _bounds.y + 100;
			while (_loc1_ < _bounds.height) {
				addCloud(getRandomX(), _loc1_);
				_loc1_ += 50;
			}
		}
		
		public function destory():void {
			if (_clouds) {
				for each(var cloud:CloudView in _clouds) {
					try {
						this.removeChild(cloud.mc);
					}
					catch (e:Error) {
					}
				}
				_clouds = null;
			}
		}
		
		public function render():void {
			for each(var cloud:CloudView in _clouds) {
				if (cloud.render()) {
					try {
						CONFIG::DEBUG {
							Trace("remove cloud");
						}
						
						if (_clouds.indexOf(cloud) != -1) {
							_clouds.splice(_clouds.indexOf(cloud), 1);
						}
						this.removeChild(cloud.mc);
					}
					catch (e:Error) {
						CONFIG::DEBUG {
							Trace("BigmapClould", e);
						}
					}
				}
			}
			if (--_createFrame < 0) {
				addCloud();
				_createFrame = 5 * 30;
			}
		}
		
		private function addCloud(param1:Number = 0, param2:Number = 0):void {
			if (param1 == 0) {
				param1 = getRandomX();
			}
			if (param2 == 0) {
				param2 = _bounds.y + _bounds.height + 100;
			}
			var _loc3_:CloudView = new CloudView(param1, param2);
			this.addChild(_loc3_.mc);
			_clouds.push(_loc3_);
		}
		
		private function getRandomX():Number {
			return _bounds.x + _bounds.width / 20 * (Math.random() * 20) - 100;
		}
	}
}
