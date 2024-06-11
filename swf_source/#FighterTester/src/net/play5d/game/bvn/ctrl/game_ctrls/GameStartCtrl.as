/**
 * 已重建完成
 */
package net.play5d.game.bvn.ctrl.game_ctrls {
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.data.GameMode;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.ctrl.StateCtrl;
	import net.play5d.game.bvn.fighter.FighterActionState;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.stage.GameStage;
	
	/**
	 * 游戏开始控制器
	 */
	public class GameStartCtrl {
		
		
		private var _state:GameStage;
		
		private var _p1:FighterMain;
		private var _p1_1:FighterMain;
		private var _p1_2:FighterMain;
		private var _p2:FighterMain;
		private var _p2_1:FighterMain;
		private var _p2_2:FighterMain;
		
		private var _isStart1v1:Boolean;
		private var _isStart2v2:Boolean;
		private var _isStart3v3:Boolean;
		
		private var _isStartNextRound:Boolean;
		
		private var _step:int;
		
		private var _holdFrame:int;
		
		private var _uiPlaying:Boolean;
		
		private var _introTeamId:int = -1;
		
		public function GameStartCtrl(state:GameStage) {
			_state = state;
		}
		
		public function destory():void {
			_p1 = null;
			_p2 = null;
			_state = null;
		}
		
		public function render():Boolean {
			if (_isStart1v1) {
				return renderStart1v1();
			}
			if (_isStart2v2) {
				return renderStart2v2();
			}
			if (_isStartNextRound) {
				return renderNextRound();
			}
			
			return false;
		}
		
		public function start1v1(p1:FighterMain, p2:FighterMain, introTeamId:int = -1):void {
			_p1 = p1;
			_p2 = p2;
			
			_isStart1v1 = true;
			_introTeamId = introTeamId;
			
			if (introTeamId == 1) {
				SoundCtrl.I.playFightBGM(p1.data.id);
			}
			else {
				SoundCtrl.I.playFightBGM(p2.data.id);
			}
			
			preRenderStart();
		}
		
		public function start2v2(p1:FighterMain, p2:FighterMain,p1_1:FighterMain,p2_1:FighterMain,introTeamId:int = -1):void {
			_p1 = p1;
			_p2 = p2;
			_p1_1 = p1_1;
			_p2_1 = p2_1;
			_isStart2v2 = true;
			_introTeamId = introTeamId;
			switch(introTeamId - 1){
				case 0:
					SoundCtrl.I.playFightBGM(p1.data.id);
					break;
				case 1:
					SoundCtrl.I.playFightBGM(p2.data.id);
					break;	
				default:
					SoundCtrl.I.playFightBGM(p2.data.id);
			}
			preRenderStart();
		}
		
		private function preRenderStart():void {
			_step = -1;
			
			var initStep:int = 0;
			switch (_introTeamId) {
				case -1:
					initStep = 0;
					break;
				case 1:
					if(!GameMode.isDuoMode()&&!GameMode.isTeamMode())_state.cameraFocusOne(_p1.getDisplay());
					initStep = 1;
					break;
				case 2:
					if(!GameMode.isDuoMode()&&!GameMode.isTeamMode())_state.cameraFocusOne(_p2.getDisplay());
					initStep = 2;
			}
			
			if(!GameMode.isDuoMode()&&!GameMode.isTeamMode())_state.camera.updateNow();
			StateCtrl.I.transOut(function ():void {
				_step = initStep;
			}, true);
		}
		
		private function renderStart1v1():Boolean {
			if (_uiPlaying) {
				return false;
			}
			if (_p1.actionState == FighterActionState.KAI_CHANG || 
				_p2.actionState == FighterActionState.KAI_CHANG) 
			{
				return false;
			}
			if (_holdFrame-- > 0) {
				return false;
			}
			
			switch (_step) {
				case 0:
					if (_introTeamId == -1 || _introTeamId == 1) {
						_state.cameraFocusOne(_p1.getDisplay());
						_holdFrame = 0.5 * GameConfig.FPS_GAME;
						_step = 1;
						break;
					}
					_step = 2;
					break;
				case 1:
					_p1.sayIntro();
					_holdFrame = 0.3 * GameConfig.FPS_GAME;
					_step = 2;
					break;
				case 2:
					if (_introTeamId == -1 || _introTeamId == 2) {
						_state.cameraFocusOne(_p2.getDisplay());
						_holdFrame = 0.5 * GameConfig.FPS_GAME;
						_step = 3;
						break;
					}
					_step = 4;
					break;
				case 3:
					_p2.sayIntro();
					_holdFrame = 0.3 * GameConfig.FPS_GAME;
					_step = 4;
					break;
				case 4:
					_state.cameraResume();
					_holdFrame = 0.1 * GameConfig.FPS_GAME;
					_step = 5;
					break;
				case 5:
					_uiPlaying = true;
					_state.gameUI.getUI().showStart(function ():void {
						_uiPlaying = false;
					});
					_step = 6;
					break;
				case 6:
					_p1 = null;
					_p2 = null;
					
					return true;
			}
			return false;
		}
		
		private function renderStart2v2():Boolean {
			if (_uiPlaying) {
				return false;
			}
			if (_p1.actionState == FighterActionState.KAI_CHANG || _p2.actionState == FighterActionState.KAI_CHANG) 
			{
				return false;
			}
			if (_holdFrame-- > 0) {
				return false;
			}
			
			switch (_step) {
				case 0:
					if (_introTeamId == -1 || _introTeamId == 1) {
						_state.camera.focus([_p1.getDisplay(),_p1_1.getDisplay()]);
						_state.camera.setZoom(2.6);
						_holdFrame = 0.5 * GameConfig.FPS_GAME;
						_step = 1;
						break;
					}
					_step = 2;
					break;
				case 1:
					_p1.sayIntro();
					_p1_1.sayIntro();
					_holdFrame = 0.3 * GameConfig.FPS_GAME;
					_step = 2;
					break;
				case 2:
					if (_introTeamId == -1 || _introTeamId == 2) {
						_state.camera.focus([_p2.getDisplay(),_p2_1.getDisplay()]);
						_state.camera.setZoom(2.6);
						_holdFrame = 0.5 * GameConfig.FPS_GAME;
						_step = 3;
						break;
					}
					_step = 4;
					break;
				case 3:
					_p2.sayIntro();
					_p2_1.sayIntro();
					_holdFrame = 0.3 * GameConfig.FPS_GAME;
					_step = 4;
					break;
				case 4:
					_state.cameraResume();
					_holdFrame = 0.1 * GameConfig.FPS_GAME;
					_step = 5;
					break;
				case 5:
					_uiPlaying = true;
					_state.gameUI.getUI().showStart(function ():void {
						_uiPlaying = false;
					});
					_step = 6;
					break;
				case 6:
					_p1 = null;
					_p1_1 = null;
					_p2 = null;
					_p2_1 = null
					return true;
			}
			return false;
		}
		
		
		public function startNextRound():void {
			_isStartNextRound = true;
			_uiPlaying = true;
			
			StateCtrl.I.transOut(null, true);
			
			_state.gameUI.getUI().showStart(function ():void {
				_uiPlaying = false;
			});
		}
		
		public function skip():void {
			if (_isStart1v1) {
				if (_step < 5) {
					StateCtrl.I.quickTrans();
					_state.cameraResume();
					_uiPlaying = false;
					_step = 6;
					_state.gameUI.getUI().fadIn(true);
					_p1.idle();
					_p2.idle();
					_holdFrame = 0.5 * GameConfig.FPS_GAME;
				}
			}
//			if (_isStartNextRound) {
//			}
		}
		
		private function renderNextRound():Boolean {
			return _uiPlaying == false;
		}
	}
}
