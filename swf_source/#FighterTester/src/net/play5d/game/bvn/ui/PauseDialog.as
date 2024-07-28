/**
 * 已重建完成
 * 2024/06/13 移植老版本选项
 */
package net.play5d.game.bvn.ui {
	import flash.display.Sprite;
	import flash.events.DataEvent;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.game_ctrls.GameCtrl;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.GameMode;
	import net.play5d.game.bvn.data.MessionModel;
	import net.play5d.game.bvn.events.SetBtnEvent;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.ctrler.FighterAICtrl;
	import net.play5d.game.bvn.fighter.ctrler.FighterKeyCtrl;
	/**
	 * 暂停界面
	 */
	public class PauseDialog extends Sprite {
		
		private var _bg:Sprite;
		private var _btnGroup:SetBtnGroup;
		
		private var _moveList:MoveListSp;
		private var _p1AI:Boolean = false;
		private var _p2AI:Boolean = false;
		
		public function PauseDialog() {
			_bg = new Sprite();
			_bg.graphics.beginFill(0, 0.5);
			_bg.graphics.drawRect(0, 0, GameConfig.GAME_SIZE.x, GameConfig.GAME_SIZE.y);
			_bg.graphics.endFill();
			
			addChild(_bg);
			
			_btnGroup = new SetBtnGroup();
			_btnGroup.setBtnData([{
				label: "GAME TITLE",
				cn   : "返回标题"
			}, {
				label: "MOVE LIST",
				cn   : "出招表"
			}, {
				label: "RESTART GAME",
				cn   : "重开对局"
			},{
				label: "BACK SELECT",
				cn   : "返回选人"
			},{
				label: "AI CTRL",
				cn   : "开启AI"
			},{
				label: "CONTINUE",
				cn   : "继续游戏"
			}], 3);
			
			_btnGroup.addEventListener(SetBtnEvent.SELECT, btnGroupSelectHandler);
			addChild(_btnGroup);
		}
		
		public function destory():void {
			if (_btnGroup) {
				_btnGroup.removeEventListener(SetBtnEvent.SELECT, btnGroupSelectHandler);
				_btnGroup.destory();
				_btnGroup = null;
			}
			if (_moveList) {
				_moveList.destory();
				_moveList = null;
			}
		}
		
		public function isShowing():Boolean {
			return visible;
		}
		
		public function show():void {
			visible = true;
			
			_btnGroup.keyEnable = true;
			_btnGroup.setArrowIndex(3);
		}
		
		public function hide():void {
			visible = false;
			
			_btnGroup.keyEnable = false;
			GameUI.closeConfrim();
		}
		
		private function btnGroupSelectHandler(e:SetBtnEvent):void {
			if (GameUI.showingDialog()) {
				return;
			}
			
			switch (e.selectedLabel) {
				case "GAME TITLE":
					_btnGroup.keyEnable = false;
					GameUI.confirm("BACK TITLE?", "返回到主菜单？", function ():void {
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["back_title"])
						));
						if (GameCtrl.I.gameRunData.initArcadeLose != false) {
							GameCtrl.I.gameRunData.maxArcadeLose = -1;
							GameCtrl.I.gameRunData.clear();
						}
						MainGame.I.goMenu();
					}, function ():void {
						_btnGroup.keyEnable = true;
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["back_title_cancel"])
						));
					});
					break;
				case "MOVE LIST":
					showMoveList();
					MainGame.I.stage.dispatchEvent(new DataEvent(
						"5d_message",
						false,
						false,
						JSON.stringify(["move_list"])
					));
					break;
				case "RESTART GAME":
					_btnGroup.keyEnable = false;
					GameUI.confirm("RESTART GAME?", "重新开始对局？", function ():void {
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["restart_game"])
						));
						MainGame.I.loadGame();
					}, function ():void {
						_btnGroup.keyEnable = true;
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["restart_game_cancel"])
						));
					});	
					break;	
				case "BACK SELECT":
					_btnGroup.keyEnable = false;	
					GameUI.confirm("BACK SELECT?", "返回到选人？", function ():void {
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["back_select"])
						));
						MainGame.I.goSelect();
					}, function ():void {
						_btnGroup.keyEnable = true;
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["back_select_cancel"])
						));
					});	
					break;
				case "AI CTRL":
					_btnGroup.keyEnable = false;	
					var p1AiCnStr:String = _p1AI?"取消P1 AI控制器" : "设置P1 AI控制器";
					var p2AiCnStr:String = _p2AI?"取消P2 AI控制器" : "设置P2 AI控制器";
					GameUI.confirm("SET AI TEAM",p1AiCnStr+"\n"+p2AiCnStr, function ():void {
						if(!GameMode.isTraining()){
							GameUI.alert("notes","不支持在该模式下设置AI",function():void{_btnGroup.keyEnable = true});	
							return;	
						}	
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["set_p1_ai"])
						));
						if(!_p1AI)  {
							_p1AI = true; 
							setAICtrl(true); 
						}
						else {
							_p1AI = false;
							setPlayerCtrl(true); 
						}
						GameCtrl.I.resume(true);	
					}, function ():void {
						if(!GameMode.isTraining()){
							GameUI.alert("notes","不支持在该模式下设置AI",function():void{_btnGroup.keyEnable = true});	
							return;	
						}
						MainGame.I.stage.dispatchEvent(new DataEvent(
							"5d_message",
							false,
							false,
							JSON.stringify(["set_p2_ai"])
						));
						if(!_p2AI) {
							_p2AI = true;
							setAICtrl();
						}
						else {
							_p2AI = false;
							setPlayerCtrl();
						}
						GameCtrl.I.resume(true);	
					},"P1","P2","阵营","阵营");			
					break;	
				case "CONTINUE":
					GameCtrl.I.resume(true);
					break;	
			}
		}
		
		private function showMoveList():void {
			if (!_moveList) {
				_moveList = new MoveListSp();
				_moveList.onBackSelect = hideMoveList;
				addChild(_moveList);
			}
			_btnGroup.keyEnable = false;
			_moveList.show();
		}
		
		private function hideMoveList():void {
			_moveList.hide();
			
			_btnGroup.keyEnable = true;
			MainGame.I.stage.dispatchEvent(new DataEvent(
				"5d_message",
				false,
				false,
				JSON.stringify(["move_list_cancel"])
			));
		}

		public function setAICtrl(v:Boolean = false):void {
			var Fighter:FighterMain = (!v?GameCtrl.I.gameRunData.p2FighterGroup.currentFighter as FighterMain:GameCtrl.I.gameRunData.p1FighterGroup.currentFighter as FighterMain);
			var AiLevel:int = MessionModel.I.AI_LEVEL;
			var AiCtrl:FighterAICtrl = new FighterAICtrl();
			AiCtrl.AILevel = AiLevel;
			AiCtrl.fighter = Fighter;
			Fighter.setActionCtrl(AiCtrl);
			trace("PauseDialog.setAICtrl ::  "+Fighter.team.name+" Ai Ctrl Start..")
			//trace(this._p1AI);
		}
		
		public function setPlayerCtrl(v:Boolean = false):void {
			var Fighter:FighterMain = (!v?GameCtrl.I.gameRunData.p2FighterGroup.currentFighter as FighterMain:GameCtrl.I.gameRunData.p1FighterGroup.currentFighter as FighterMain);
			var key:FighterKeyCtrl = new FighterKeyCtrl();
			key.inputType = Fighter.team.name;
			key.classicMode = GameData.I.config.keyInputMode == 1;
			Fighter.setActionCtrl(key);
			trace("PauseDialog.setPlayerCtrl ::  "+Fighter.team.name+" Play Ctrl Start..")
		}
		
	}
}
