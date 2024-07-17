/**
 * 已重建完成
 * 2024/6/16 新增了额外的两个当前角色 和修改了删除角色的函数
 */
package net.play5d.game.bvn.data {
	import flash.utils.Dictionary;
	import net.play5d.game.bvn.fighter.Assister;
	import net.play5d.game.bvn.fighter.FighterMain;
	
	/**
	 * 游戏运行角色组
	 */
	public class GameRunFighterGroup {
		
		public var fighter1:FighterMain;
		public var fighter2:FighterMain;
		public var fighter3:FighterMain;
		public var fuzhu:Assister;
		
		public var currentFighter:FighterMain;
		public var currentFighter2:FighterMain;
		public var currentFighter3:FighterMain;
        		
//		public function getFighterDatas():Vector.<FighterVO> {
//			var vec:Vector.<FighterVO> = new Vector.<FighterVO>();
//
//			if (fighter1) {
//				vec.push(fighter1.data);
//			}
//			if (fighter2) {
//				vec.push(fighter2.data);
//			}
//			if (fighter3) {
//				vec.push(fighter3.data);
//			}
//
//			return vec;
//		}
		
		
		public function getNextFighter():FighterMain {
			switch (currentFighter) {
				case fighter1:
					return fighter2;
				case fighter2:
					return fighter3;
			}
			
			return null;
		}
		
		public function getNextFighterByMain(fighter:FighterMain):FighterMain {
			switch (fighter) {
				case fighter1:
					return fighter2;
				case fighter2:
					return fighter3;
				case fighter3:
					return fighter1;
					default:
					return null;
			}
		}
	
			
		public function destoryFighters(expect:FighterMain):void {
			if (fighter1 && fighter1 != expect) {
				disposeFighter(fighter1);
			}
			if (fighter2 && fighter2 != expect) {
				disposeFighter(fighter2);
			}
			if (fighter3 && fighter3 != expect) {
				disposeFighter(fighter3);
			}
			
			disposeFuzhu();
		}
		
		public function removeCurrentFighter():void {
			disposeFighter(currentFighter);
			if(currentFighter2)disposeFighter(currentFighter2);
			if(currentFighter3)disposeFighter(currentFighter3);
		}
		
		private function disposeFighter(f:FighterMain):void {
			if (!f) {
				return;
			}
			if (f == (currentFighter||currentFighter2||currentFighter3)) {
				currentFighter = null;
				if(GameMode.isDuoMode()||GameMode.isThreeMode()) {
					currentFighter2 = null;
				if(GameMode.isThreeMode())currentFighter3 = null; 
				}
			}
			f.destory(true);
			switch (f) {
				case fighter1:
					fighter1 = null;
					return;
				case fighter2:
					fighter2 = null;
					break;
				case fighter3:
					fighter3 = null;
			}
		}
		
		private function disposeFuzhu():void {
			if (fuzhu != null) {
				fuzhu.destory(true);
				fuzhu = null;
			}
		}
	}
}
