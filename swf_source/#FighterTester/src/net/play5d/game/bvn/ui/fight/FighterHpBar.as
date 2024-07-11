/**
 * 已重建完成
 */
package net.play5d.game.bvn.ui.fight {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.fighter.FighterActionState;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.events.FighterEvent;
	import net.play5d.game.bvn.fighter.events.FighterEventDispatcher;
	
	/**
	 * 角色血条类
	 */
	public class FighterHpBar {
		
		private var _ui:MovieClip;
		private var _bar:DisplayObject;
		private var _redbar:DisplayObject;
		private var _fighter:FighterMain;
		private var _hprate:Number = 1;
		
		private var _redBarMoving:Boolean;
		private var _redBarMoveDelay:int;
		private var _justHurtFly:Boolean;
		private var _direct:int;
		
		//血条数字
		private var HIDE_DELAY:int = 30;
		private var _hpTxtMc:DisplayObject;
		private var _hpText:TextField;
		
		//恢复血条数字
		private var _addTxtMc:MovieClip;
		private var _addText:TextField;
		private var _addHp:Number = 0;
		private var _addShow:Boolean = false;
		private var _addHideDelay:int = 0;
		
		//伤害血条数字
		private var _damageTxtMc:MovieClip;
		private var _damageText:TextField;
		private var _damage:Number = 0;
		private var _damageShow:Boolean = false;
		private var _damageHideDelay:int = 0;

		public function FighterHpBar(ui:MovieClip) {
			_ui = ui;
			_bar = _ui.bar;
			_redbar = _ui.redbar;
			_hpTxtMc = _ui.hptxt;
			_hpText = (_hpTxtMc as MovieClip).mc.txt;
			_addTxtMc = _ui.getChildByName("addtxt") as MovieClip;
			_addText = _addTxtMc.mc.txt;
			_damageTxtMc = _ui.getChildByName("damagetxt") as MovieClip;
			_damageText = _damageTxtMc.mc.txt;
			hideAdd();
			hideDamge();
			
			//添加血量恢复和损失事件
			FighterEventDispatcher.addEventListener("ADD_HP",onAddHp);
			FighterEventDispatcher.addEventListener("LOSE_HP",onLoseHp);
		}
		
		public function get ui():DisplayObject {
			return _ui;
		}
		
		public function setDirect(direct:int):void
		{
			_direct = direct;
			if(direct < 0)
			{
				if(_hpTxtMc != null)
				{
					(_hpTxtMc as MovieClip).gotoAndStop(2);
					_hpText = (_hpTxtMc as MovieClip).mc.txt;
				}
				if(_addTxtMc != null)
				{
					_addTxtMc.gotoAndStop(2);
					_addText = _addTxtMc.mc.txt;
				}
				if(_damageTxtMc != null)
				{
					_damageTxtMc.gotoAndStop(2);
					_damageText = _damageTxtMc.mc.txt;
				}
				hideAdd();
				hideDamge();
			}
		}
		
		public function destory():void {
			_fighter = null;
			_bar = null;
			_redbar = null;
			_hpTxtMc = null;
			_hpText = null;
			_addTxtMc = null;
			_addText = null;
			_damageTxtMc = null;
			_damageText = null;
			_ui = null;
			
			//删除血量恢复和损失事件
			FighterEventDispatcher.removeEventListener("ADD_HP",onAddHp);
			FighterEventDispatcher.removeEventListener("LOSE_HP",onLoseHp);
		}
		
		public function setFighter(v:FighterMain):void {
			_fighter = v;
		}
		
		public function render():void {
			var rate:Number = _fighter.hp / _fighter.hpMax;
			
			if (_redBarMoving && rate != _hprate) {
				_redbar.scaleX = _hprate;
				_redBarMoving = false;
			}
			
			_hprate = rate;
			
			var diff:Number = _hprate - _bar.scaleX;
			var addRate:Number = diff < 0 ? 0.4 : 0.04;
			
			if (Math.abs(diff) < 0.01) {
				_bar.scaleX = _hprate;
			}
			else {
				_bar.scaleX += diff * addRate;
			}
			
			switch (_fighter.actionState) {
				// 红条不会立马开始减少
				case FighterActionState.HURT_ING:
				case FighterActionState.HURT_FLYING:
					_redBarMoveDelay = 100;
					break;
				// 红条开始减少
				case FighterActionState.HURT_DOWN:
				case FighterActionState.HURT_DOWN_TAN:
					if (_redBarMoveDelay > 0) {
						if (!_justHurtFly) {
							_redBarMoveDelay = 1.5 * GameConfig.FPS_GAME;
							_justHurtFly = true;
							break;
						}
						if (_redBarMoveDelay > 0) {
							_redBarMoveDelay--;
							break;
						}
						break;
					}
					break;
				default:
					_redBarMoveDelay = 0;
					_justHurtFly = false;
			}
			
			if (_redBarMoveDelay <= 0) {
				var diff2:Number = _hprate - _redbar.scaleX;
				var addRate2:Number = diff2 < 0 ? 0.1 : 0.02;
				if (Math.abs(diff2) < 0.01) {
					_redbar.scaleX = _hprate;
					_redBarMoving = false;
				}
				else {
					_redbar.scaleX += diff2 * addRate2;
					_redBarMoving = true;
				}
			}
			
			//血条数字
			if (_hpText != null)
			{
				_hpText.text = int(_fighter.hp).toString();
			}
			
			//血量恢复
		     if (_addText && _addShow)
			{
				_addText.text = _addHp > 0 ? "+" + _addHp.toString() : "";
				_addHideDelay--;
				if(isHurting() || _addHideDelay <= 0)
				{
					hideAdd();
				}
			}
			 
			//血量损失 
			  if (_damageText && _damageShow)
			 {
				 _damageText.text = _damage > 0 ? "-" + _damage.toString() : "";
				 _damageHideDelay--;
				 if(_damageHideDelay <= 0 && !FighterActionState.isHurting(_fighter.actionState))
				 {
					 hideDamge();
				 } 
			 } 	 
		}
		
		private function hideAdd():void
		{
			_addText.text = "";
			_addHp = 0;
			_addTxtMc.visible = _addShow = false;
		}
		
		private function hideDamge():void
		{
			_damageText.text = "";
			_damage = 0;
			_damageTxtMc.visible = _damageShow = false;
		}
		
		private function showAdd():void
		{
			_addTxtMc.visible = _addShow = true;
		}
		
		private function showDamage():void
		{
			_damageTxtMc.visible = _damageShow = true;
		}
		
		private function isHurting():Boolean
		{
			return FighterActionState.isHurting(_fighter.actionState) && _damage > 0;
		}
		
		private function onAddHp(event:FighterEvent):void
		{
			HIDE_DELAY = MainGame.I.getFPS();
			var fighter:FighterMain = event.fighter as FighterMain;
			if(fighter != null && fighter != _fighter)
			{
				return;
			}
			var addHp:Number = event.params as Number;
			_addHideDelay = HIDE_DELAY;
			_addHp += addHp;
			if(_addHp > 0)
			{
				showAdd();
			}
		}
		
		private function onLoseHp(event:FighterEvent):void
		{
			HIDE_DELAY = MainGame.I.getFPS();
			var fighter:FighterMain = event.fighter as FighterMain;
			if(fighter != null && fighter != _fighter)
			{
				return;
			}
			var loseHp:Number = event.params as Number;
			_damageHideDelay = HIDE_DELAY;
			_damage += loseHp;
			if(_damage > 0)
			{
				showDamage();
			}
		}
	}
}
