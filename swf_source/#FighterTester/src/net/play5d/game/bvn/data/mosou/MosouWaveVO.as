package net.play5d.game.bvn.data.mosou {
	public class MosouWaveVO {
		
		
		public var id:int;
		
		public var enemies:Vector.<MosouEnemyVO>;
		
		public var repeats:Vector.<MosouWaveRepeatVO>;
		
		public var hold:int;
		
		public static function createByJSON(param1:Object):MosouWaveVO {
			var _loc6_:int = 0;
			var _loc5_:* = null;
			var _loc4_:* = null;
			var _loc7_:int = 0;
			var _loc3_:MosouWaveVO = new MosouWaveVO();
			_loc3_.hold = int(param1.hold);
			var _loc2_:Array = param1.enemies;
			_loc6_ = 0;
			while (_loc6_ < _loc2_.length) {
				_loc3_.addEnemy(MosouEnemyVO.createByJSON(_loc2_[_loc6_]));
				_loc6_++;
			}
			if (param1.repeat) {
				_loc3_.repeats = new Vector.<MosouWaveRepeatVO>();
				(_loc5_ = new MosouWaveRepeatVO()).type = param1.repeat.type;
				_loc5_.hold = param1.repeat.hold;
				_loc4_ = param1.repeat.enemies;
				_loc7_ = 0;
				while (_loc7_ < _loc4_.length) {
					_loc5_.addEnemy(MosouEnemyVO.createByJSON(_loc4_[_loc7_]));
					_loc7_++;
				}
				_loc3_.repeats.push(_loc5_);
			}
			return _loc3_;
		}
		
		public function getAllEnemies():Vector.<MosouEnemyVO> {
			if (!repeats) {
				return enemies;
			}
			var _loc1_:Vector.<MosouEnemyVO> = enemies.concat();
			for each(var _loc2_:MosouWaveRepeatVO in repeats) {
				if (_loc2_.enemies) {
					_loc1_ = _loc1_.concat(_loc2_.enemies);
				}
			}
			return _loc1_;
		}
		
		public function getAllEnemieIds():Array {
			var _loc1_:Array = [];
			var _loc3_:Vector.<MosouEnemyVO> = getAllEnemies();
			for each(var _loc2_:MosouEnemyVO in _loc3_) {
				if (_loc1_.indexOf(_loc2_.fighterID) == -1) {
					_loc1_.push(_loc2_.fighterID);
				}
			}
			return _loc1_;
		}
		
		public function getBosses():Vector.<MosouEnemyVO> {
			var _loc1_:Vector.<MosouEnemyVO> = new Vector.<MosouEnemyVO>();
			var _loc3_:Vector.<MosouEnemyVO> = getAllEnemies();
			for each(var _loc2_:MosouEnemyVO in _loc3_) {
				if (_loc2_.isBoss) {
					if (_loc1_.indexOf(_loc2_) == -1) {
						_loc1_.push(_loc2_);
					}
				}
			}
			return _loc1_;
		}
		
		public function addEnemy(param1:Vector.<MosouEnemyVO>):void {
			if (!enemies) {
				enemies = new Vector.<MosouEnemyVO>();
			}
			for each(var _loc2_:MosouEnemyVO in param1) {
				_loc2_.wave = this;
				enemies.push(_loc2_);
			}
		}
		
		public function addRepeat(param1:MosouWaveRepeatVO):void {
			if (!repeats) {
				repeats = new Vector.<MosouWaveRepeatVO>();
			}
			param1.wave = this;
			repeats.push(param1);
		}
		
		public function bossCount():int {
			var _loc1_:int = 0;
			for each(var _loc2_:MosouEnemyVO in enemies) {
				if (_loc2_.isBoss) {
					_loc1_++;
				}
			}
			return _loc1_;
		}
	}
}
