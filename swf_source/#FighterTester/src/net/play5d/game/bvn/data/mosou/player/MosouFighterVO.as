package net.play5d.game.bvn.data.mosou.player {
	import net.play5d.game.bvn.data.ISaveData;
	import net.play5d.game.bvn.data.mosou.LevelModel;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.utils.WrapInteger;
	
	public class MosouFighterVO implements ISaveData {
		
		public static var LEVEL_MAX:WrapInteger = new WrapInteger(80);
		
		
		public var id:String;
		
		private var _level:WrapInteger;
		
		private var _exp:WrapInteger;
		
		private var _atk:WrapInteger;
		
		private var _skillAtk:WrapInteger;
		
		private var _bishaAtk:WrapInteger;
		
		private var _hp:WrapInteger;
		
		private var _qi:WrapInteger;
		
		private var _energy:WrapInteger;
		
		public function MosouFighterVO() {
			_level = new WrapInteger(0);
			_exp = new WrapInteger(0);
			_atk = new WrapInteger(0);
			_skillAtk = new WrapInteger(0);
			_bishaAtk = new WrapInteger(0);
			_hp = new WrapInteger(0);
			_qi = new WrapInteger(0);
			_energy = new WrapInteger(0);
			super();
			_level.setValue(1);
			updateLevel(_level.getValue());
		}
		
		public function getAttackDmg():int {
			return _atk.getValue();
		}
		
		public function getSkillDmg():int {
			return _skillAtk.getValue();
		}
		
		public function getBishaDmg():int {
			return _bishaAtk.getValue();
		}
		
		public function getHP():int {
			return _hp.getValue();
		}
		
		public function getQI():int {
			return _qi.getValue();
		}
		
		public function getEnergy():int {
			return _energy.getValue();
		}
		
		public function getLevel():int {
			return _level.getValue();
		}
		
		public function getExp():int {
			return _exp.getValue();
		}
		
		public function addExp(param1:int):void {
			var _loc4_:int = _level.getValue();
			var _loc2_:int = _exp.getValue() + param1;
			var _loc3_:int = LevelModel.getLevelUpExp(_loc4_);
			if (_loc2_ >= _loc3_) {
				var _loc5_:Boolean = updateLevel(_loc4_ + 1);
				if (!_loc5_) {
					CONFIG::DEBUG {
						Trace("==== Level Up ! ================================================");
					}
					GameEvent.dispatchEvent("LEVEL_UP", this);
					_exp.setValue(_loc2_ - _loc3_);
				}
				else {
					_exp.setValue(_loc3_);
				}
				return;
			}
			_exp.setValue(_loc2_);
		}
		
		private function updateLevel(param1:int):Boolean {
			var _loc3_:int = LEVEL_MAX.getValue();
			var _loc4_:Boolean = false;
			if (param1 < 1) {
				param1 = 1;
			}
			if (param1 > _loc3_) {
				param1 = _loc3_;
				_loc4_ = true;
			}
			_level.setValue(param1);
			_atk.setValue(param1 * 10);
			_skillAtk.setValue(param1 * 15);
			_bishaAtk.setValue(param1 * 17);
			_hp.setValue(1000 + param1 * 150);
			_energy.setValue(50 + param1 * 10);
			var _loc2_:int = 100 + param1 * 20;
			_qi.setValue(Math.min(_loc2_, 300));
			return _loc4_;
		}
		
		public function toSaveObj():Object {
			var _loc1_:Object = {};
			_loc1_.id = id;
			_loc1_.level = _level.getValue();
			_loc1_.exp = _exp.getValue();
			return _loc1_;
		}
		
		public function readSaveObj(param1:Object):void {
			if (param1.id) {
				id = param1.id;
			}
			if (param1.exp) {
				_exp.setValue(param1.exp);
			}
			if (param1.level) {
				updateLevel(param1.level);
			}
		}
	}
}
