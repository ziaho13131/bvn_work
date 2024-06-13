/**
 * 已重建完成
 */
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import net.play5d.game.obvn.Debugger;
	import net.play5d.game.obvn.GameConfig;
	import net.play5d.game.obvn.GameQuality;
	import net.play5d.game.obvn.MainGame;
	import net.play5d.game.obvn.ctrl.GameLogic;
	import net.play5d.game.obvn.ctrl.StateCtrl;
	import net.play5d.game.obvn.ctrl.game_ctrls.GameCtrl;
	import net.play5d.game.obvn.ctrl.game_ctrls.TrainingCtrler;
	import net.play5d.game.obvn.data.GameData;
	import net.play5d.game.obvn.data.GameMode;
	import net.play5d.game.obvn.data.GameRunDataVO;
	import net.play5d.game.obvn.data.MapModel;
	import net.play5d.game.obvn.data.SelectVO;
	import net.play5d.game.obvn.fighter.FighterMain;
	import net.play5d.game.obvn.fighter.ctrler.FighterCtrler;
	import net.play5d.game.obvn.fighter.ctrler.FighterEffectCtrl;
	import net.play5d.game.obvn.fighter.ctrler.FighterVoice;
	import net.play5d.game.obvn.fighter.events.FighterEvent;
	import net.play5d.game.obvn.fighter.events.FighterEventDispatcher;
	import net.play5d.game.obvn.fighter.models.HitVO;
	import net.play5d.game.obvn.interfaces.GameInterface;
	import net.play5d.game.obvn.interfaces.GameInterfaceManager;
	import net.play5d.game.obvn.stage.LoadingStage;
	import net.play5d.kyo.display.ui.KyoSimpButton;
	
	[SWF(frameRate="30", backgroundColor="#000000", width="1000", height="600")]
	/**
	 * 游戏主类
	 */
	public class FighterTester extends Sprite {
		
		private var _mainGame:MainGame;
		private var _gameSprite:Sprite;
		private var _testUI:Sprite;
		
		private var _p1InputId:TextField;
		private var _p2InputId:TextField;
		private var _p1FzInputId:TextField;
		private var _p2FzInputId:TextField;
		private var _autoReceiveHp:TextField;
		private var _mapInputId:TextField;
		private var _fpsInput:TextField;
		private var _debugText:TextField;
		
		public function FighterTester() {
			if (stage) {
				initlize();
				return;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, initlize);
		}
		
		private function initlize(e:Event = null):void {
			Debugger.initDebug(stage);
			Debugger.onErrorMsgCall = onDebugLog;
			
			_gameSprite = new Sprite();
			_gameSprite.scrollRect = new Rectangle(0, 0, GameConfig.GAME_SIZE.x, GameConfig.GAME_SIZE.y);
			addChild(_gameSprite);
			
			GameInterface.instance = new GameInterfaceManager();
			
			GameData.I.config.keyInputMode = 1;
			GameData.I.config.quality = GameQuality.MEDIUM;
			GameData.I.config.fighterHP = 2;
			GameData.I.config.AI_level = 6;
			GameData.I.config.fightTime = -1;
			
			_mainGame = new MainGame(); 
			_mainGame.initlize(_gameSprite, stage, initBackHandler, initFailHandler);
			
			StateCtrl.I.transEnabled = false;
		}
		
		private function initBackHandler():void {
			buildTestUI();
		}
		
		private function initFailHandler(msg:String):void {}
		
		private function buildTestUI():void {
			_testUI = new Sprite();
			_testUI.x = 810;
			
			_testUI.graphics.beginFill(0x333333, 1);
			_testUI.graphics.drawRect(-10, 0, 200, 600);
			_testUI.graphics.endFill();
			
			addChild(_testUI);
			
			var yy:Number = 20;
			
			addLabel("Player 1", yy);
			yy += 40;
			
			addLabel("fighter_id", yy);
			_p1InputId = addInput("ichigo", yy, 80);
			yy += 40;
			
			addLabel("assistant_id", yy);
			_p1FzInputId = addInput("kon", yy, 80);
			yy += 80;
			
			addLabel("Player 2", yy);
			yy += 40;
			
			addLabel("fighter_id", yy);
			_p2InputId = addInput("naruto", yy, 80);
			yy += 40;
			
			addLabel("assistant_id", yy);
			_p2FzInputId = addInput("gaara", yy, 80);
			yy += 40;
			
			addLabel("map_id", yy);
			_mapInputId = addInput(MapModel.I.getAllMaps()[1].id, yy, 80);
			yy += 60;
			
			addLabel("Game FPS", yy);
			_fpsInput = addInput(GameConfig.FPS_GAME.toString(), yy, 80);
			yy += 40;
			
			addLabel("Recover", yy);
			_autoReceiveHp = addInput("1", yy, 80);
			yy += 60;
			
			_debugText = addLabel("Error Message Text", yy, 0);
			_debugText.width = 190;
			_debugText.height = 200;
			_debugText.textColor = 0xFF0000;
			_debugText.multiline = true;
			
			addButton("Start Test", 500, 25, 140, 35, testGame);
			addButton("Kill P2", 550, 25, 140, 35, killP2);
		}
		
		private function addLabel(txt:String, y:Number = 0, x:Number = 0):TextField {
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.color = 0xFFFFFF;
			
			var label:TextField = new TextField();
			label.defaultTextFormat = tf;
			label.text = txt;
			label.x = x;
			label.y = y;
			label.mouseEnabled = false;
			
			_testUI.addChild(label);
			return label;
		}
		
		private function addInput(txt:String, y:Number = 0, x:Number = 0):TextField {
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.color = 0;
			
			var label:TextField = new TextField();
			label.defaultTextFormat = tf;
			label.text = txt;
			label.x = x;
			label.y = y;
			label.width = 100;
			label.height = 20;
			label.backgroundColor = 0xFFFFFF;
			label.background = true;
			label.type = TextFieldType.INPUT;
			label.condenseWhite = true;
			
			_testUI.addChild(label);
			return label;
		}
		
		private function addButton(
			label:String,
			y:Number = 0, x:Number = 0,
			width:Number = 100, height:Number = 50,
			click:Function = null):Sprite 
		{
			var btn:KyoSimpButton = new KyoSimpButton(label, width, height);
			btn.x = x;
			btn.y = y;
			
			if (click != null) {
				btn.onClick(click);
			}
			
			_testUI.addChild(btn);
			return btn;
		}
		
		private function onDebugLog(msg:String):void {
			if (!_debugText) {
				return;
			}
			
			_debugText.text = msg;
		}
		
		private function changeFPS(...params):void {
			var fps:int = int(_fpsInput.text);
			
			GameConfig.setGameFps(fps);
			stage.frameRate = fps;
		}
		
		private function testGame(...params):void {
//			Debugger.errorMsg("");
			
			changeFPS();
			
			GameMode.currentMode = GameMode.TRAINING;
			TrainingCtrler.RECOVER_HP = _autoReceiveHp.text != "0";
			
			GameData.I.p1Select = new SelectVO();
			GameData.I.p2Select = new SelectVO();
			
			GameData.I.p1Select.fighter1 = _p1InputId.text;
			GameData.I.p2Select.fighter1 = _p2InputId.text;
			GameData.I.p1Select.fuzhu = _p1FzInputId.text;
			GameData.I.p2Select.fuzhu = _p2FzInputId.text;
			GameData.I.selectMap = _mapInputId.text;
			
			loadGame();
		}
		
		private static function loadGame():void {
			var ls:LoadingStage = new LoadingStage();
			MainGame.stageCtrl.goStage(ls);
		}
		
		private function killP2(...params):void {
			var rundata:GameRunDataVO = GameCtrl.I.gameRunData;
			if (!rundata) {
				Debugger.errorMsg("No game data!");
				return;
			}
			if (!GameCtrl.I.actionEnable) {
				Debugger.errorMsg("In system control!");
				return;
			}
			
			var p1:FighterMain = rundata.p1FighterGroup.currentFighter;
			var p2:FighterMain = rundata.p2FighterGroup.currentFighter;
			if (!p1 || !p2) {
				return;
			}
			if (GameMode.currentMode == GameMode.TRAINING) {
				Debugger.errorMsg("Current mode is TRAINING!");
				return;
			}
			if (!p1.isAlive || !p2.isAlive) {
				return;
			}
			
			var hv:HitVO = new HitVO();
			hv.owner = p1;
			
			var p2hp:Number = p2.hp;
			p2.hurtHit = hv;
			p2.loseHp(p2hp);
			
			var p2Ctrler:FighterCtrler = p2.getCtrler();
			p2Ctrler.getMcCtrl().idle();
			p2Ctrler.getMcCtrl().hurtFly(-5, 0);
			p2Ctrler.getVoiceCtrl().playVoice(FighterVoice.DIE);
			
			var p2EffectCtrl:FighterEffectCtrl = p2Ctrler.getEffectCtrl();
			p2EffectCtrl.endBisha();
			p2EffectCtrl.endGhostStep();
			p2EffectCtrl.endGlow();
//			p2EffectCtrl.endShadow();
//			p2EffectCtrl.endShake();
			
			if (GameLogic.checkFighterDie(p2)) {
				Debugger.errorMsg("LoseHp : " + p2hp);
				
				FighterEventDispatcher.dispatchEvent(p2, FighterEvent.DIE);
				p2.isAlive = false;
				
				trace("Kill P2 success!");
			}
		}
	}
}
