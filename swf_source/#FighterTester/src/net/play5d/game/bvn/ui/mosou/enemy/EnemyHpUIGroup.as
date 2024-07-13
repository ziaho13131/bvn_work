package net.play5d.game.bvn.ui.mosou.enemy {
	import flash.display.Sprite;
	
	import net.play5d.game.bvn.fighter.FighterMain;
	
	public class EnemyHpUIGroup {
		
		
		private var _uis:Vector.<EnemyHpUI>;
		
		private var _ct:Sprite;
		
		public function EnemyHpUIGroup(param1:Sprite) {
			super();
			_ct = param1;
			_uis = new Vector.<EnemyHpUI>();
		}
		
		public function updateFighter(param1:FighterMain):void {
			var _loc2_:int = 0;
			_loc2_ = 0;
			while (_loc2_ < _uis.length) {
				if (_uis[_loc2_].getFighter() == param1) {
					return;
				}
				_loc2_++;
			}
			addUI(param1);
		}
		
		public function removeByFighter(param1:FighterMain):void {
			var _loc2_:int = 0;
			_loc2_ = 0;
			while (_loc2_ < _uis.length) {
				if (_uis[_loc2_] && _uis[_loc2_].getFighter() == param1) {
					removeUI(_uis[_loc2_]);
				}
				_loc2_++;
			}
			sortUI();
		}
		
		public function render():void {
			var _loc3_:int = 0;
			var _loc1_:* = null;
			var _loc2_:Vector.<EnemyHpUI> = new Vector.<EnemyHpUI>();
			_loc3_ = 0;
			while (_loc3_ < _uis.length) {
				if (!_uis[_loc3_].render()) {
					_loc2_.push(_uis[_loc3_]);
				}
				_loc3_++;
			}
			if (_loc2_.length > 0) {
				while (_loc2_.length > 0) {
					_loc1_ = _loc2_.shift();
					removeUI(_loc1_);
				}
				sortUI();
			}
		}
		
		private function addUI(param1:FighterMain):void {
			var _loc2_:EnemyHpUI = new EnemyHpUI(param1);
			_uis.push(_loc2_);
			sortUI();
		}
		
		private function removeUI(param1:EnemyHpUI):void {
			var _loc2_:int = _uis.indexOf(param1);
			if (_loc2_ != -1) {
				_uis.splice(_loc2_, 1);
			}
		}
		
		private function sortUI():void {
			var _loc4_:int = 0;
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc1_:int = Math.min(_uis.length, 12);
			_ct.removeChildren();
			_loc3_ = 0;
			while (_loc3_ < _loc1_) {
				_uis[_loc3_].getUI().x = _loc4_;
				_uis[_loc3_].getUI().y = _loc2_;
				_loc4_ -= 110;
				if ((_loc3_ + 1) % 4 == 0) {
					_loc4_ = 0;
					_loc2_ += 30;
				}
				_ct.addChild(_uis[_loc3_].getUI());
				_loc3_++;
			}
		}
	}
}
