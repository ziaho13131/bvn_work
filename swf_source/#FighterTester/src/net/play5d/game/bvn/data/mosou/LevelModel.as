package net.play5d.game.bvn.data.mosou {
	public class LevelModel {
		
		
		public function LevelModel() {
			super();
		}
		
		public static function getLevelUpExp(level:int):int {
			function solveExp(param1:int):int {
				var _loc3_:* = param1;
				return int(3.8 * _loc3_ * _loc3_ - 1.2 * _loc3_ + 48.6);
			};
			if (level <= 0) {
				return 0;
			}
			var exp:int = solveExp(level);
			if (level > 1) {
				var i:int = 1;
				while (i < level) {
					exp += solveExp(i);
					i++;
				}
			}
			return exp;
		}
	}
}
