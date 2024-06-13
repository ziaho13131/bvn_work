/**
 * 已重建完成
 */
package net.play5d.game.obvn.ui.fight {
	import flash.display.DisplayObject;
	
	import net.play5d.game.obvn.data.GameRunFighterGroup;
	
	import flash.display.MovieClip;
	
	/**
	 * 战斗面部组类
	 */
	public class FightFaceGroup {
		
		private var _ui:MovieClip;
		
		private var _face1:FightFaceUI;
		private var _face2:FightFaceUI;
		private var _face3:FightFaceUI;
		
		public function FightFaceGroup(ui:MovieClip) {
			_ui = ui;
			_ui.cacheAsBitmap = true;
			
			_face1 = new FightFaceUI(_ui.face);
			_face2 = new FightFaceUI(_ui.face2);
			_face3 = new FightFaceUI(_ui.face3);
		}
		
		public function get ui():DisplayObject {
			return _ui;
		}
		
		public function setFighter(fighterGroup:GameRunFighterGroup = null):void {
			_ui.cacheAsBitmap = false;
			
			if (fighterGroup.currentFighter) {
				_face1.setData(fighterGroup.currentFighter.data);
			}
			
			switch (fighterGroup.currentFighter) {
				case fighterGroup.fighter1:
					_face2.setData(
						fighterGroup.fighter2 ? 
						fighterGroup.fighter2.data : 
						null
					);
					_face3.setData(
						fighterGroup.fighter3 ? 
						fighterGroup.fighter3.data : 
						null
					);
					break;
				case fighterGroup.fighter2:
					_face2.setData(
						fighterGroup.fighter3 ? 
						fighterGroup.fighter3.data : 
						null
					);
					_face3.setData(null);
					break;
				case fighterGroup.fighter3:
					_face2.setData(null);
					_face3.setData(null);
			}
			
			_ui.cacheAsBitmap = true;
		}
		
		public function setDirect(v:int):void {
			_face1.setDirect(v);
			_face2.setDirect(v);
			_face3.setDirect(v);
		}
	}
}
