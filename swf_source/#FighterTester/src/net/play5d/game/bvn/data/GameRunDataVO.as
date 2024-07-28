/**
 * 已重建完成
 * 2024/6/14 新增上一局胜者血量的条件 当不处于生存模式才会重置
 */
package net.play5d.game.bvn.data {
	import net.play5d.game.bvn.data.GameMode;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.map.MapMain;
	
	/**
	 * 游戏运行数据值对象
	 */
	public class GameRunDataVO {
		
		
		public const p1FighterGroup:GameRunFighterGroup = new GameRunFighterGroup();
		public const p2FighterGroup:GameRunFighterGroup = new GameRunFighterGroup();
		
		public var map:MapMain;
		public var p1Wins:int = 0;
		public var p2Wins:int = 0;
		
		public var lastWinnerTeam:TeamVO;
		public var continueLoser:FighterMain;
		public var maxArcadeLose:int;
		public var addArcadeLifeNumb:int;
		public var initArcadeLose:Boolean = false;
		public var lastWinner:FighterMain;
		public var lastWinnerHp:int = 1000;
		public var lastLoserData:FighterVO;
		public var lastLoserQi:int = 0;
		public var lastMissionNum:int = 0;
		public var round:int = 1;
		public var gameTime:int;
		public var gameTimeMax:int;
		public var isTimerOver:Boolean;
		public var isDrawGame:Boolean;
		
		public function getWins(f:FighterMain):int {
			switch (f.team.id) {
				case 1:
					return p1Wins;
				case 2:
					return p2Wins;
				default:
					return 0;
			}
		}
		
		public function reset():void {
			p1Wins = 0;
			p2Wins = 0;
			round = 1;
			lastWinnerTeam = null;
			if(GameMode.currentMode != 30)lastWinner = null;
			lastLoserData = null;
			lastLoserQi = 0;
			isTimerOver = false;
			isDrawGame = false;
			if(GameMode.currentMode != 30)lastWinnerHp = GameData.I.config.fighterHP;
			gameTimeMax = GameData.I.config.fightTime;
			gameTime = gameTimeMax;
			continueLoser = null;
		}
		
		public function clear():void {
			if (maxArcadeLose && maxArcadeLose == -1) {
				lastMissionNum = 0;
				initArcadeLose = false;
			}
			map = null;
			lastWinnerTeam = null;
			lastWinner = null;
			lastLoserData = null;
			continueLoser = null;
		}
		
		public function nextRound():void {
			round++;
			gameTime = gameTimeMax;
			isTimerOver = false;
		}
		
		public function setAllowLoseHP(v:Boolean):void {
			if (p1FighterGroup) {
				p1FighterGroup.currentFighter.isAllowLoseHP = v;
			}
			if (p2FighterGroup) {
				p2FighterGroup.currentFighter.isAllowLoseHP = v;
			}
		}
	}
}
