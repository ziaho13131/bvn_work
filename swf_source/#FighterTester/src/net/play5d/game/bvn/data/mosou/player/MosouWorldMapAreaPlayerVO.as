package net.play5d.game.bvn.data.mosou.player {
	import net.play5d.game.bvn.data.ISaveData;
	
	public class MosouWorldMapAreaPlayerVO implements ISaveData {
		
		
		public var id:String;
		
		public var name:String;
		
		private var _passedMissions:Vector.<MosouMissionPlayerVO>;
		
		public function MosouWorldMapAreaPlayerVO() {
			_passedMissions = new Vector.<MosouMissionPlayerVO>();
			super();
		}
		
		public function passMission(param1:String, param2:int = 1):Boolean {
			var _loc4_:Boolean = false;
			var _loc3_:MosouMissionPlayerVO = getPassedMission(param1);
			if (!_loc3_) {
				_loc4_ = true;
				_loc3_ = new MosouMissionPlayerVO();
				_loc3_.id = param1;
				_passedMissions.push(_loc3_);
			}
			_loc3_.stars = param2;
			return _loc4_;
		}
		
		public function getPassedMission(param1:String):MosouMissionPlayerVO {
			var _loc2_:int = 0;
			while (_loc2_ < _passedMissions.length) {
				if (_passedMissions[_loc2_].id == param1) {
					return _passedMissions[_loc2_];
				}
				_loc2_++;
			}
			return null;
		}
		
		public function getLastPassedMission():MosouMissionPlayerVO {
			if (_passedMissions.length < 1) {
				return null;
			}
			return _passedMissions[_passedMissions.length - 1];
		}
		
		public function getPassedMissionAmount():int {
			return _passedMissions.length;
		}
		
		public function toSaveObj():Object {
			var _loc2_:int = 0;
			var _loc1_:Object = {};
			_loc1_.id = id;
			_loc1_.name = name;
			_loc1_.missions = [];
			while (_loc2_ < _passedMissions.length) {
				_loc1_.missions.push(_passedMissions[_loc2_].toSaveObj());
				_loc2_++;
			}
			return _loc1_;
		}
		
		public function readSaveObj(param1:Object):void {
			var _loc3_:int = 0;
			var _loc2_:* = null;
			id = param1.id;
			name = param1.name;
			_passedMissions = new Vector.<MosouMissionPlayerVO>();
			if (param1.missions) {
				while (_loc3_ < param1.missions.length) {
					_loc2_ = new MosouMissionPlayerVO();
					_loc2_.readSaveObj(param1.missions[_loc3_]);
					_passedMissions.push(_loc2_);
					_loc3_++;
				}
			}
		}
	}
}
