package net.play5d.game.bvn.ctrl.mosou_ctrls {
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.ctrl.EffectCtrl;
	import net.play5d.game.bvn.ctrl.GameLogic;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.ctrl.StateCtrl;
	import net.play5d.game.bvn.ctrl.game_ctrls.GameCtrl;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.GameRunFighterGroup;
	import net.play5d.game.bvn.data.mosou.MosouEnemyVO;
	import net.play5d.game.bvn.data.mosou.MosouFighterLogic;
	import net.play5d.game.bvn.data.mosou.MosouMissionVO;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWaveRepeatVO;
	import net.play5d.game.bvn.data.mosou.MosouWaveVO;
	import net.play5d.game.bvn.data.mosou.MousouGameRunDataVO;
	import net.play5d.game.bvn.data.mosou.player.MosouFighterVO;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.factory.GameRunFactory;
	import net.play5d.game.bvn.fighter.FighterComicType;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.ctrler.EnemyBossAICtrl;
	import net.play5d.game.bvn.fighter.ctrler.EnemyFighterAICtrl;
	import net.play5d.game.bvn.fighter.events.FighterEventDispatcher;
	import net.play5d.game.bvn.interfaces.GameInterface;
	import net.play5d.game.bvn.interfaces.IFighterActionCtrl;
	import net.play5d.game.bvn.map.MapMain;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.ui.mosou.MosouUI;
	
	public class MosouCtrl {
		
		
		public const gameRunData:MousouGameRunDataVO = new MousouGameRunDataVO();
		
		private var _mission:MosouMissionVO;
		
		private var _runningWaves:Vector.<MosouWaveVO>;
		
		private var _runningWave:MosouWaveVO;
		
		private var _stageEnemies:Vector.<FighterMain>;
		
		private var _bossCount:int;
		
		private var _renderTimer:int;
		
		private var _renderTimerMax:int;
		
		private var _fighterEventCtrl:MosouFighterEventCtrl;
		
		private var _enemyBarCtrl:MosouEnemyBarCtrl;
		
		public var waveCount:int;
		
		public var currentWave:int;
		
		private var _changeFighterGap:int;
		
		private var _resumeGap:int;
		
		private var _enemyCreators:Vector.<EnemyCreator>;
		
		private var _missionComplete:Boolean;
		
		private var _gameFinish:Boolean = false;
		
		private var _addEnemyGap:int = 0;
		
		private var _introBoss:FighterMain;
		
		private var _bossInAnimate:Boolean;
		
		public function MosouCtrl() {
			_enemyCreators = new Vector.<EnemyCreator>();
			super();
		}
		
		public function getFighterEventCtrl():MosouFighterEventCtrl {
			return _fighterEventCtrl;
		}
		
		public function getGameFinished():Boolean {
			return _gameFinish;
		}
		
		public function initalize():void {
			_mission = MosouModel.I.currentMission;
			_missionComplete = false;
			_bossCount = _mission.bossCount();
			_enemyBarCtrl = new MosouEnemyBarCtrl();
			_stageEnemies = new Vector.<FighterMain>();
			_fighterEventCtrl = new MosouFighterEventCtrl();
			_fighterEventCtrl.initialize();
			waveCount = _mission.waves.length;
			currentWave = 0;
			_gameFinish = false;
		}
		
		public function destory():void {
			GameEvent.removeEventListener("LEVEL_UP", onLevelUp);
			if (_enemyBarCtrl) {
				_enemyBarCtrl.destory();
				_enemyBarCtrl = null;
			}
			if (_enemyCreators) {
				_enemyCreators = null;
			}
			if (_fighterEventCtrl) {
				_fighterEventCtrl.destory();
				_fighterEventCtrl = null;
			}
		}
		
		public function buildGame():void {
			_runningWaves = _mission.waves.concat();
			var _loc3_:GameRunFighterGroup = GameCtrl.I.gameRunData.p1FighterGroup;
			var _loc1_:Vector.<MosouFighterVO> = GameData.I.mosouData.getFighterTeam();
			_loc3_.putFighter(GameRunFactory.createFighterByMosouData(_loc3_.fighter1, _loc1_[0], "1"));
			_loc3_.putFighter(GameRunFactory.createFighterByMosouData(_loc3_.fighter2, _loc1_[1], "1"));
			_loc3_.putFighter(GameRunFactory.createFighterByMosouData(_loc3_.fighter3, _loc1_[2], "1"));
			_loc3_.currentFighter = _loc3_.getFighter(_loc3_.fighter1);
			var _loc2_:FighterMain = _loc3_.currentFighter;
			var _loc4_:MapMain = GameRunFactory.createMapByData(GameCtrl.I.gameRunData.map);
			if (!_loc2_ || !_loc4_) {
				throw new Error("创建游戏失败");
			}
			GameCtrl.I.addFighter(_loc2_, 1);
			_loc4_.initlize();
			GameCtrl.I.gameState.initMosouFight(GameCtrl.I.gameRunData.p1FighterGroup, _loc4_);
			GameLogic.initGameLogic(_loc4_, GameCtrl.I.gameState.camera);
			GameCtrl.I.initMainLogic();
			GameCtrl.I.initStart().startMosou();
			GameInterface.instance.afterBuildGame();
			GameEvent.addEventListener("LEVEL_UP", onLevelUp);
			if (Math.random() < 0.7) {
				SoundCtrl.I.playFighterBGM(_loc2_.data.id);
			}
			else {
				SoundCtrl.I.smartPlayGameBGM("map");
			}
			GameEvent.dispatchEvent("MOSOU_MISSION_START");
		}
		
		private function onLevelUp(param1:GameEvent):void {
			var _loc2_:int = 0;
			var _loc4_:GameRunFighterGroup = GameCtrl.I.gameRunData.p1FighterGroup;
			if (!_loc4_) {
				return;
			}
			var _loc5_:MosouFighterVO = param1.param;
			var _loc3_:FighterMain = _loc4_.currentFighter;
			if (_loc3_ && _loc3_.mosouPlayerData == _loc5_) {
				_loc3_.updateProperties();
				_loc2_ = MosouFighterLogic.ALL_ACTION_LEVELS.indexOf(_loc5_.getLevel());
				if (_loc2_ != -1) {
					EffectCtrl.I.doEffectById("level_up_new_act", _loc3_.x, _loc3_.y);
				}
				else {
					EffectCtrl.I.doEffectById("level_up", _loc3_.x, _loc3_.y);
				}
			}
		}
		
		public function render():void {
			_enemyBarCtrl.render();
		}
		
		public function renderAnimate():void {
			_enemyBarCtrl.renderAnimate();
			renderBossIn();
			if (!GameCtrl.I.actionEnable) {
				return;
			}
			renderWave();
			renderWaveRepeat();
			renderAddEnemy();
			renderGameTime();
			renderResumeFighters();
			if (_changeFighterGap > 0) {
				_changeFighterGap--;
			}
		}
		
		private function renderWave():void {
			if (_runningWaves.length > 0) {
				if (_renderTimer-- < 0) {
					nextWave();
				}
			}
		}
		
		private function renderResumeFighters():void {
			if (!GameCtrl.I.gameRunData || !GameCtrl.I.gameRunData.p1FighterGroup) {
				return;
			}
			if (_resumeGap-- > 0) {
				return;
			}
			var _loc2_:Vector.<FighterMain> = GameCtrl.I.gameRunData.p1FighterGroup.getHoldFighters();
			if (!_loc2_ || _loc2_.length < 1) {
				return;
			}
			for each(var _loc1_:FighterMain in _loc2_) {
				if (_loc1_.hp < _loc1_.hpMax) {
					_loc1_.hp += _loc1_.hpMax * 0.01;
					if (_loc1_.hp > _loc1_.hpMax) {
						_loc1_.hp = _loc1_.hpMax;
					}
				}
				if (_loc1_.qi < _loc1_.qiMax) {
					_loc1_.qi += _loc1_.qiMax * 0.02;
					if (_loc1_.qi > _loc1_.qiMax) {
						_loc1_.qi = _loc1_.qiMax;
					}
				}
				if (_loc1_.energy < _loc1_.energyMax) {
					_loc1_.energy += _loc1_.energyMax * 0.08;
					if (_loc1_.energy > _loc1_.energyMax) {
						_loc1_.energy = _loc1_.energyMax;
					}
				}
			}
			_resumeGap = 30;
		}
		
		private function renderAddEnemy():void {
			if (_enemyCreators.length < 1) {
				return;
			}
			var _loc1_:MosouEnemyVO = _enemyCreators[0].getNextEnemy();
			if (_loc1_) {
				addEmeny(_loc1_);
			}
			else {
				_enemyCreators.shift();
			}
			_addEnemyGap = 0;
		}
		
		private function renderWaveRepeat():void {
			var _loc2_:int = 0;
			if (!_runningWave) {
				return;
			}
			var _loc1_:Vector.<MosouWaveRepeatVO> = _runningWave.repeats;
			if (!_loc1_ || _loc1_.length < 1) {
				return;
			}
			_loc2_ = 0;
			while (_loc2_ < _loc1_.length) {
				renderRepeat(_loc1_[_loc2_]);
				_loc2_++;
			}
		}
		
		private function renderRepeat(param1:MosouWaveRepeatVO):void {
			var _loc2_:* = null;
			if (!param1.enemies || param1.enemies.length < 1) {
				return;
			}
			var _loc3_:Vector.<MosouEnemyVO> = null;
			if (param1._holdFrame > 0) {
				param1._holdFrame--;
				return;
			}
			param1._holdFrame = 30 * param1.hold;
			if (param1.type == 1) {
				_loc3_ = new Vector.<MosouEnemyVO>();
				for each(var _loc4_:MosouEnemyVO in param1.enemies) {
					_loc2_ = getEnemyByData(_loc4_);
					if (!_loc2_ || !_loc2_.isAlive || !_loc2_.getActive()) {
						_loc3_.push(_loc4_);
					}
				}
			}
			else {
				_loc3_ = param1.enemies;
			}
			if (_loc3_ && _loc3_.length > 0) {
				_enemyCreators.push(new EnemyCreator(_loc3_));
			}
		}
		
		private function renderGameTime():void {
			if (gameRunData.gameTime > 0) {
				gameRunData.gameTime--;
				if (gameRunData.gameTime <= 0) {
					gameRunData.gameTime = 0;
					onTimeOver();
				}
			}
		}
		
		public function getWavePercent():Number {
			if (currentWave >= waveCount) {
				return 1;
			}
			if (_renderTimerMax < 1) {
				return 0;
			}
			return 1 - _renderTimer / _renderTimerMax;
		}
		
		private function nextWave():void {
			if (_runningWaves.length < 1) {
				CONFIG::DEBUG {
					Trace("wave finish!");
				}
				
				return;
			}
			CONFIG::DEBUG {
				Trace("nextWave");
			}
			
			var _loc1_:MosouWaveVO = _runningWaves.shift();
			_runningWave = _loc1_;
			currentWave++;
			_renderTimerMax = _loc1_.hold * 30;
			_renderTimer = _renderTimerMax;
			if (_loc1_.enemies) {
				_enemyCreators.push(new EnemyCreator(_loc1_.enemies));
			}
		}
		
		public function addEnemyFighter(param1:FighterMain):void {
			var _loc5_:IFighterActionCtrl = null;
			if (!param1) {
				return;
			}
			if (!param1.initlized()) {
				if (param1.mosouEnemyData && param1.mosouEnemyData.isBoss) {
					((_loc5_ = new EnemyBossAICtrl()) as EnemyBossAICtrl).AILevel = 2;
					(_loc5_ as EnemyBossAICtrl).fighter = param1;
				}
				else {
					((_loc5_ = new EnemyFighterAICtrl()) as EnemyFighterAICtrl).fighter = param1;
				}
				param1.initlize();
				param1.setActionCtrl(_loc5_);
			}
			else {
				param1.relive();
			}
			param1.team = GameCtrl.I.getTeamMap().getTeam(2);
			var _loc4_:FighterMain = GameCtrl.I.gameRunData.p1FighterGroup.currentFighter;
			var _loc3_:Number = 100 + Math.random() * 100;
			var _loc2_:Number = 50 + Math.random() * 50;
			param1.x = Math.random() > 0.5
					   ? _loc4_.x + _loc3_
					   : Number(_loc4_.x - _loc3_);
			param1.y = Math.random() > 0.5
					   ? _loc4_.y + _loc2_
					   : Number(_loc4_.y - _loc2_);
			EffectCtrl.enemyBirthEffect(param1);
			GameCtrl.I.addGameSprite(2, param1);
			FighterEventDispatcher.dispatchEvent(param1, "BIRTH");
		}
		
		public function removeEnemy(param1:FighterMain):void {
			var _loc2_:int = _stageEnemies.indexOf(param1);
			if (_loc2_ != -1) {
				_stageEnemies.splice(_loc2_, 1);
			}
			GameCtrl.I.removeFighter(param1);
			checkNextOrWin();
		}
		
		private function addEmeny(param1:MosouEnemyVO):void {
			var _loc2_:FighterMain = GameRunFactory.createEnemyByData(param1);
			_stageEnemies.push(_loc2_);
			addEnemyFighter(_loc2_);
		}
		
		private function getBossEnemies(param1:Boolean = false):Vector.<FighterMain> {
			var checkIsAlive:Boolean = param1;
			return _stageEnemies.filter(function (param1:FighterMain, param2:int, param3:Vector.<FighterMain>):Boolean {
				if (checkIsAlive) {
					return param1.isAlive && param1.mosouEnemyData.isBoss;
				}
				return param1.mosouEnemyData.isBoss;
			});
		}
		
		private function getEnemyByData(param1:MosouEnemyVO):FighterMain {
			var mosouData:MosouEnemyVO = param1;
			var filtered:Vector.<FighterMain> = _stageEnemies.filter(function (param1:FighterMain,
																			   param2:int,
																			   param3:Vector.<FighterMain>):Boolean {
				return param1.mosouEnemyData == mosouData;
			});
			if (!filtered || filtered.length < 1) {
				return null;
			}
			return filtered[0];
		}
		
		private function onTimeOver():void {
			CONFIG::DEBUG {
				Trace("Mousou Time Over !!");
			}
			
			if (_missionComplete || !GameCtrl.I.actionEnable) {
				return;
			}
			
			GameCtrl.I.actionEnable = false;
			GameEvent.dispatchEvent("MOSOU_MISSION_FINISH");
			(GameUI.I.getUI() as MosouUI).showLose(function ():void {
				CONFIG::DEBUG {
					Trace("Mousou Time Over complete!");
				}
				
				backToWorldMap();
			});
		}
		
		public function onSelfDie(param1:FighterMain):void {
			CONFIG::DEBUG {
				Trace("self die!");
			}
			
			GameCtrl.I.actionEnable = false;
			EffectCtrl.I.doEffectById("hit_end", param1.x, param1.y);
			EffectCtrl.I.shine(16711680, 0.8);
			GameCtrl.I.gameState.cameraFocusOne(param1.getDisplay());
			EffectCtrl.I.slowDown(2, 5000);
		}
		
		public function onSelfDead(param1:FighterMain):void {
			var f:FighterMain = param1;
			_gameFinish = true;
			GameEvent.dispatchEvent("MOSOU_MISSION_FINISH");
			(GameUI.I.getUI() as MosouUI).showLose(function ():void {
				CONFIG::DEBUG {
					Trace("self die complete!");
				}
				
				backToWorldMap();
			});
		}
		
		public function anyWaypassMission():void {
			missionComplete();
		}
		
		private function missionComplete():void {
			if (_missionComplete || !GameCtrl.I.actionEnable) {
				return;
			}
			_gameFinish = true;
			_missionComplete = true;
			_runningWave = null;
			CONFIG::DEBUG {
				Trace("missionComplete!");
			}
			
			SoundCtrl.I.BGM(AssetManager.I.getSound("win"), false);
			GameEvent.dispatchEvent("MOSOU_MISSION_FINISH");
			GameCtrl.I.actionEnable = false;
			(GameUI.I.getUI() as MosouUI).showWin(function ():void {
				CONFIG::DEBUG {
					Trace("missionComplete complete!");
				}
				
				MosouLogic.passMission(_mission);
				backToWorldMap();
			});
		}
		
		private function backToWorldMap():void {
			StateCtrl.I.transIn(transFinish, false);
		}
		
		private function transFinish():void {
			MainGame.I.goWorldMap();
			GameEvent.dispatchEvent("MOSOU_BACK_MAP");
		}
		
		private function checkNextOrWin(param1:Boolean = false):void {
			var _loc3_:* = undefined;
			var _loc2_:Vector.<FighterMain> = getAliveEnemies();
			if (_runningWaves.length > 0) {
				if (_loc2_.length < 1) {
					if (_renderTimer > 2 * 30) {
						_renderTimer = 2 * 30;
					}
				}
				return;
			}
			if (param1) {
				_loc3_ = getBossEnemies(true);
				if (_loc3_.length < 1) {
					for each(var _loc4_:FighterMain in _loc2_) {
						_loc4_.die();
					}
					missionComplete();
				}
				return;
			}
			if (_loc2_.length < 1) {
				missionComplete();
			}
		}
		
		private function getAliveEnemies():Vector.<FighterMain> {
			return _stageEnemies.filter(function (param1:FighterMain, param2:int, param3:Vector.<FighterMain>):Boolean {
				if (param1.mosouEnemyData && param1.mosouEnemyData.repeat) {
					return false;
				}
				return param1.isAlive;
			});
		}
		
		public function changeFighter(param1:FighterMain, param2:FighterMain):void {
			if (_changeFighterGap > 0) {
				return;
			}
			var _loc3_:GameRunFighterGroup = GameCtrl.I.gameRunData.p1FighterGroup;
			GameCtrl.I.removeFighter(param1);
			param2.x = param1.x;
			param2.y = param1.y;
			param2.fzqi = 100;
			param2.direct = param1.direct;
			CONFIG::DEBUG {
				Trace("FZQI ======================= ", param2.fzqi, 100);
			}
			
			if (param2.initlized()) {
				GameCtrl.I.addGameSprite(param2.team.id, param2);
			}
			else {
				GameCtrl.I.addFighter(param2, 1);
			}
			_loc3_.currentFighter = param2;
			_changeFighterGap = 30;
			(GameUI.I.getUI() as MosouUI).updateFighter();
			EffectCtrl.I.doEffectById("team_change", param2.x, param2.y);
			param2.updatePosition();
			updateCamera();
		}
		
		public function updateEnemy(param1:FighterMain):void {
			if (_enemyBarCtrl) {
				_enemyBarCtrl.updateEnemyBar(param1);
			}
		}
		
		public function updateCamera():void {
			var _loc2_:FighterMain = GameCtrl.I.gameRunData.p1FighterGroup.currentFighter;
			var _loc4_:Vector.<FighterMain> = getBossEnemies(true);
			var _loc1_:FighterMain = _loc4_.length > 0
									 ? _loc4_[0]
									 : null;
			var _loc3_:Array = [];
			if (_loc2_) {
				_loc3_.push(_loc2_.getDisplay());
			}
			if (_loc1_) {
				_loc3_.push(_loc1_.getDisplay());
			}
			GameCtrl.I.gameState.updateCameraFocus(_loc3_);
		}
		
		public function onBossBirth(f:FighterMain):void {
			GameCtrl.I.actionEnable = false;
			_introBoss = f;
			f.getCtrler().setDirectToTarget();
			GameCtrl.I.gameState.cameraFocusOne(f.getDisplay());
			_bossInAnimate = false;
			var ui:MosouUI = GameUI.I.getUI() as MosouUI;
			if (ui) {
				ui.setBossHp(f);
				_bossInAnimate = true;
				SoundCtrl.I.BGM(null);
				ui.showBossIn(function ():void {
					_bossInAnimate = false;
					var _loc1_:Boolean = false;
					if (Math.random() < 0.5) {
						_loc1_ = SoundCtrl.I.playFighterBGM(f.data.id);
					}
					if (!_loc1_) {
						SoundCtrl.I.playBossBGM(FighterComicType.isNaruto(f.data.comicType));
					}
				});
			}
		}
		
		private function renderBossIn():void {
			if (!_introBoss) {
				return;
			}
			if (!_introBoss.introSaid) {
				if (!_introBoss.isInAir) {
					_introBoss.sayIntro();
				}
				return;
			}
			if (!_bossInAnimate && _introBoss.actionState != 60) {
				_introBoss = null;
				GameCtrl.I.actionEnable = true;
				updateCamera();
			}
		}
		
		public function onBossDie(param1:FighterMain):void {
			var f:FighterMain = param1;
			CONFIG::DEBUG {
				Trace("boss die!");
			}
			
			(GameUI.I.getUI() as MosouUI).showBossKO(f, function ():void {
			});
		}
		
		public function onBossDead(param1:FighterMain):void {
			updateCamera();
			checkNextOrWin(true);
		}
	}
}

import net.play5d.game.bvn.data.mosou.MosouEnemyVO;

class EnemyCreator {
	
	
	private var _addEnemies:Vector.<MosouEnemyVO>;
	
	function EnemyCreator(param1:Vector.<MosouEnemyVO>) {
		super();
		_addEnemies = param1.concat();
	}
	
	public function getNextEnemy():MosouEnemyVO {
		if (_addEnemies.length < 1) {
			return null;
		}
		return _addEnemies.shift();
	}
}
