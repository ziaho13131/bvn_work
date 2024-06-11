/**
 * 已重建完成
 */
package net.play5d.game.bvn.ctrl.game_ctrls {
	import net.play5d.game.bvn.ctrl.EffectCtrl;
	import net.play5d.game.bvn.ctrl.GameLogic;
	import net.play5d.game.bvn.data.GameMode;
	import net.play5d.game.bvn.data.GameRunFighterGroup;
	import net.play5d.game.bvn.data.TeamVO;
	import net.play5d.game.bvn.fighter.Assister;
	import net.play5d.game.bvn.fighter.Bullet;
	import net.play5d.game.bvn.fighter.FighterAttacker;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.events.FighterEvent;
	import net.play5d.game.bvn.fighter.events.FighterEventDispatcher;
	import net.play5d.game.bvn.interfaces.BaseGameSprite;
	import net.play5d.game.bvn.interfaces.IGameSprite;
	
	/**
	 * 角色事件控制
	 */
	public class FighterEventCtrl {
		
		private var _attackers:Array = [];					// 攻击对象集合
		
		/**
		 * 初始化
		 */
		public function initlize():void {
			FighterEventDispatcher.removeAllListeners();
			FighterEventDispatcher.addEventListener(FighterEvent.FIRE_BULLET, fireBullet);
			FighterEventDispatcher.addEventListener(FighterEvent.ADD_ATTACKER, addAttacker);
			FighterEventDispatcher.addEventListener(FighterEvent.ADD_ASSISTER, addAssister);
			FighterEventDispatcher.addEventListener(FighterEvent.HIT_TARGET, onHitTarget);
			FighterEventDispatcher.addEventListener(FighterEvent.HURT_RESUME, onHurtResume);
			FighterEventDispatcher.addEventListener(FighterEvent.HURT_DOWN, onHurtDown);
			FighterEventDispatcher.addEventListener(FighterEvent.DIE, onDie);
		}
		
		public static function destory():void {
			FighterEventDispatcher.removeAllListeners();
		}
		
		/**
		 * 发射飞行道具
		 */
		private static function fireBullet(event:FighterEvent):void {
			var params:Object = event.params;
			if (!params || !params.mc) {
				return;
			}
			
			var bullet:Bullet = new Bullet(params.mc, params);
			bullet.onRemove = removeBullet;
			bullet.setHitVO(params.hitVO);
			
			GameCtrl.I.addGameSprite(event.fighter.team.id, bullet);
		}
		
		/**
		 * 移除飞行道具
		 */
		private static function removeBullet(bullet:Bullet):void {
			GameCtrl.I.removeGameSprite(bullet);
		}
		
		/**
		 * 增加独立道具
		 */
		private function addAttacker(event:FighterEvent):void {
			var params:Object = event.params;
			if (!params || !params.mc) {
				return;
			}
			
			var attacker:FighterAttacker = new FighterAttacker(params.mc, params);
			attacker.onRemove = removeAttacker;
			attacker.setOwner(event.fighter);
			attacker.init();
			_attackers.push(attacker);
			
			GameCtrl.I.addGameSprite(event.fighter.team.id, attacker);
		}
		
		/**
		 * 增加辅助
		 */
		private static function addAssister(event:FighterEvent):void {
			var fighter:FighterMain = event.fighter as FighterMain;
			var group:GameRunFighterGroup = 
				fighter.team.id == 1
				? GameCtrl.I.gameRunData.p1FighterGroup
				: GameCtrl.I.gameRunData.p2FighterGroup;
			var fz:Assister = group.fuzhu;
			fz.setOwner(fighter);
			fz.direct = fighter.direct;
			fz.x = fighter.x - 30 * fz.direct;
			fz.y = fighter.y;
			fz.onRemove = removeAssister;
			
			GameCtrl.I.addGameSprite(event.fighter.team.id, fz);
			EffectCtrl.I.assisterEffect(fz);
			
			fz.goFight();
		}
		
		/**
		 * 移除辅助
		 */
		private static function removeAssister(assister:Assister):void {
			GameCtrl.I.removeGameSprite(assister);
		}
		
		/**
		 * 移除独立道具
		 */
		private function removeAttacker(attacker:FighterAttacker):void {
			GameCtrl.I.removeGameSprite(attacker);
			
			var id:int = _attackers.indexOf(attacker);
			if (id != -1) {
				_attackers.splice(id, 1);
			}
		}
		
		/**
		 * 得到 FighterAttacker
		 * @param name 名称
		 * @param team 队伍 id
		 */
		public function getAttacker(name:String, team:int):FighterAttacker {
			for each(var i:FighterAttacker in _attackers) {
				if (i.name == name && i.team.id == team) {
					return i;
				}
			}
			return null;
		}
		
		private static function onHitTarget(e:FighterEvent):void {
			addHits(e.fighter as FighterMain, e.params.target);
			
			if (GameMode.isAcrade() && e.fighter.team.id == 1) {
				GameLogic.addScoreByHitTarget(e.params.hitvo);
			}
		}
		
		private static function onHurtResume(e:FighterEvent):void {
			removeHits(e.fighter.id);
		}
		
		private static function onHurtDown(e:FighterEvent):void {
			removeHits(e.fighter.id);
		}
		
		private static function addHits(fighter:FighterMain, target:IGameSprite):void {
			var targetId:String = null;
			if (target && target is BaseGameSprite) {
				targetId = (target as BaseGameSprite).id;
			}
			var uiId:int = fighter.team.id;
			var hits:int = GameLogic.addHits(fighter.id, targetId, uiId);
			if (hits > 1) {
				GameCtrl.I.gameState.gameUI.getUI().showHits(hits, uiId);
			}
		}
		
		private static function removeHits(targetId:String):void {
			var o:Object = GameLogic.getHitsObjByTargetId(targetId);
			if (o) {
				GameCtrl.I.gameState.gameUI.getUI().hideHits(o.uiID);
			}
			
			GameLogic.clearHitsByTargetId(targetId);
		}
		
		private static function onDie(e:FighterEvent):void {
			var winner:FighterMain = null;
			var loser:FighterMain = e.fighter as FighterMain;
			
			var team:TeamVO = GameCtrl.I.getEnemyTeam(e.fighter);
			if (team) {
				for each(var i:IGameSprite in team.children) {
					if (i is FighterMain) {
						winner = i as FighterMain;
						break;
					}
				}
			}
			
			GameCtrl.I.gameEnd(winner, loser);
		}
	}
}
