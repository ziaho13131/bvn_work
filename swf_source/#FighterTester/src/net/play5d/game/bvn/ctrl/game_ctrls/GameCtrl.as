/**
 * 已重建完成
 * 2024/6/14 新增生存模式继承血量机制
 */
package net.play5d.game.bvn.ctrl.game_ctrls {
	import flash.events.DataEvent;
	
	import net.play5d.game.bvn.Debugger;
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.EffectCtrl;
	import net.play5d.game.bvn.ctrl.GameLoader;
	import net.play5d.game.bvn.ctrl.GameLogic;
	import net.play5d.game.bvn.ctrl.GameRender;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.GameMode;
	import net.play5d.game.bvn.data.GameRunDataVO;
	import net.play5d.game.bvn.data.GameRunFighterGroup;
	import net.play5d.game.bvn.data.MessionModel;
	import net.play5d.game.bvn.data.TeamMap;
	import net.play5d.game.bvn.data.TeamVO;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.fighter.FighterAttacker;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.ctrler.FighterAICtrl;
	import net.play5d.game.bvn.fighter.ctrler.FighterKeyCtrl;
	import net.play5d.game.bvn.input.GameInputType;
	import net.play5d.game.bvn.input.GameInputer;
	import net.play5d.game.bvn.interfaces.GameInterface;
	import net.play5d.game.bvn.interfaces.IFighterActionCtrl;
	import net.play5d.game.bvn.interfaces.IGameSprite;
	import net.play5d.game.bvn.map.MapMain;
	import net.play5d.game.bvn.stage.GameStage;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.utils.KeyBoarder;
	import net.play5d.game.bvn.views.effects.BitmapFilterView;
	
	/**
	 * 游戏控制器
	 */
	public class GameCtrl {
		
		private static var _i:GameCtrl;
		
		
		public var gameState:GameStage;
		
		public const gameRunData:GameRunDataVO = new GameRunDataVO();
		
		public var actionEnable:Boolean = false;
		public var autoStartAble:Boolean = true;
		public var autoEndRoundAble:Boolean = true;
		
		private var _teamMap:TeamMap = new TeamMap();
		
		private var _startCtrl:GameStartCtrl;
		private var _fighterEventCtrl:FighterEventCtrl;
		private var _trainingCtrl:TrainingCtrler;
		private var _mainLogicCtrl:GameMainLogicCtrler;
		private var _endCtrl:GameEndCtrl;
		
		private var _isRenderGame:Boolean = true;
		private var _isPauseGame:Boolean;
		private var _gameRunning:Boolean;
		
		private var _renderTimeFrame:int;
		private var _renderAnimateGap:int = 0;
		private var _renderAnimateFrame:int = 0;
		
		public var fightFinished:Boolean;
		private var _gameStartAndPause:Boolean;
		
		public static function get I():GameCtrl {
			_i ||= new GameCtrl();
			
			return _i;
		}
		
		public function getAttacker(name:String, team:int):FighterAttacker {
			return _fighterEventCtrl.getAttacker(name, team);
		}
		
		public function setRenderHit(v:Boolean):void {
			if (_mainLogicCtrl) {
				_mainLogicCtrl.renderHit = v;
			}
		}
		
		public function initlize(gameState:GameStage):void {
			this.gameState = gameState;
			
			_isPauseGame = false;
			_isRenderGame = true;
			_gameRunning = true;
			_gameStartAndPause = false;
			_fighterEventCtrl = new FighterEventCtrl();
			_fighterEventCtrl.initlize();
			_renderAnimateGap = Math.ceil(GameConfig.FPS_GAME / 30) - 1;
			
			KeyBoarder.focus();
		}
		
		private function renderPause():void {
			if (_startCtrl || _endCtrl) {
				if (GameInputer.back(1) || GameInputer.select(GameInputType.MENU, 1)) {
					if (_startCtrl ) {
						_startCtrl.skip();
					}
					if (_endCtrl ) {
						_endCtrl.skip();
					}
				}
				return;
			}
			
			if (GameInputer.back(1)) {
				if (_isPauseGame) {
					resume(true);
				}
				else {
					pause(true);
				}
			}
		}
		
		public function destory():void {
			GameRender.remove(render);
			GameLogic.clear();
			GameInputer.clearInput();
			
			if (_fighterEventCtrl ) {
				FighterEventCtrl.destory();
				_fighterEventCtrl = null;
			}
			if (_mainLogicCtrl ) {
				_mainLogicCtrl.destory();
				_mainLogicCtrl = null;
			}
			if (_trainingCtrl ) {
				_trainingCtrl.destory();
				_trainingCtrl = null;
			}
			if (_startCtrl ) {
				_startCtrl.destory();
				_startCtrl = null;
			}
			if (_endCtrl ) {
				_endCtrl.destory();
				_endCtrl = null;
			}
			if (gameState ) {
				gameState = null;
			}
			
			gameRunData.p1FighterGroup.destoryFighters(gameRunData.continueLoser);
			gameRunData.p2FighterGroup.destoryFighters(null);
			
			if (gameRunData.continueLoser == null) {
				gameRunData.clear();
				GameLoader.dispose();
			}
			_gameRunning = false;
		}
		
		public function getEnemyTeam(sp:IGameSprite):TeamVO {
			if (sp.team ) {
				return _teamMap.getTeam(sp.team.id == 1 ? 2 : 1);
			}
			return null;
		}
		
		public function addGameSprite(teamId:int, sp:IGameSprite, index:int = -1):void {
			if (index != -1) {
				gameState.addGameSpriteAt(sp, index);
			}
			else {
				gameState.addGameSprite(sp);
			}
			var team:TeamVO = _teamMap.getTeam(teamId);
			if (team) {
				sp.team = team;
				team.addChild(sp);
				if (sp is FighterMain) {
					(sp as FighterMain).targetTeams = _teamMap.getOtherTeams(teamId);
				}
			}
			else if (!(sp is BitmapFilterView)) {
				Debugger.log("GameCtrl.addGameSprite :: team is null!");
			}
		}
		
		public function removeGameSprite(sp:IGameSprite, dispose:Boolean = false):void {
			gameState.removeGameSprite(sp);
			var team:TeamVO = sp.team;
			if (team) {
				team.removeChild(sp);
			}
			
			sp.destory(dispose);
		}
		
		public function startGame():void {
			if (!autoStartAble) {
				return;
			}
			
			fightFinished = false;
			doStartGame();
		}
		
		public function doStartGame():void {
			_isPauseGame = false;
			GameInputer.enabled = true;
			
			gameRunData.reset();
			initTeam();
			buildGame();
			
			GameEvent.dispatchEvent(GameEvent.GAME_START);
			GameRender.add(render);
		}
		
		private function buildGame():void {
			var p1:FighterMain = gameRunData.p1FighterGroup.currentFighter;
			var p2:FighterMain = gameRunData.p2FighterGroup.currentFighter;
			
			if (GameMode.isDuoMode()||GameMode.isThreeMode()) {
				var p1_1:FighterMain = gameRunData.p1FighterGroup.getNextFighter();
				var p2_1:FighterMain = gameRunData.p2FighterGroup.getNextFighter();
				if (GameMode.isThreeMode()) {
					var p1_2:FighterMain = gameRunData.p1FighterGroup.getNextFighterByMain(p1_1);
					var p2_2:FighterMain = gameRunData.p2FighterGroup.getNextFighterByMain(p2_1);
				}
			}
			
			if (GameMode.currentMode == GameMode.TRAINING) {
				_trainingCtrl = new TrainingCtrler();
				_trainingCtrl.initlize([p1, p2]);
				
				gameRunData.gameTimeMax = -1;
			}
			
			var map:MapMain = gameRunData.map;
			if (!p1 || !p2 || !map) {
				throw new Error("Game creation failed!");
			}
			
			    addFighter(p1,1);
		if(p1_1)addFighter(p1_1,1,true);
		if(p1_2)addFighter(p1_2,1,true);
			    addFighter(p2,2);
		if(p2_1)addFighter(p2_1,2,true);
		if(p2_2)addFighter(p2_2,2,true);

			map.initlize();
			
			gameState.initFight(gameRunData.p1FighterGroup, gameRunData.p2FighterGroup, map);
			
			GameLogic.initGameLogic(map, gameState.camera);
			
			_mainLogicCtrl = new GameMainLogicCtrler();
			_mainLogicCtrl.initlize(gameState, _teamMap, map);
			
			//如果是生存模式 则继承上一局对局血量
			if(GameMode.currentMode == 30&&MessionModel.I.getCurrentMissionNumb != 0&&gameRunData.lastWinnerHp != 1000) {	
			p1.hp = gameRunData.lastWinnerHp;
			trace("buildGame.survival :: ("+gameRunData.lastWinnerHp+") hp inherit Succeed");
			}
			if (GameMode.currentMode == GameMode.TRAINING) {
				actionEnable = true;
				GameUI.I.fadIn();
				SoundCtrl.I.playFightBGM("map");
			}
			else if (GameMode.isDuoMode()) {
				_startCtrl = new GameStartCtrl(gameState);
				actionEnable = false;
				_startCtrl.start2v2(p1,p2,p1_1,p2_1);
			}
			else if (GameMode.isThreeMode()) {
				_startCtrl = new GameStartCtrl(gameState);
				actionEnable = false;
				_startCtrl.start3v3(p1,p2,p1_1,p1_2,p2_1,p2_2);
			}
			else {
				_startCtrl = new GameStartCtrl(gameState);
				actionEnable = false;
				_startCtrl.start1v1(p1, p2);
			}
			
			GameInterface.instance.afterBuildGame();
		}
		
		private function addFighter(fighter:FighterMain, team:int,isAI:Boolean = false):void {
			if (!fighter) {
				return;
			}
			
			var ctrl:IFighterActionCtrl;
			switch (team) {
				case 1:
					if (GameMode.isWatch()||isAI) {
						ctrl = new FighterAICtrl();
						(ctrl as FighterAICtrl).AILevel = MessionModel.I.AI_LEVEL;
						(ctrl as FighterAICtrl).fighter = fighter;
						break;
					}
					
					ctrl = new FighterKeyCtrl();
					(ctrl as FighterKeyCtrl).inputType = GameInputType.P1;
					(ctrl as FighterKeyCtrl).classicMode = GameData.I.config.keyInputMode == 1;
					break;
				case 2:
					if (GameMode.isVsCPU(false) || GameMode.isAcrade()||isAI) {
						ctrl = new FighterAICtrl();
						(ctrl as FighterAICtrl).AILevel = MessionModel.I.AI_LEVEL;
						(ctrl as FighterAICtrl).fighter = fighter;
						break;
					}
					
					ctrl = new FighterKeyCtrl();
					(ctrl as FighterKeyCtrl).inputType = GameInputType.P2;
					(ctrl as FighterKeyCtrl).classicMode = GameData.I.config.keyInputMode == 1;
					break;
			}
			
			fighter.initlize();
			fighter.setActionCtrl(ctrl);
			
			addGameSprite(team, fighter);
		}
		
		private function removeFighter(fighter:FighterMain):void {
			if (!fighter) {
				return;
			}
			
			removeGameSprite(fighter);
		}
		
//		public function startNextRound():void {
//			doBuildNextRound(GameMode.isTeamMode());
//		}
		
		private function buildNextRound(isTeamMode:Boolean):void {
			doBuildNextRound(isTeamMode);
		}
		
		private function doBuildNextRound(isTeamMode:Boolean):void {
			gameState.resetFight(gameRunData.p1FighterGroup,gameRunData.p2FighterGroup);
			
			_startCtrl = new GameStartCtrl(gameState);
			if (isTeamMode) {
				if (gameRunData.lastWinner) {
					gameRunData.lastWinner.hp = gameRunData.lastWinnerHp;
				}
				
				var loseTeam:int = -1;
				if (gameRunData.lastWinnerTeam) {
					loseTeam = gameRunData.lastWinnerTeam.id == 1 ? 2 : 1;
				}
                if(GameMode.isDuoMode()) {
					_startCtrl.start2v2(
						gameRunData.p1FighterGroup.currentFighter,
						gameRunData.p2FighterGroup.currentFighter,
						gameRunData.p1FighterGroup.currentFighter2,
						gameRunData.p2FighterGroup.currentFighter2,
						loseTeam
					);	
				}
				else if(GameMode.isThreeMode()) {
					_startCtrl.start3v3(
						gameRunData.p1FighterGroup.currentFighter,
						gameRunData.p2FighterGroup.currentFighter,
						gameRunData.p1FighterGroup.currentFighter2,
						gameRunData.p1FighterGroup.currentFighter3,
						gameRunData.p2FighterGroup.currentFighter2,
						gameRunData.p2FighterGroup.currentFighter3,
						loseTeam
					);
				}
				else{
					   _startCtrl.start1v1(
						gameRunData.p1FighterGroup.currentFighter,
						gameRunData.p2FighterGroup.currentFighter,
						loseTeam
					);	
				}
			}
			else {
				_startCtrl.startNextRound();
			}
			
			gameRunData.isDrawGame = false;
			GameEvent.dispatchEvent(GameEvent.ROUND_START);
		}
		
		public function fightFinish():void {
			fightFinished = true;
			
			if (GameMode.isAcrade()) {
				if (gameRunData.lastWinnerTeam.id == 1) {
					if (MessionModel.I.missionAllComplete()) {
						trace("mission accomplished!");
						
						MainGame.I.goCongratulations();
					}
					else {
						trace("next battle!");
						
						GameData.I.winnerId = gameRunData.p1FighterGroup.currentFighter.data.id;
						MainGame.I.goWinner();
					}
				}
				else {
					trace("go to continue!");
					
					gameRunData.continueLoser = gameRunData.p1FighterGroup.currentFighter;
					MainGame.I.goContinue();
				}
			}
			if (GameMode.isVsCPU() || GameMode.isVsPeople()) {
				trace("back select fighter!");
				
				GameEvent.dispatchEvent(GameEvent.GAME_END);
				MainGame.I.goSelect();
			}
		}
		
		private function initTeam():void {
			_teamMap.clear();
			
			var teams:Array = GameMode.getTeams();
			for each(var o:Object in teams) {
				_teamMap.add(new TeamVO(o.id, o.name));
			}
		}
		
		public function pause(pauseUI:Boolean = false):void {
			if (!_gameRunning) {
				return;
			}
			if (pauseUI && !_isPauseGame) {
				if (_startCtrl || _endCtrl) {
					_gameStartAndPause = true;
					return;
				}
				
				GameEvent.dispatchEvent(GameEvent.PAUSE_GAME);
				_isPauseGame = true;
				
				GameUI.I.getUI().pause();
				MainGame.I.stage.dispatchEvent(new DataEvent(
					"5d_message",
					false,
					false,
					JSON.stringify(["game_pause"])
				));
			}
			
			_isRenderGame = false;
		}
		
		public function resume(resumeUI:Boolean = false):void {
			if (!_gameRunning) {
				return;
			}
			
			_gameStartAndPause = false;
			if (resumeUI && _isPauseGame) {
				GameEvent.dispatchEvent(GameEvent.RESUME_GAME);
				
				_isPauseGame = false;
				GameUI.I.getUI().resume();
				MainGame.I.stage.dispatchEvent(new DataEvent(
					"5d_message",
					false,
					false,
					JSON.stringify(["game_resume"])
				));
			}
			
			KeyBoarder.focus();
			_isRenderGame = true;
		}
		
		public function gameEnd(winner:FighterMain, loser:FighterMain):void {
			if (!autoEndRoundAble) {
				return;
			}
			if (_endCtrl) {
				return;
			}
			
			doGameEnd(winner, loser);
		}
		
		public function doGameEnd(winner:FighterMain, loser:FighterMain):void {
			gameRunData.lastWinnerTeam = winner.team;
			gameRunData.lastWinner     = winner;
			gameRunData.lastLoserData  = loser.data;
			gameRunData.lastLoserQi    = loser.qi;
			
			switch (winner.team.id) {
				case 1:
					gameRunData.p1Wins++;
					
					if (loser.hp <= 0 && GameMode.isAcrade()) {
						GameLogic.addScoreByKO();
						break;
					}
					
					break;
				case 2:
					gameRunData.p2Wins++;
			}
			
			_endCtrl = new GameEndCtrl();
			_endCtrl.initlize(winner, loser);
			actionEnable = false;
			GameEvent.dispatchEvent(GameEvent.ROUND_END);
		}
		
		private function render():void {
			renderPause();
			if (_isPauseGame) {
				return;
			}
			
			EffectCtrl.I.render();
			gameState.render();
			
			if (!_isRenderGame) {
				return;
			}
			
			checkRenderAnimate();
			if (_mainLogicCtrl) {
				_mainLogicCtrl.render();
			}
			if (_startCtrl) {
				actionEnable = false;
				var fin:Boolean = _startCtrl.render();
				if (fin) {
					_startCtrl.destory();
					_startCtrl = null;
					actionEnable = true;
					gameRunData.setAllowLoseHP(true);
					if (_gameStartAndPause) {
						pause(true);
						_gameStartAndPause = false;
					}
				}
			}
			if (_endCtrl) {
				var fin2:Boolean = _endCtrl.render();
				if (fin2) {
					_endCtrl.destory();
					_endCtrl = null;
					runNext();
				}
			}
			if (_trainingCtrl) {
				_trainingCtrl.render();
			}
		}
		
		private function checkRenderAnimate():void {
			if (_renderAnimateGap > 0) {
				if (_renderAnimateFrame++ >= _renderAnimateGap) {
					_renderAnimateFrame = 0;
					renderAnimate();
				}
			}
			else {
				renderAnimate();
			}
		}
		
		private function renderAnimate():void {
			if (_mainLogicCtrl) {
				_mainLogicCtrl.renderAnimate();
			}
			if (actionEnable && !_startCtrl && !_endCtrl) {
				renderGameTime();
			}
		}
		
		private function renderGameTime():void {
			if (gameRunData.gameTimeMax != -1) {
				if (++_renderTimeFrame > 30) {
					_renderTimeFrame = 0;
					
					gameRunData.gameTime--;
					if (gameRunData.gameTime <= 0) {
						timeover();
					}
				}
			}
		}
		
		private function timeover():void {
			trace("time over!");
			
			actionEnable = false;
			var fighter1:FighterMain = gameRunData.p1FighterGroup.currentFighter;
			var fighter2:FighterMain = gameRunData.p2FighterGroup.currentFighter;
			
			gameRunData.isTimerOver = true;
			if (fighter1.hp == fighter2.hp) {
				drawGame();
				return;
			}
			
			if (fighter1.hp > fighter2.hp) {
				gameEnd(fighter1, fighter2);
			}
			else {
				gameEnd(fighter2, fighter1);
			}
		}
		
		public function drawGame():void {
			if (_endCtrl) {
				return;
			}
			
			gameRunData.lastWinnerTeam = null;
			gameRunData.lastWinner = null;
			gameRunData.isDrawGame = true;
			
			_endCtrl = new GameEndCtrl();
			_endCtrl.drawGame();
			actionEnable = false;
		}
		
		private function runNext():void {
			trace("GameMode.currentMode :: " + GameMode.currentMode);
			
			gameRunData.nextRound();
			if (GameMode.isTeamMode()&&!GameMode.isDuoMode()&&!GameMode.isThreeMode()) {
				if (startNextTeamFight()) {
					buildNextRound(true);
					gameRunData.lastWinner = null;
					return;
				}
			}
			
			if (GameMode.isSingleMode()) {
				if (gameRunData.p1Wins < 2 && gameRunData.p2Wins < 2) {
					buildNextRound(false);
					gameRunData.lastWinner = null;
					return;
				}
			}
			if (GameMode.isDuoMode()) {
				if (gameRunData.p1Wins < 2 && gameRunData.p2Wins < 2) {
					buildNextRound(false);
					gameRunData.lastWinner = null;
					return;
				}
			}
			if (GameMode.isThreeMode()) {
				if (gameRunData.p1Wins < 3 && gameRunData.p2Wins < 3) {
					buildNextRound(false);
					gameRunData.lastWinner = null;
					return;
				}
			}
			
			fightFinish();
		}
		
		private function startNextTeamFight():Boolean {
			if (gameRunData.isDrawGame) {
				var p1NextFighter:FighterMain = gameRunData.p1FighterGroup.getNextFighter();
				var p2NextFighter:FighterMain = gameRunData.p2FighterGroup.getNextFighter();
				
				if (!p1NextFighter && !p2NextFighter) {
					return true;
				}
				if (p1NextFighter && !p2NextFighter) {
					gameRunData.lastWinnerTeam = gameRunData.p1FighterGroup.currentFighter.team;
					return false;
				}
				if (!p1NextFighter && p2NextFighter) {
					gameRunData.lastWinnerTeam = gameRunData.p2FighterGroup.currentFighter.team;
					return false;
				}
				
				nextFighter(gameRunData.p1FighterGroup);
				nextFighter(gameRunData.p2FighterGroup);
				return true;
			}
			
			switch (gameRunData.lastWinnerTeam.id) {
				case 1:
					return nextFighter(gameRunData.p2FighterGroup);
				case 2:
					return nextFighter(gameRunData.p1FighterGroup);
				default:
					gameRunData.lastWinnerTeam = null;
					return true;
			}
		}
		
		private function nextFighter(fg:GameRunFighterGroup):Boolean {
			if (!fg) {
				return false;
			}
			
			var team:TeamVO = fg.currentFighter.team;
			var nextFighter:FighterMain = fg.getNextFighter();
			if (!nextFighter) {
				return false;
			}
			
			if (gameRunData.lastLoserData) {
				if (gameRunData.lastLoserData.comicType == nextFighter.data.comicType) {
					nextFighter.qi = gameRunData.lastLoserQi + 100;
				}
				else {
					nextFighter.qi = gameRunData.lastLoserQi;
				}
				if (nextFighter.qi > 300) {
					nextFighter.qi = 300;
				}
			}
			
			removeFighter(fg.currentFighter);
			fg.removeCurrentFighter();
			fg.currentFighter = nextFighter;
			
			addFighter(fg.currentFighter, team.id);
			return true;
		}
		
		public function slow(rate:Number):void {
			var animateFps:Number = 30 / rate;
			setAnimateFPS(animateFps);
			
			_mainLogicCtrl.setSpeedPlus(GameConfig.SPEED_PLUS_DEFAULT / rate);
			gameState.camera.tweenSpd = 2.5 * rate;
		}
		
		public function slowResume():void {
			setAnimateFPS(30);
			_mainLogicCtrl.setSpeedPlus(GameConfig.SPEED_PLUS_DEFAULT);
			gameState.camera.tweenSpd = 2.5;
		}
		
		private function setAnimateFPS(v:Number):void {
			_renderAnimateGap = Math.ceil(GameConfig.FPS_GAME / v) - 1;
			_renderAnimateFrame = 0;
		}
		
		public function get isRenderGame():Boolean {
			return _isRenderGame;
		}
	}
}
