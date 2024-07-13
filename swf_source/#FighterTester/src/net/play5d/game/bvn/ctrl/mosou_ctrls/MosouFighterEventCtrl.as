package net.play5d.game.bvn.ctrl.mosou_ctrls {
	import net.play5d.game.bvn.ctrl.EffectCtrl;
	import net.play5d.game.bvn.ctrl.game_ctrls.BaseFighterEventCtrl;
	import net.play5d.game.bvn.ctrl.game_ctrls.GameCtrl;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.GameRunFighterGroup;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.events.FighterEvent;
	import net.play5d.game.bvn.fighter.events.FighterEventDispatcher;
	import net.play5d.game.bvn.interfaces.IGameSprite;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.ui.mosou.MosouUI;
	
	public class MosouFighterEventCtrl extends BaseFighterEventCtrl {
		
		
		public function MosouFighterEventCtrl() {
			super();
		}
		
		override public function initialize():void {
			super.initialize();
			FighterEventDispatcher.addEventListener("HIT_TARGET", onHitTarget);
			FighterEventDispatcher.addEventListener("BIRTH", onEnemyEvent);
			FighterEventDispatcher.addEventListener("HURT", onEnemyEvent);
			FighterEventDispatcher.addEventListener("DEFENSE", onEnemyEvent);
			FighterEventDispatcher.addEventListener("IDLE", onEnemyEvent);
			FighterEventDispatcher.addEventListener("HURT_RESUME", onEnemyEvent);
			FighterEventDispatcher.addEventListener("HURT_DOWN", onEnemyEvent);
			FighterEventDispatcher.addEventListener("DO_SPECIAL", changeFighter);
			FighterEventDispatcher.addEventListener("DIE", onDie);
			FighterEventDispatcher.addEventListener("DEAD", onDead);
		}
		
		private function onEnemyEvent(e:FighterEvent):void {
			var fighter:FighterMain = e.fighter as FighterMain;
			if (fighter == null || fighter.mosouEnemyData == null) {
				return;
			}
			
			switch (e.type) {
				case FighterEvent.BIRTH:
					onEnemyBirth(fighter);
					break;
				case FighterEvent.HURT:
				case FighterEvent.DEFENSE:
					onEnemyBeHit(fighter);
					break;
				case FighterEvent.IDLE:
				case FighterEvent.HURT_RESUME:
				case FighterEvent.HURT_DOWN:
					MosouLogic.I.removeHitTarget(fighter);
			}
		}
		
		private function onHitTarget(param1:FighterEvent):void {
			addHits(param1.fighter as FighterMain, param1.params.target);
		}
		
		private function onEnemyBeHit(param1:FighterMain):void {
			GameCtrl.I.getMosouCtrl().updateEnemy(param1);
		}
		
		private function onEnemyBirth(param1:FighterMain):void {
			if (param1.mosouEnemyData.isBoss) {
				GameCtrl.I.getMosouCtrl().onBossBirth(param1);
			}
			GameCtrl.I.getMosouCtrl().updateEnemy(param1);
		}
		
		private function onEnemyDead(param1:FighterMain):void {
			var f:FighterMain = param1;
			GameCtrl.I.getMosouCtrl().gameRunData.koNum++;
			(GameUI.I.getUI() as MosouUI).updateKONum();
			GameData.I.mosouData.addMoney(f.mosouEnemyData.getMoney());
			GameData.I.mosouData.addFighterExp(f.mosouEnemyData.getExp());
			if (f.mosouEnemyData.isBoss) {
				GameCtrl.I.getMosouCtrl().onBossDead(f);
				var ui:MosouUI = GameUI.I.getUI() as MosouUI;
				if (ui) {
					ui.updateBossHp();
				}
				return;
			}
			EffectCtrl.I.removeEnemyEffect(f, function ():void {
				GameCtrl.I.getMosouCtrl().removeEnemy(f);
			});
		}
		
		private function changeFighter(param1:FighterEvent):void {
			var _loc2_:FighterMain = param1.fighter as FighterMain;
			if (_loc2_.team && _loc2_.team.id != 1) {
				return;
			}
			changeNextFighter();
		}
		
		private function changeNextFighter():Boolean {
			var _loc1_:GameRunFighterGroup = GameCtrl.I.gameRunData.p1FighterGroup;
			var _loc2_:FighterMain = _loc1_.getNextAliveFighter();
			if (!_loc2_) {
				return false;
			}
			GameCtrl.I.getMosouCtrl().changeFighter(_loc1_.currentFighter, _loc2_);
			return true;
		}
		
		private function onDie(param1:FighterEvent):void {
			var _loc3_:Boolean = false;
			var _loc2_:FighterMain = param1.fighter as FighterMain;
			if (_loc2_.team.id == 1) {
				GameCtrl.I.getMosouCtrl().onSelfDie(_loc2_);
			}
			if (_loc2_.team.id == 2) {
				MosouLogic.I.removeHitTarget(_loc2_);
				_loc3_ = _loc2_.mosouEnemyData && _loc2_.mosouEnemyData.isBoss;
				if (_loc3_) {
					GameCtrl.I.getMosouCtrl().onBossDie(_loc2_);
				}
			}
		}
		
		private function onDead(param1:FighterEvent):void {
			var _loc2_:FighterMain = param1.fighter as FighterMain;
			if (_loc2_.team.id == 1) {
				GameCtrl.I.getMosouCtrl().onSelfDead(_loc2_);
			}
			if (_loc2_.team.id == 2) {
				onEnemyDead(_loc2_);
			}
		}
		
		private function addHits(param1:FighterMain, param2:IGameSprite):void {
			if (!(param2 is FighterMain)) {
				return;
			}
			if (param1.team.id != 1) {
				return;
			}
			MosouLogic.I.addHits(param2 as FighterMain);
		}
	}
}
