/**
 * 已重建完成
 */
package net.play5d.game.bvn.data {
	import net.play5d.game.bvn.Debugger;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.data.mosou.MosouFighterModel;
	import net.play5d.game.bvn.data.mosou.MosouFighterSellVO;
	import net.play5d.game.bvn.data.mosou.MosouMissionVO;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapAreaVO;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapVO;
	import net.play5d.game.bvn.data.mosou.player.MosouPlayerData;
	import net.play5d.game.bvn.interfaces.GameInterface;
	
	/**
	 * 游戏数据
	 */
	public class GameData {
		
		private static var _i:GameData;
		
		public var config:ConfigVO = new ConfigVO();
		public var p1Select:SelectVO;
		public var p2Select:SelectVO;
		public var selectMap:String;
		public var score:int = 0;
		public var winnerId:String;
				
		private const SAVE_ID:String = "bvn3.01";
		
		public static function get I():GameData {
			_i ||= new GameData();
			
			return _i;
		}
		
		private static function validateMusouData() : void
		{
			var _loc2_:MosouWorldMapVO = null;
			var _loc12_:String = null;
			var _loc14_:MapVO = null;
			var _loc6_:Array = null;
			var _loc10_:FighterVO = null;
			var _loc15_:FighterVO = null;
			var _loc7_:String = null;
			var _loc3_:Object = MosouModel.I.getAllMap();
			for(var _loc11_:* in _loc3_)
			{
				_loc2_ = _loc3_[_loc11_] as MosouWorldMapVO;
				for each(var _loc1_:* in _loc2_.areas)
				{
					for each(var _loc4_:* in _loc1_.missions)
					{
						_loc12_ = _loc2_.id + " - " + _loc1_.id + " - " + _loc4_.id;
						if((_loc14_ = MapModel.I.getMap(_loc4_.map)) == null)
						{
							throw new Error("musou[" + _loc12_ + "]验证失败！未找到map: " + _loc4_.map);
						}
						_loc6_ = _loc4_.getAllEnemieIds();
						for each(var _loc13_:* in _loc6_)
						{
							if((_loc10_ = FighterModel.I.getFighter(_loc13_)) == null)
							{
								throw new Error("musou[" + _loc12_ + "]验证失败！未找到fighter: " + _loc13_);
							}
						}
					}
				}
			}
			var _loc9_:Array = [];
			var _loc8_:Vector.<MosouFighterSellVO> = MosouFighterModel.I.fighters;
			for each(var _loc5_:* in _loc8_)
			{
				if(!(_loc15_ = FighterModel.I.getFighter(_loc5_.id)) && _loc9_.indexOf(_loc5_.id) == -1)
				{
					_loc9_.push(_loc5_.id);
				}
			}
			if(_loc9_.length > 0)
			{
				_loc7_ = "";
				if(_loc9_.length > 0)
				{
					_loc7_ += "fighter:" + _loc9_.join(" , ") + " ; ";
				}
				throw new Error("FighterModel 验证失败！ [" + _loc7_ + "]");
			}
		}
		
		public function loadConfig(back:Function, fail:Function = null):void {
			AssetManager.I.loadXML("assets/config/fighter.xml", loadFighterBack, loadFighterFail);
			
			function loadFighterBack(data:XML):void {
				FighterModel.I.initByXML(data);
				AssetManager.I.loadXML("assets/config/assistant.xml", loadAssetsBack, loadAssisterFail);
			}
			function loadAssetsBack(data:XML):void {
				AssisterModel.I.initByXML(data);
				AssetManager.I.loadXML("assets/config/select.xml", loadSelectBack, loadSelectFail);
			}
			function loadSelectBack(data:XML):void {
				config.select_config.setByXML(data);
				AssetManager.I.loadXML("assets/config/map.xml", loadMapBack, loadMapFail);
			}
			function loadMapBack(data:XML):void {
				MapModel.I.initByXML(data);
				AssetManager.I.loadXML("assets/config/mission.xml", loadMessionBack, loadMessionFail);
			}
			function loadMessionBack(data:String):void {
				MessionModel.I.initByXML(new XML(data));
				back();
			}
			
			var loadMosouDataBack:* = function():void
			{
				MosouFighterModel.I.init();
				validateSelect();
				validateMissionData();
				validateMusouData();
				if(back != null)
				{
					back();
				}
			};
			
			function loadFighterFail():void {
				Debugger.log("Error reading fighter data!");
				if (fail != null) {
					fail("Error reading fighter data!");
				}
			}
			function loadAssisterFail():void {
				Debugger.log("Error reading assistant data!");
				if (fail != null) {
					fail("Error reading assistant data!");
				}
			}
			function loadSelectFail():void {
				Debugger.log("Error reading select stage data!");
				if (fail != null) {
					fail("Error reading select stage data!");
				}
			}
			function loadMapFail():void {
				Debugger.log("Error reading map data!");
				if (fail != null) {
					fail("Error reading map data!");
				}
			}
			function loadMessionFail():void {
				Debugger.log("Error reading mession data!");
				if (fail != null) {
					fail("Error reading map data!");
				}
			}
		}
		
		public function saveData():void {
			var o:Object = {};
			
			o.id = SAVE_ID;
			o.config = config.toSaveObj();
			
			GameInterface.instance.saveGame(o);
		}
		
		public function loadData():void {
			var o:Object = GameInterface.instance.loadGame();
			
			if (!o || o.id != SAVE_ID) {
				return;
			}
			
			config.readSaveObj(o.config);
		}
		
		private function validateSelect() : void
		{
			var _loc1_:* = null;
			_loc1_ = null;
			var _loc2_:* = null;
			var _loc5_:Array = [];
			var _loc3_:Array = [];
			for each(var _loc6_:* in config.select_config.charList.list)
			{
				for each(var _loc4_:* in _loc6_.getAllFighterIDs())
				{
					if((_loc1_ = FighterModel.I.getFighter(_loc4_)) == null)
					{
						if(_loc5_.indexOf(_loc4_) == -1)
						{
							_loc5_.push(_loc4_);
						}
					}
				}
			}
			for each(_loc6_ in config.select_config.assistList.list)
			{
				for each(_loc4_ in _loc6_.getAllFighterIDs())
				{
					if((_loc1_ = AssisterModel.I.getAssister(_loc4_)) == null)
					{
						if(_loc3_.indexOf(_loc4_) == -1)
						{
							_loc3_.push(_loc4_);
						}
					}
				}
			}
			if(_loc5_.length > 0 || _loc3_.length > 0)
			{
				_loc2_ = "";
				if(_loc5_.length > 0)
				{
					_loc2_ += "fighter:" + _loc5_.join(" , ") + " ; ";
				}
				if(_loc3_.length > 0)
				{
					_loc2_ += "assister:" + _loc3_.join(" , ") + " ; ";
				}
				throw new Error("select.xml验证失败！ [" + _loc2_ + "]");
			}
		}
		
		private function validateMissionData() : void
		{
			var _loc11_:* = undefined;
			var _loc7_:* = null;
			var _loc2_:* = null;
			var _loc3_:* = null;
			var _loc5_:* = null;
			var _loc6_:Array = [];
			var _loc1_:Array = [];
			var _loc9_:Array = [];
			var _loc4_:Array = MessionModel.I.getAllMissions();
			for each(var _loc8_:* in _loc4_)
			{
				_loc11_ = _loc8_.stageList;
				for each(var _loc12_:* in _loc11_)
				{
					for each(var _loc10_:* in _loc12_.fighters)
					{
						if((_loc7_ = FighterModel.I.getFighter(_loc10_)) == null)
						{
							if(_loc6_.indexOf(_loc10_) == -1)
							{
								_loc6_.push(_loc10_);
							}
						}
					}
					if((_loc2_ = MapModel.I.getMap(_loc12_.map)) == null)
					{
						if(_loc1_.indexOf(_loc12_.map) == -1)
						{
							_loc1_.push(_loc12_.map);
						}
					}
					if((_loc3_ = AssisterModel.I.getAssister(_loc12_.assister)) == null)
					{
						if(_loc9_.indexOf(_loc12_.assister) == -1)
						{
							_loc9_.push(_loc12_.assister);
						}
					}
				}
			}
			if(_loc6_.length > 0 || _loc9_.length > 0 || _loc1_.length > 0)
			{
				_loc5_ = "";
				if(_loc6_.length > 0)
				{
					_loc5_ += "fighter:" + _loc6_.join(" , ") + " ; ";
				}
				if(_loc9_.length > 0)
				{
					_loc5_ += "assister:" + _loc9_.join(" , ") + " ; ";
				}
				if(_loc1_.length > 0)
				{
					_loc5_ += "map:" + _loc1_.join(" , ") + " ; ";
				}
				throw new Error("mission.xml验证失败！ [" + _loc5_ + "]");
			}
		}
		
//		public function loadSelect(url:String):void {
//			AssetManager.I.loadXML(url, function (data:XML):void {
//				setSelectData(data);
//			}, function ():void {
//				trace("GameData.loadSelect :: Error!");
//			});
//		}
		
//		public function setSelectData(xml:XML):void {
//			config.select_config.setByXML(xml);
//		}
	}
}
