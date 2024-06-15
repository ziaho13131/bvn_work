/**
 * 已重建完成
 */
package net.play5d.game.bvn.ui.fight {
	import flash.display.DisplayObject;
	
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.data.FighterVO;
	
	import flash.display.MovieClip;
	
	/**
	 * 角色脸部UI
	 */
	public class FightFaceUI {
		
		private var _ui:MovieClip;
		
		public function FightFaceUI(ui:MovieClip) {
			_ui = ui;
		}
		
		public function setData(v:FighterVO):void {
			if (!v) {
				_ui.visible = false;
				return;
			}
			
			_ui.visible = true;
			
			var faceImg:DisplayObject = AssetManager.I.getFighterFaceBar(v);
			if (faceImg) {
				_ui.ct.addChild(faceImg);
			}
		}
		
		public function setDirect(v:int):void {}
	}
}
