/**
 * 已重建完成
 * 2024/6/14 移植了旧版所有模式的变量和检测变量集合的函数
 */
package net.play5d.game.bvn.data {
	import net.play5d.game.bvn.input.GameInputType;
	
	/**
	 * 游戏模式类
	 */
	public class GameMode {
		
		public static const TEAM_ACRADE:int = 10;				// 小队冒险
		public static const TEAM_VS_PEOPLE:int = 11;			// 小队与2p对战
		public static const TEAM_VS_CPU:int = 12;				// 小队与CPU对战
		public static const TEAM_WATCH:int = 13;				// 小队观战
		
		public static const SINGLE_ACRADE:int = 20;			// 单人冒险
		public static const SINGLE_VS_PEOPLE:int = 21;			// 单人与2p对战
		public static const SINGLE_VS_CPU:int = 22;				// 单人与CPU对战
		public static const SINGLE_WATCH:int = 23;				// 单人观战
		
		public static const PARTNER_2V2:int = 24;            // 搭档模式2v2 
		public static const PARTNER_3V3:int = 25;            // 搭档模式3v3 
		public static const PARTNER_2V2CPU:int = 26;         // 搭档电脑2v2
		public static const PARTNER_3V3CPU:int = 27;         // 搭档电脑3v3
		public static const PARTNER_2V2WATCH:int = 28;       // 搭档观战2v2
		public static const PARTNER_3V3WATCH:int = 29;       // 搭档观战3v3
		
		public static const SURVIVOR:int = 30;                // 生存模式
		
		public static const TRAINING:int = 40;					// 练习模式
		
		public static var currentMode:int;						// 当前模式
		
		/**
		 * 得到队伍
		 */
		public static function getTeams():Array {
			return [{
				id  : 1,
				name: GameInputType.P1
			}, {
				id  : 2,
				name: GameInputType.P2
			}];
		}
		
		public static function isTeamMode():Boolean {
			return currentMode == TEAM_ACRADE || 
				currentMode == TEAM_VS_PEOPLE || 
				currentMode == TEAM_VS_CPU || 
				currentMode == TEAM_WATCH || 
			    currentMode == SURVIVOR ||
				currentMode == PARTNER_2V2||
				currentMode == PARTNER_2V2CPU||	
				currentMode == PARTNER_2V2WATCH||
				currentMode == PARTNER_3V3||
				currentMode == PARTNER_3V3CPU||	
				currentMode == PARTNER_3V3WATCH;
		}
		
		public static function isSingleMode():Boolean {
			return currentMode == SINGLE_ACRADE || 
				currentMode == SINGLE_VS_PEOPLE || 
				currentMode == SINGLE_VS_CPU || 
				currentMode == SINGLE_WATCH;
		}
		
		public static function isDuoMode():Boolean {
			return currentMode == PARTNER_2V2||currentMode == PARTNER_2V2CPU||	
				currentMode == PARTNER_2V2WATCH;
		}
		
		public static function isThreeMode():Boolean {
			return currentMode == PARTNER_3V3||currentMode == PARTNER_3V3CPU||	
				currentMode == PARTNER_3V3WATCH;
		}
		
		public static function isVsPeople():Boolean {
			return currentMode == TEAM_VS_PEOPLE || 
				currentMode == SINGLE_VS_PEOPLE ||
				currentMode == PARTNER_2V2 ||
				currentMode == PARTNER_3V3;
		}
		
		public static function isVsCPU(includeTraining:Boolean = true):Boolean {
			return currentMode == TEAM_VS_CPU || 
				currentMode == SINGLE_VS_CPU ||
				currentMode == PARTNER_2V2CPU ||
				currentMode == PARTNER_3V3CPU ||
				includeTraining && currentMode == TRAINING || 
				currentMode == TEAM_WATCH || 
				currentMode == SINGLE_WATCH ||
				currentMode == PARTNER_2V2WATCH ||
				currentMode == PARTNER_3V3WATCH; 
				
		}
		
		public static function isWatch():Boolean {
			return currentMode == TEAM_WATCH || 
				currentMode == SINGLE_WATCH || 
				currentMode == PARTNER_2V2WATCH ||
				currentMode == PARTNER_3V3WATCH; 
		}
		
		public static function isAcrade():Boolean {
			return currentMode == TEAM_ACRADE || currentMode == SINGLE_ACRADE|| currentMode == SURVIVOR;
		}
		
		public function getModeName(mode:int):String {
			switch(mode) {
				case TEAM_ACRADE:
				  return "小队闯关";
				case TEAM_VS_PEOPLE:
				  return "小队对战玩家";
				case TEAM_VS_CPU:
					return "小队对战电脑";
				case TEAM_WATCH:
					return "小队观战电脑";
				case SINGLE_ACRADE:
					return "单人闯关";   
				case SINGLE_VS_PEOPLE:
					return "单人对战玩家"; 	
				case SINGLE_VS_CPU:
					return "单人对战电脑"; 	
				case SINGLE_WATCH:
					return "单人观战电脑"; 	
				case PARTNER_2V2:
					return "搭档模式2v2对战玩家";
				case PARTNER_2V2CPU:
					return "搭档模式2v2对战电脑";
				case PARTNER_2V2WATCH:
					return "搭档模式2v2观战电脑";
				case PARTNER_3V3:
					return "搭档模式3v3对战玩家";
				case PARTNER_3V3CPU:
					return "搭档模式3v3对战电脑";
				case PARTNER_3V3WATCH:
					return "搭档模式3v3观战电脑";
				case SURVIVOR:
					return "生存模式";	
				case TRAINING:
					return "生存模式";	
				default:
				  return "未知模式";
			}
		}
	}
}
