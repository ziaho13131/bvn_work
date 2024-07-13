package net.play5d.game.bvn.data.mosou {
	import net.play5d.game.bvn.data.mosou.player.MosouFighterVO;
	import net.play5d.game.bvn.fighter.FighterMain;
	
	public class MosouFighterLogic {
		
		public static const LV_DASH_AIR:int = 4;
		
		public static const LV_GHOST_STEP:int = 12;
		
		public static const LV_SKILL1:int = 3;
		
		public static const LV_SKILL2:int = 5;
		
		public static const LV_SKILL_AIR:int = 2;
		
		public static const LV_ZHAO1:int = 0;
		
		public static const LV_ZHAO2:int = 6;
		
		public static const LV_ZHAO3:int = 4;
		
		public static const LV_CATCH1:int = 4;
		
		public static const LV_CATCH2:int = 4;
		
		public static const LV_BISHA:int = 0;
		
		public static const LV_BISHA_AIR:int = 3;
		
		public static const LV_BISHA_UP:int = 4;
		
		public static const LV_BISHA_SUPER:int = 6;
		
		public static const LV_BANKAI:int = 10;
		
		public static const ALL_ACTION_LEVELS:Array = [4, 12, 3, 5, 2, 0, 6, 4, 4, 4, 0, 3, 4, 6, 10];
		
		
		private var _fightData:MosouFighterVO;
		
		public function MosouFighterLogic(param1:MosouFighterVO) {
			super();
			_fightData = param1;
		}
		
		public function getHP():int {
			return _fightData.getHP();
		}
		
		public function getQI():int {
			return _fightData.getQI();
		}
		
		public function getEnergy():int {
			return _fightData.getEnergy();
		}
		
		/**
		 * 初始化角色属性
		 * @param fighter 角色
		 */
		public function initFighterProps(fighter:FighterMain):void {
			fighter.initAttackAddDmg(_fightData.getAttackDmg(), _fightData.getSkillDmg(), _fightData.getBishaDmg());
		}
		
		public function canDash():Boolean {
			return _fightData.getLevel() >= 0;
		}
		
		public function canDashAir():Boolean {
			return _fightData.getLevel() >= 4;
		}
		
		public function canGhostStep():Boolean {
			return _fightData.getLevel() >= 12;
		}
		
		public function canSkillAir():Boolean {
			return _fightData.getLevel() >= 2;
		}
		
		public function canSkill1():Boolean {
			return _fightData.getLevel() >= 3;
		}
		
		public function canSkill2():Boolean {
			return _fightData.getLevel() >= 5;
		}
		
		public function canZhao1():Boolean {
			return _fightData.getLevel() >= 0;
		}
		
		public function canZhao2():Boolean {
			return _fightData.getLevel() >= 6;
		}
		
		public function canZhao3():Boolean {
			return _fightData.getLevel() >= 4;
		}
		
		public function canCatch1():Boolean {
			return _fightData.getLevel() >= 4;
		}
		
		public function canCatch2():Boolean {
			return _fightData.getLevel() >= 4;
		}
		
		public function canBisha():Boolean {
			return _fightData.getLevel() >= 0;
		}
		
		public function canBishaUP():Boolean {
			return _fightData.getLevel() >= 4;
		}
		
		public function canBishaAir():Boolean {
			return _fightData.getLevel() >= 3;
		}
		
		public function canBishaSuper():Boolean {
			return _fightData.getLevel() >= 6;
		}
		
		public function canBankai():Boolean {
			return _fightData.getLevel() >= 10;
		}
	}
}
