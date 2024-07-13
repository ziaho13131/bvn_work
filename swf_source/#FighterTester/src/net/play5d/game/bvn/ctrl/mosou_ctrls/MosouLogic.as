package net.play5d.game.bvn.ctrl.mosou_ctrls {
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.mosou.MosouEnemyVO;
	import net.play5d.game.bvn.data.mosou.MosouFighterSellVO;
	import net.play5d.game.bvn.data.mosou.MosouMissionVO;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapAreaVO;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapVO;
	import net.play5d.game.bvn.data.mosou.player.MosouMissionPlayerVO;
	import net.play5d.game.bvn.data.mosou.player.MosouPlayerData;
	import net.play5d.game.bvn.data.mosou.player.MosouWorldMapAreaPlayerVO;
	import net.play5d.game.bvn.data.mosou.player.MosouWorldMapPlayerVO;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.ui.GameUI;
	
	public class MosouLogic {
		
		private static var _i:MosouLogic;
		
		// hits 计数
		private var _hitNum:int;
		// 当前攻击的对象向量
		private var _hitTargets:Vector.<FighterMain> = new Vector.<FighterMain>();
		
		public static function get I():MosouLogic {
			if (!_i) {
				_i = new MosouLogic();
			}
			return _i;
		}
		
		/**
		 * 检查当前区域
		 * @param areaId 区域 id
		 * @return 返回是否相等
		 */
		public static function checkCurrentArea(areaId:String):Boolean {
			var md:MosouPlayerData = GameData.I.mosouData;
			if (md.getCurrentArea() == null) {
				return false;
			}
			
			return md.getCurrentArea().id == areaId;
		}
		
		/**
		 * 检查当前区域是否开放
		 * @param areaId 区域 id
		 * @return 当前区域是否开放
		 */
		public static function checkAreaIsOpen(areaId:String):Boolean {
			var md:MosouPlayerData = GameData.I.mosouData;
			var map:MosouWorldMapPlayerVO = md.getCurrentMap();
			
			return map.getOpenArea(areaId) != null;
		}
		
		/**
		 * 得到下一小关
		 * @param area2 世界区域对象
		 * @return 小关对象
		 */
		public static function getNextMission(area2:MosouWorldMapAreaVO):MosouMissionVO {
			var md:MosouPlayerData = GameData.I.mosouData;
			var map:MosouWorldMapPlayerVO = md.getCurrentMap();
			
			var area:MosouWorldMapAreaPlayerVO = map.getOpenArea(area2.id);
			if (area == null) {
				return null;
			}
			
			var m1:MosouMissionPlayerVO = area.getLastPassedMission();
			if (m1 == null) {
				return area2.missions[0];
			}
			
			var m2:MosouMissionVO = area2.getNextMission(m1.id);
			if (m2 != null) {
				return m2;
			}
			
			// 返回最后一小关
			return area2.missions[area2.missions.length - 1];
		}
		
		/**
		 * 得到当前区域通关百分比
		 * @param areaId 区域 id
		 * @return 当前区域通关百分比
		 */
		public static function getAreaPercent(areaId:String):Number {
			var md:MosouPlayerData = GameData.I.mosouData;
			var map:MosouWorldMapPlayerVO = md.getCurrentMap();
			
			var area:MosouWorldMapAreaPlayerVO = map.getOpenArea(areaId);
			if (area == null) {
				return 0;
			}
			
			var area2:MosouWorldMapAreaVO = MosouModel.I.getMapArea(map.id, area.id);
			if (area2 == null || area2.missions == null) {
				return 0;
			}
			
			return area.getPassedMissionAmount() / area2.missions.length;
		}
		
		/**
		 * 开放指定地图区域
		 * @param mapId 地图 id
		 * @param areaId 区域 id
		 */
		public static function openMapArea(mapId:String, areaId:String):void {
			CONFIG::DEBUG {
				Trace("openMapArea", areaId);
			}
			
			var md:MosouPlayerData = GameData.I.mosouData;
			var map:MosouWorldMapPlayerVO = md.getMapById(mapId);
			map.openArea(areaId)
		}
		
		/**
		 * 通关指定小关
		 * @param mission 小关对象
		 */
		public static function passMission(mission:MosouMissionVO):void {
			var md:MosouPlayerData = GameData.I.mosouData;
			var area:MosouWorldMapAreaPlayerVO = md.getCurrentArea();
			
			md.addMoney(area.passMission(mission.id)
						? 800
						: 100);
			
			updateMapAreas();
			GameData.I.saveData();
		}
		
		/**
		 * 更新地图区域
		 */
		public static function updateMapAreas():void {
			var md:MosouPlayerData = GameData.I.mosouData;
			
			var pmap:MosouWorldMapPlayerVO = md.getCurrentMap();
			var map:MosouWorldMapVO = MosouModel.I.getMap(pmap.id);
			
			for each(var i:MosouWorldMapAreaVO in map.areas) {
				if (i.preOpens && i.preOpens.length > 0) {
					var isOpenArea:Boolean = true;
					for each(var p:MosouWorldMapAreaVO in i.preOpens) {
						if (!canPassNextArea(p.id)) {
							isOpenArea = false;
							break;
						}
					}
					if (isOpenArea) {
						openMapArea(pmap.id, i.id);
					}
				}
			}
		}
		
		/**
		 * 能否开启下个探索区域
		 * @param areaId 区域 id
		 * @return
		 */
		private static function canPassNextArea(areaId:String):Boolean {
			return getAreaPercent(areaId) > 0.6;
		}
		
		/**
		 * 购买角色
		 */
		public function buyFighter(data:MosouFighterSellVO, succback:Function = null):void {
			var mosouData:MosouPlayerData = GameData.I.mosouData;
			if (mosouData.getMoney() < data.getPrice()) {
				GameUI.alert(
					GetLangText("game_ui.alert.musou_money_not_enough.title"),
					GetLangText("game_ui.alert.musou_money_not_enough.message_prefix") +
						data.getPrice() +
						GetLangText("game_ui.alert.musou_money_not_enough.message_suffix")
				);
				return;
			}
			GameUI.confrim(
				GetLangText("game_ui.confrim.musou_buy.title"),
				GetLangText("game_ui.confrim.musou_buy.message_prefix") +
					data.getPrice() +
					GetLangText("game_ui.confrim.musou_buy.message_suffix"),
				function ():void {
					mosouData.loseMoney(data.getPrice());
					mosouData.addFighter(data.id);
					GameData.I.saveData();
					if (succback != null) {
						succback();
					}
				}, null, true
			);
		}
		
		/**
		 * 初始化敌人属性
		 * @param fighter 敌人的 FighterMain 对象
		 */
		public static function initEnemyProps(fighter:FighterMain):void {
			var enemyData:MosouEnemyVO = fighter.mosouEnemyData;
			if (enemyData == null) {
				return;
			}
			
			var mv:MosouMissionVO = MosouModel.I.currentMission;
			if (mv == null) {
				return;
			}
			
			var lv:int = mv.enemyLevel;
			enemyData.level = lv;
			
			if (enemyData.isBoss) {
				if (enemyData.maxHp > 0) {
					fighter.hpMax = enemyData.maxHp;
				}
				else {
					fighter.hpMax = 1000 + lv * 400;
				}
				
				fighter.energy = fighter.energyMax = 80 + lv * 10;
				
				
				var atk:Number = lv * 13;
				var skl:Number = lv * 14;
				var bs:Number = lv * 15;
				fighter.initAttackAddDmg(atk, skl, bs);
			}
			else {
				if (enemyData.maxHp > 0) {
					fighter.hp = fighter.hpMax = enemyData.maxHp;
				}
				else {
					var hpRate:Number = 1 + (lv - 1) * 0.08;
					if (hpRate > 1) {
						fighter.hp = fighter.hpMax = fighter.hp * hpRate;
					}
				}
				atk = lv * 5;
				skl = lv * 10;
				bs = lv * 20;
				fighter.initAttackAddDmg(atk, skl, bs);
			}
		}
		
		/**
		 * 增加 hits 计数
		 * @param target 攻击目标
		 * @return 返回增加的计数
		 */
		public function addHits(target:FighterMain):int {
			if (_hitTargets.indexOf(target) == -1) {
				_hitTargets.push(target);
			}
			
			_hitNum++;
			if (_hitNum > 1 && GameUI.I.getUI()) {
				GameUI.I.getUI().showHits(_hitNum, 1);
			}
			return _hitNum;
		}
		
		/**
		 * 移除攻击目标
		 * @param target 目标
		 */
		public function removeHitTarget(target:FighterMain):void {
			var index:int = _hitTargets.indexOf(target);
			if (index == -1) {
				return;
			}
			
			_hitTargets.splice(index, 1);
			if (_hitTargets.length < 1) {
				_hitNum = 0;
				if (GameUI.I && GameUI.I.getUI()) {
					GameUI.I.getUI().hideHits(1);
				}
			}
		}
		
		/**
		 * 清空 hits 计数
		 */
		public function clearHits():void {
			_hitNum = 0;
			_hitTargets = new Vector.<FighterMain>();
		}
	}
}
