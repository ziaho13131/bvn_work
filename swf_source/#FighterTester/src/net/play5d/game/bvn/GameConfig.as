/**
 * 已重建完成
 */
package net.play5d.game.bvn {
	import flash.geom.Point;
	
	/**
	 * 游戏配置
	 */
	public class GameConfig {
		
		public static const G:Number = 12;
		public static const G_ADD:Number = 1.2;
		public static const G_ON_FLOOR:Number = 4;
		
		public static const GAME_SIZE:Point = new Point(800, 600);
		
		public static var FPS_GAME:int = 60;
		public static const FPS_UI:int = 60;
		public static const FPS_ANIMATE:int = 30;
		public static var FPS_SHINE_EFFECT:int = 15;
		
		public static var SHOW_HOW_TO_PLAY:Boolean = false;
		
		public static var SPEED_PLUS:Number = SPEED_PLUS_DEFAULT;
		
		public static const BULLET_HOLD_FRAME_PLUS:Number = 2;
		
		public static const JUMP_DELAY_FRAME:int = 2;
		public static const JUMP_DELAY_FRAME_AIR:int = 1;
		public static const JUMP_DAMPING:Number = 0.5;
		
		public static const HURT_JUMP_FRAME:int = 15;
		public static const HURT_GAP_FRAME:int = 4;
		
		public static const BREAK_DEF_GAP_FRAME:int = 4;
		public static const BREAK_DEF_DOWN_GAP_FRAME:int = 10;
		public static const BREAK_DEF_HOLD_FRAME:int = 42;
		
		public static const DEFENSE_GAP_FRAME:int = 4;
		public static const DEFENSE_DAMPING_X:Number = 1;
		public static const DEFENSE_GAP_FRAME_DOWN:int = 8;
		public static const DEFENSE_LOSE_HP_RATE:Number = 0.05;
		public static const DEFENSE_HOLD_FRAME_MIN:int = 5;
		public static const DEFENSE_HOLD_FRAME_MAX:int = 10;
		public static const DEFENSE_HOLD_FRAME_DOWN:int = 10;
		
		public static const HURT_DAMPING_X:Number = 0.1;
		public static const HURT_DAMPING_Y:Number = 0.5;
		public static const HURT_Y_ADD_INAIR:Number = 3;
		public static const HURT_Y_ADD:Number = 6;
		
		public static const STEEL_HURT_GAP_FRAME:int = 4;
		public static const STEEL_HURT_DOWN_GAP_FRAME:int = 10;
		public static const STEEL_HURT_HP_PERCENT:Number = 0.65;
		public static const STEEL_SUPER_HURT_HP_PERCENT:Number = 0.3;
		
		public static const HURT_FLY_DAMPING_X:Number = 0;
		public static const HURT_FLY_DAMPING_Y:Number = 0.5;
		
		public static const HIT_FLOOR_DAMPING_X:Number = 2;
		public static const HIT_FLOOR_DAMPING_X_HEAVY:Number = 4;
		public static const HIT_FLOOR_TAN_Y_MIN:Number = 3;
		public static const HIT_FLOOR_TAN_Y_MAX:Number = 8;
		public static const HIT_DOWN_FRAME:int = 15;
		public static const HIT_DOWN_FRAME_HEAVY:int = 30;
		public static const HIT_DOWN_BY_HITY:int = 5;
		
		public static const NO_TOUCH_BAN_ON_VECY:int = 5;
		
		public static var HURT_FRAME_OFFSET:int = 3;
		
		public static const X_SIDE_OFFSET:int = 10;
		
		public static const HURT_DOWN_JUMP_FRAME:int = 20;
		public static const HURT_DOWN_JUMP_DAMPING:int = 1;
		
		public static const USE_ENERGY_CD:Number = 0.8;
		public static const ENERGY_ADD_NORMAL:Number = 2;
		public static const ENERGY_ADD_DEFENSE:Number = 0.8;
		public static const ENERGY_ADD_ATTACKING:Number = 1.1;
		public static const ENERGY_ADD_OVER_LOAD_PERFRAME:Number = 0.6;
		public static const ENERGY_ADD_OVER_LOAD_RESUME:Number = 30;
		
		public static const QI_ADD_HIT_BISHA_RATE:Number = 0;
		public static const QI_ADD_HIT_RATE:Number = 0.17;
		public static const QI_ADD_HIT_BULLET_RATE:Number = 0.1;
		public static const QI_ADD_HIT_ATTACKER_RATE:Number = 0.13;
		public static const QI_ADD_HIT_ASSISTER_RATE:Number = 0.15;
		public static const QI_ADD_HIT_MAX:Number = 15;
		public static const QI_ADD_HURT_RATE:Number = 0.08;
		public static const QI_ADD_HURT_MAX:Number = 20;
		
		public static const FUZHU_QU_ADD_PERFRAME:Number = 0.2;
		
		public static const CAMERA_TWEEN_SPD:Number = 2.5;
		
		public static const FIGHTER_HP_MAX:int = 1000;
		
		public static var ArcadeIntSwitch:Boolean = false;
		
		public static var isLimitedTimedBankai:Boolean = false;
		
//		public static var MAP_LOGO_STATE:int = 0;
		
		/**
		 * 设置游戏 FPS
		 * @param v fps
		 */
		public static function setGameFps(v:int):void {
			FPS_GAME = v;
			SPEED_PLUS = SPEED_PLUS_DEFAULT;
		}
		
		/**
		 * 获得加速度默认值
		 */
		public static function get SPEED_PLUS_DEFAULT():Number {
			return 30 / FPS_GAME;
		}
	}
}
