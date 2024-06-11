/**
 * 已重建完成
 */
package net.play5d.game.bvn.views.effects {
	import flash.geom.ColorTransform;
	
	import net.play5d.game.bvn.data.EffectVO;
	import net.play5d.game.bvn.fighter.FighterMain;
	import net.play5d.game.bvn.fighter.vos.FighterBuffVO;
	import net.play5d.game.bvn.interfaces.IGameSprite;
	
	/**
	 * BUFF 特效元件
	 */
	public class BuffEffectView extends EffectView {
		
		private var _fighter:FighterMain;				// 目标FighterMain
		private var _buff:FighterBuffVO;				// 效果 BUFF
		
		public function BuffEffectView(data:EffectVO) {
			super(data);
			loopPlay = true;
		}
		
		public function setBuff(v:FighterBuffVO):void {
			_buff = v;
		}
		
		override public function setTarget(v:IGameSprite):void {
			super.setTarget(v);
			
			if (v is FighterMain) {
				_fighter = v as FighterMain;
			}
			if (_fighter && _data.targetColorOffset) {
				var ct:ColorTransform = new ColorTransform();
				ct.redOffset = _data.targetColorOffset[0];
				ct.greenOffset = _data.targetColorOffset[1];
				ct.blueOffset = _data.targetColorOffset[2];
				
				_fighter.changeColor(ct);
			}
		}
		
		override public function render():void {
			super.render();
			
			if (_buff.finished) {
				if (_fighter && _data.targetColorOffset) {
					_fighter.resumeColor();
				}
				
				remove();
			}
			else if (_fighter) {
				setPos(_fighter.x, _fighter.y);
			}
		}
	}
}
