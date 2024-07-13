package net.play5d.game.bvn.stage {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.ctrl.GameRender;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.ctrl.StateCtrl;
	import net.play5d.game.bvn.ctrl.mosou_ctrls.MosouLogic;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapAreaVO;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapVO;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.ui.bigmap.BigmapClould;
	import net.play5d.game.bvn.ui.bigmap.WorldMapPointUI;
	import net.play5d.game.bvn.ui.dialog.DialogManager;
	import net.play5d.game.bvn.utils.BtnUtils;
	import net.play5d.game.bvn.utils.ResUtils;
	import net.play5d.game.bvn.utils.TouchMoveEvent;
	import net.play5d.game.bvn.utils.TouchUtils;
	import net.play5d.kyo.stage.IStage;
	
	public class WorldMapStage implements IStage {
		
		
		private var _ui:Sprite;
		
		private var _mapUI:Sprite;
		
		private var _viewMc:Sprite;
		
		private var _pointMc:Sprite;
		
		private var _maskMc:Sprite;
		
		private var _bgMc:Sprite;
		
		private var _pointUIs:Vector.<WorldMapPointUI>;
		
		private var _downUIPos:Point;
		
		private var _downMousePos:Point;
		
		private var _scale:Number = 1;
		
		private var _position:Point;
		
		private var _currentPoint:WorldMapPointUI;
		
		private var _cloudUI:BigmapClould;
		
		private var _backBtn:DisplayObject;
		
		public function WorldMapStage() {
			_downUIPos = new Point();
			_downMousePos = new Point();
			_position = new Point();
			super();
		}
		
		public function get display():DisplayObject {
			return _ui;
		}
		
		public function build():void {
			_ui = new Sprite();
			
			var mapClass:Class = ResUtils.I.createDisplayObject(ResUtils.bigmap, ResUtils.BIGMAP);
			_mapUI = new mapClass() as MovieClip;
			
			//			_mapUI = ResUtils.I.createDisplayObject(ResUtils.I.bigMap,ResUtils.BIG_MAP);
			_ui.addChild(_mapUI);
			_viewMc = _mapUI.getChildByName("view_mc") as Sprite;
			_pointMc = _mapUI.getChildByName("point_mc") as Sprite;
			_maskMc = _mapUI.getChildByName("mask_mc") as Sprite;
			_bgMc = _mapUI.getChildByName("bg_mc") as Sprite;
			_backBtn = AssetManager.I.createObject("backbtn_btn", AssetManager.I.dialoguiSwfPath) as DisplayObject;
			if (_backBtn) {
				_backBtn.y = 10;
				_backBtn.x = 10;
				BtnUtils.initBtn(_backBtn, backHandler);
				_ui.addChild(_backBtn);
			}
			_viewMc.mask = _maskMc;
			_viewMc.cacheAsBitmap = true;
			_maskMc.cacheAsBitmap = true;
			MosouLogic.updateMapAreas();
			initPointUIs();
			_cloudUI = new BigmapClould(_mapUI.getBounds(_mapUI));
			_ui.addChild(_cloudUI);
			_cloudUI.init();
			StateCtrl.I.transOut();
			GameEvent.addEventListener("MOSOU_FIGHTER_UPDATE", updatePointsUI);
			GameRender.add(render, this);
			SoundCtrl.I.BGM(AssetManager.I.getSound("back"));
		}
		
		private function render():void {
			_cloudUI.render();
		}
		
		private function updatePointsUI(param1:GameEvent = null):void {
			for each(var _loc2_:WorldMapPointUI in _pointUIs) {
				_loc2_.update();
			}
		}
		
		private function initPointUIs():void {
			var _loc3_:* = null;
			var _loc8_:int = 0;
			var _loc1_:* = null;
			var _loc5_:Object = {};
			var _loc7_:Object = {};
			_loc8_ = 0;
			while (_loc8_ < _pointMc.numChildren) {
				_loc3_ = _pointMc.getChildAt(_loc8_);
				if (_loc3_ != null) {
					_loc5_[_loc3_.name] = _loc3_;
					_loc3_.visible = false;
				}
				_loc8_++;
			}
			_loc8_ = 0;
			while (_loc8_ < _maskMc.numChildren) {
				_loc3_ = _maskMc.getChildAt(_loc8_);
				if (_loc3_ != null) {
					_loc7_[_loc3_.name] = _loc3_;
					_loc3_.visible = false;
				}
				_loc8_++;
			}
			_pointUIs = new Vector.<WorldMapPointUI>();
			var _loc4_:MosouWorldMapVO;
			var _loc2_:Vector.<MosouWorldMapAreaVO> = (_loc4_ = MosouModel.I.getMap(GameData.I.mosouData.getCurrentMap().id)).areas;
			for each(var _loc6_:MosouWorldMapAreaVO in _loc2_) {
				if (_loc5_[_loc6_.id]) {
					_loc1_ = new WorldMapPointUI(_loc5_[_loc6_.id], _loc7_[_loc6_.id], _loc6_);
					_loc1_.addEventListener("EVENT_SELECT", onSelectPoint);
					_pointUIs.push(_loc1_);
				}
			}
		}
		
		private function onSelectPoint(param1:Event):void {
			var _loc2_:WorldMapPointUI = param1.currentTarget as WorldMapPointUI;
			var _loc3_:MosouWorldMapAreaVO = _loc2_.data;
			if (_loc3_.building()) {
				GameUI.alert(
					GetLangText("game_ui.alert.musou_not_open.title"),
					GetLangText("game_ui.alert.musou_not_open.message")
				);
				return;
			}
			GameEvent.dispatchEvent("MOSOU_MAP");
			if (MosouLogic.checkCurrentArea(_loc3_.id)) {
				gotoMission(_loc3_);
			}
			else {
				GameData.I.mosouData.setCurrentArea(_loc3_.id);
				updatePointsUI();
			}
		}
		
		private function gotoMission(data:MosouWorldMapAreaVO):void {
			var allFinish:Boolean = MosouLogic.getAreaPercent(data.id) >= 1;
			
			if (allFinish) {
				var missionNum:int = data.missions.length;
				if (GameUI.showingBranch()) {
					GameUI.cancelBranch();
				}
				else {
					GameUI.branch(
						GetLangText("game_ui.confrim.musou_confrim.title"),
						GetLangText("game_ui.confrim.musou_confrim.message_all_finish_yes"),
						function (selectNum:int):void {
							CONFIG::DEBUG {
								Trace("选择回调：" + selectNum);
							}
							MosouModel.I.currentMission = data.missions[selectNum - 1];
							StateCtrl.I.transIn(MainGame.I.loadGame, true);
						},
						null,
						missionNum
					);
				}
				
				return;
			}
			
			GameUI.confrim(
				GetLangText("game_ui.confrim.musou_confrim.title"),
				GetLangText("game_ui.confrim.musou_confrim.message_all_finish_no"),
				function ():void {
					MosouModel.I.currentMission = MosouLogic.getNextMission(data);
					StateCtrl.I.transIn(MainGame.I.loadGame, true);
				},
				null,
				true
			);
		}
		
		private function focusCurrentPoint():void {
			for each(var _loc3_:WorldMapPointUI in _pointUIs) {
				if (MosouLogic.checkCurrentArea(_loc3_.data.id)) {
					var _loc2_:WorldMapPointUI = _loc3_;
					break;
				}
			}
			if (!_loc2_) {
				return;
			}
			_currentPoint = _loc2_;
			var _loc1_:Point = new Point(GameConfig.GAME_SIZE.x * 0.5, GameConfig.GAME_SIZE.y * 0.5);
			_scale = 1.2;
			_position.x = _loc1_.x - _loc2_.getPosition().x * _scale;
			_position.y = _loc1_.y - _loc2_.getPosition().y * _scale;
			renderPosAndSize();
		}
		
		public function afterBuild():void {
			initDrag();
			focusCurrentPoint();
		}
		
		private function initDrag():void {
			if (GameConfig.TOUCH_MODE) {
				TouchUtils.I.listenOneFinger(MainGame.I.stage, touchMoveHandler);
				TouchUtils.I.listenTwoFinger(MainGame.I.stage, touchZoomHandler);
			}
			else {
				MainGame.I.stage.addEventListener("mouseDown", mouseHandler);
				MainGame.I.stage.addEventListener("mouseUp", mouseHandler);
				MainGame.I.stage.addEventListener("mouseWheel", mouseHandler);
			}
		}
		
		private function touchMoveHandler(param1:TouchMoveEvent):void {
			if (param1.type == "EVENT_TOUCH_MOVE") {
				_position.x += param1.deltaX;
				_position.y += param1.deltaY;
				renderPosAndSize();
			}
		}
		
		private function touchZoomHandler(param1:TouchMoveEvent):void {
			if (param1.type == "EVENT_TOUCH_MOVE") {
				_scale += param1.delta;
				renderPosAndSize(true);
			}
		}
		
		private function mouseHandler(param1:MouseEvent):void {
			if (DialogManager.showingDialog()) {
				return;
			}
			switch (param1.type) {
				case "mouseDown":
					_downUIPos.x = _position.x;
					_downUIPos.y = _position.y;
					_downMousePos.x = MainGame.I.stage.mouseX;
					_downMousePos.y = MainGame.I.stage.mouseY;
					
					GameRender.remove(renderDrag, this);
					GameRender.add(renderDrag, this);
					break;
				case "mouseUp":
					GameRender.remove(renderDrag, this);
					break;
				case "mouseWheel":
					if (param1.delta < 0) {
						_scale -= 0.1;
					}
					else {
						_scale += 0.1;
					}
					renderPosAndSize(true);
			}
		}
		
		private function renderDrag():void {
			_position.x = MainGame.I.stage.mouseX - _downMousePos.x + _downUIPos.x;
			_position.y = MainGame.I.stage.mouseY - _downMousePos.y + _downUIPos.y;
			renderPosAndSize();
		}
		
		private function renderPosAndSize(param1:Boolean = false):void {
			var _loc3_:Number = NaN;
			if (_scale < 1) {
				_scale = 1;
			}
			if (_scale > 2) {
				_scale = 2;
			}
			if (param1 && _currentPoint) {
				_loc3_ = _mapUI.scaleX - _scale;
				if (_loc3_ != 0) {
					_position.x += _currentPoint.getPosition().x * _loc3_;
					_position.y += _currentPoint.getPosition().y * _loc3_;
				}
			}
			var _loc4_:Number = GameConfig.GAME_SIZE.x - _bgMc.width * _scale;
			var _loc2_:Number = GameConfig.GAME_SIZE.y - _bgMc.height * _scale;
			if (_position.x > 0) {
				_position.x = 0;
			}
			if (_position.y > 0) {
				_position.y = 0;
			}
			if (_position.x < _loc4_) {
				_position.x = _loc4_;
			}
			if (_position.y < _loc2_) {
				_position.y = _loc2_;
			}
			_mapUI.scaleX = _mapUI.scaleY = _scale;
			_mapUI.x = _position.x;
			_mapUI.y = _position.y;
			_cloudUI.scaleX = _cloudUI.scaleY = _scale * 0.8;
			_cloudUI.x = _position.x * 0.8;
			_cloudUI.y = _position.y * 0.8;
		}
		
		private function backHandler(...rest):void {
			GameUI.confrim(
				GetLangText("game_ui.confrim.back_title.title"),
				GetLangText("game_ui.confrim.back_title.message"),
				MainGame.I.goMenu,
				null,
				true
			);
		}
		
		public function destory(param1:Function = null):void {
			GameRender.remove(render, this);
			TouchUtils.I.unlistenOneFinger(MainGame.I.stage);
			TouchUtils.I.unlistenTwoFinger(MainGame.I.stage);
			MainGame.I.stage.removeEventListener("mouseDown", mouseHandler);
			MainGame.I.stage.removeEventListener("mouseUp", mouseHandler);
			MainGame.I.stage.removeEventListener("mouseWheel", mouseHandler);
			GameEvent.removeEventListener("MOSOU_FIGHTER_UPDATE", updatePointsUI);
			if (_backBtn) {
				BtnUtils.destoryBtn(_backBtn);
				_backBtn = null;
			}
			if (_cloudUI) {
				_cloudUI.destory();
				_cloudUI = null;
			}
			if (_pointUIs) {
				for each(var _loc2_:WorldMapPointUI in _pointUIs) {
					_loc2_.destory();
				}
				_pointUIs = null;
			}
			if (_mapUI) {
				try {
					_ui.removeChild(_mapUI);
				}
				catch (e:Error) {
				}
				_mapUI = null;
			}
		}
	}
}
