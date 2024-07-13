package net.play5d.game.bvn.data.mosou.player {
	import net.play5d.game.bvn.ctrl.mosou_ctrls.MosouLogic;
	import net.play5d.game.bvn.data.ISaveData;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapAreaVO;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapVO;
	import net.play5d.game.bvn.data.mosou.utils.MosouFighterFactory;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.utils.WrapInteger;
	
	public class MosouPlayerData implements ISaveData {
		
		
		public var userId:String;
		
		public var userName:String;
		
		private var _money:WrapInteger;
		
		private var _mapData:Vector.<MosouWorldMapPlayerVO>;
		
		private var _fighterData:Vector.<MosouFighterVO>;
		
		private var _fighterTeam:Vector.<MosouFighterVO>;
		
		private var _lastLogin:WrapInteger;
		
		private var _currentMapId:String = "map1";
		
		private var _currentAreaId:String = "p1";
		
		public function MosouPlayerData() {
			_money = new WrapInteger(0);
			_mapData = new Vector.<MosouWorldMapPlayerVO>();
			_fighterData = new Vector.<MosouFighterVO>();
			_fighterTeam = new Vector.<MosouFighterVO>();
			_lastLogin = new WrapInteger(0);
			super();
		}
		
		public function init():void {
			initMap();
			_money.setValue(999999999);
			_fighterData.push(MosouFighterFactory.create("ichigo"));
			_fighterData.push(MosouFighterFactory.create("naruto"));
			_fighterData.push(MosouFighterFactory.create("sakura"));
			_fighterTeam = _fighterData.concat();
		}
		
		private function initMap():void {
			CONFIG::DEBUG {
				Trace("========== initMap ===================");
			}
			
			var _loc1_:MosouWorldMapPlayerVO = new MosouWorldMapPlayerVO();
			_loc1_.id = _currentMapId;
			_mapData.push(_loc1_);
			var _loc2_:MosouWorldMapVO = MosouModel.I.getMap(_loc1_.id);
			for each(var _loc3_:MosouWorldMapAreaVO in _loc2_.areas) {
				if (!_loc3_.preOpens || _loc3_.preOpens.length < 1) {
					MosouLogic.openMapArea(_loc1_.id, _loc3_.id);
				}
			}
		}
		
		public function getFighterData():Vector.<MosouFighterVO> {
			return _fighterData;
		}
		
		public function addFighter(param1:String):MosouFighterVO {
			var _loc2_:MosouFighterVO = getFighterDataById(param1);
			if (_loc2_) {
				return _loc2_;
			}
			_loc2_ = MosouFighterFactory.create(param1);
			_fighterData.push(_loc2_);
			return _loc2_;
		}
		
		public function getFighterTeam():Vector.<MosouFighterVO> {
			return _fighterTeam;
		}
		
		public function getFighterTeamIds():Array {
			var _loc2_:int = 0;
			var _loc1_:Array = [];
			while (_loc2_ < _fighterTeam.length) {
				_loc1_.push(_fighterTeam[_loc2_].id);
				_loc2_++;
			}
			return _loc1_;
		}
		
		public function setFighterTeam(param1:int, param2:String):void {
			var _loc3_:MosouFighterVO = getFighterDataById(param2);
			if (!_loc3_) {
				return;
			}
			_fighterTeam[param1] = _loc3_;
			GameEvent.dispatchEvent("MOSOU_FIGHTER_UPDATE");
		}
		
		public function setLeader(param1:MosouFighterVO):void {
			var _loc2_:int = _fighterTeam.indexOf(param1);
			if (_loc2_ == -1) {
				return;
			}
			if (_loc2_ == 0) {
				return;
			}
			var _loc3_:Vector.<MosouFighterVO> = _fighterTeam.concat();
			switch (int(_loc2_) - 1) {
				case 0:
					_fighterTeam[2] = _loc3_[0];
					_fighterTeam[1] = _loc3_[2];
					_fighterTeam[0] = _loc3_[1];
					break;
				case 1:
					_fighterTeam[2] = _loc3_[1];
					_fighterTeam[1] = _loc3_[0];
					_fighterTeam[0] = _loc3_[2];
			}
			GameEvent.dispatchEvent("MOSOU_FIGHTER_UPDATE");
		}
		
		public function getLeader():MosouFighterVO {
			return _fighterTeam[0];
		}
		
		public function getFighterDataById(param1:String):MosouFighterVO {
			for each(var _loc2_:MosouFighterVO in _fighterData) {
				if (_loc2_.id == param1) {
					return _loc2_;
				}
			}
			return null;
		}
		
		public function getCurrentMap():MosouWorldMapPlayerVO {
			return getMapById(_currentMapId);
		}
		
		public function getCurrentArea():MosouWorldMapAreaPlayerVO {
			var _loc1_:MosouWorldMapPlayerVO = getCurrentMap();
			if (!_loc1_) {
				return null;
			}
			return _loc1_.getOpenArea(_currentAreaId);
		}
		
		public function setCurrentArea(param1:String):void {
			_currentAreaId = param1;
		}
		
		public function getCurrentMapAreaById(param1:String):MosouWorldMapAreaPlayerVO {
			var _loc2_:MosouWorldMapPlayerVO = getCurrentMap();
			if (!_loc2_) {
				return null;
			}
			return _loc2_.getOpenArea(param1);
		}
		
		public function getMapById(param1:String):MosouWorldMapPlayerVO {
			for each(var _loc2_:MosouWorldMapPlayerVO in _mapData) {
				if (_loc2_.id == param1) {
					return _loc2_;
				}
			}
			return null;
		}
		
		public function getMoney():int {
			return _money.getValue();
		}
		
		/**
		 * 增加金钱
		 * @param delta 金钱变量
		 */
		public function addMoney(delta:int):void {
			var _loc2_:int = _money.getValue() + delta;
			_money.setValue(_loc2_);
			GameEvent.dispatchEvent("MONEY_UPDATE");
		}
		
		/**
		 * 减少金钱
		 * @param delta 金钱变量
		 */
		public function loseMoney(delta:int):void {
			var _loc2_:int = _money.getValue() - delta;
			if (_loc2_ < 0) {
				_loc2_ = 0;
			}
			_money.setValue(_loc2_);
			GameEvent.dispatchEvent("MONEY_UPDATE");
		}
		
		/**
		 * 增加角色经验
		 * @param delta 经验变量
		 */
		public function addFighterExp(delta:int):void {
			for (var i:int = 0; i < _fighterTeam.length; ++i) {
				var fighter:MosouFighterVO = _fighterTeam[i];
				// 判断是不是队长
				var rate:Number = i == 0
								  ? 1
								  : 0.7;
				fighter.addExp(delta * rate);
			}
		}
		
		public function login(param1:String = null, param2:String = null):void {
			this.userId = param1;
			this.userName = param2;
			var _loc3_:int = new Date().getTime();
			_lastLogin.setValue(_loc3_);
		}
		
		public function toSaveObj():Object {
			var _loc1_:* = null;
			var _loc3_:int = 0;
			var _loc2_:Object = {};
			_loc2_.userId = userId;
			_loc2_.userName = userName;
			_loc2_.money = _money.getValue();
			_loc2_.lastLogin = _lastLogin.getValue();
			_loc2_.mapData = [];
			_loc3_ = 0;
			while (_loc3_ < _mapData.length) {
				_loc1_ = _mapData[_loc3_].toSaveObj();
				_loc2_.mapData.push(_loc1_);
				_loc3_++;
			}
			_loc2_.fighterData = [];
			_loc3_ = 0;
			while (_loc3_ < _fighterData.length) {
				_loc1_ = _fighterData[_loc3_].toSaveObj();
				_loc2_.fighterData.push(_loc1_);
				_loc3_++;
			}
			_loc2_.currentMapId = _currentMapId;
			_loc2_.currentAreaId = _currentAreaId;
			_loc2_.fighterTeam = [];
			_loc3_ = 0;
			while (_loc3_ < _fighterTeam.length) {
				_loc2_.fighterTeam.push(_fighterTeam[_loc3_].id);
				_loc3_++;
			}
			return _loc2_;
		}
		
		public function readSaveObj(param1:Object):void {
			var _loc3_:* = null;
			var _loc6_:int = 0;
			var _loc5_:* = null;
			var _loc4_:* = null;
			var _loc2_:* = null;
			userId = param1.userId;
			userName = param1.userName;
			if (param1.money) {
				_money.setValue(param1.money);
			}
			if (param1.lastLogin) {
				_lastLogin.setValue(param1.lastLogin);
			}
			if (param1.mapData) {
				_mapData = new Vector.<MosouWorldMapPlayerVO>();
				_loc6_ = 0;
				while (_loc6_ < param1.mapData.length) {
					_loc3_ = param1.mapData[_loc6_];
					(_loc5_ = new MosouWorldMapPlayerVO()).readSaveObj(_loc3_);
					_mapData.push(_loc5_);
					_loc6_++;
				}
			}
			if (param1.fighterData) {
				_fighterData = new Vector.<MosouFighterVO>();
				_loc6_ = 0;
				while (_loc6_ < param1.fighterData.length) {
					_loc3_ = param1.fighterData[_loc6_];
					(_loc4_ = new MosouFighterVO()).readSaveObj(_loc3_);
					_fighterData.push(_loc4_);
					_loc6_++;
				}
			}
			if (param1.currentMapId) {
				_currentMapId = param1.currentMapId;
			}
			if (param1.currentAreaId) {
				_currentAreaId = param1.currentAreaId;
			}
			if (param1.fighterTeam) {
				_fighterTeam = new Vector.<MosouFighterVO>();
				_loc6_ = 0;
				while (_loc6_ < param1.fighterTeam.length) {
					_loc2_ = param1.fighterTeam[_loc6_];
					_loc4_ = getFighterDataById(_loc2_);
					if (_loc4_) {
						_fighterTeam.push(_loc4_);
					}
					_loc6_++;
				}
			}
		}
	}
}
