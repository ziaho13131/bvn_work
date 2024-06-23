/**
 * 已重建完成
 */
package net.play5d.game.bvn.interfaces {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	import net.play5d.game.bvn.data.ConfigVO;
	import net.play5d.game.bvn.input.GameKeyInput;
	import net.play5d.game.bvn.utils.FileUtils;
	
	public class GameInterfaceManager implements IGameInterface {
		
		
		public function initTitleUI(ui:DisplayObject):void {}
		
//		public function moreGames():void {
//			WebUtils.getURL("http://www.5dplay.net");
//		}
		
//		public function submitScore(score:int):void {}
		
//		public function showRank():void {}
		
		public function saveGame(data:Object):void {
			var _loc2_:String = JSON.stringify(data);
			var _loc3_:File = File.applicationDirectory.resolvePath("bvnsave.sav");
			FileUtils.writeFile(_loc3_.nativePath,_loc2_)
			trace("saveData",_loc2_);	
		}
		
		public function loadGame():Object {
			var _loc2_:File = File.applicationStorageDirectory.resolvePath("bvnsave.sav");
			var _loc1_:String = FileUtils.readTextFile(_loc2_.nativePath);
			if(!_loc1_)
			{
				return null;
			}
			return JSON.parse(_loc1_);
		}
		
//		public function getFighterCtrl(player:int):IFighterActionCtrl {
//			return null;
//		}
		
		public function getGameMenu():Array {
			return null;
		}
		
		public function getSettingMenu():Array {
			return null;
		}
		
		public function getGameInput(type:String):Vector.<IGameInput> {
			var vec:Vector.<IGameInput> = new Vector.<IGameInput>();
			vec.push(new GameKeyInput());
			return vec;
		}
		
//		public function getConfigExtend():IExtendConfig {
//			return null;
//		}
		
		public function afterBuildGame():void {}
		
		public function updateInputConfig():Boolean {
			return false;
		}
		
		public function applyConfig(config:ConfigVO):void {}
		
		public function getCreadits(creditsInfo:String):Sprite {
			return null;
		}
	}
}
