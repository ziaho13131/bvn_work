/**
 * 已重建完成
 */
package net.play5d.game.bvn.stage {
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.ctrl.GameRender;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.ctrl.game_ctrls.GameCtrl;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.input.GameInputer;
	import net.play5d.game.bvn.interfaces.GameInterface;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.ui.MenuBtnGroup;
	import net.play5d.game.bvn.ui.UIUtils;
	import net.play5d.game.bvn.utils.ResUtils;
	import net.play5d.kyo.stage.IStage;
	
	/**
	 * 主菜单类
	 */
	public class MenuStage extends Sprite implements IStage {
		
		
		private var _ui:MovieClip;
		private var _btnGroup:MenuBtnGroup;
		private var _versionTxt:TextField;
		private var _destroyed:Boolean = false;
        private var _isBackTitleCd:Boolean = false;
		private var _isIngExitGame:Boolean = false
		
		public function get display():DisplayObject {
			return _ui;
		}
		
		public function build():void {
			_ui = ResUtils.I.createDisplayObject(ResUtils.I.title, ResUtils.TITLE);
			_ui.gotoAndStop(1);
			
			GameInterface.instance.initTitleUI(_ui);
			GameInputer.enabled = false;
			
			SoundCtrl.I.BGM(AssetManager.I.getSound("op"));
		}
		
		public function afterBuild():void {
			_ui.gotoAndPlay(2);
			_ui.buttonMode = true;
			_ui.useHandCursor = true;
			_ui.addEventListener(MouseEvent.CLICK,showBtns);
				
			GameRender.add(render);
			GameInputer.focus();
			GameInputer.enabled = true;
			
			_versionTxt = new TextField();
			UIUtils.formatText(_versionTxt, {
				color: 0x000000,
				size : 18
			});
			_versionTxt.text = MainGame.VERSION;
			_versionTxt.autoSize = TextFieldAutoSize.LEFT;
			_versionTxt.x = GameConfig.GAME_SIZE.x - _versionTxt.width - 15;
			_versionTxt.y = GameConfig.GAME_SIZE.y - _versionTxt.height - 10;
			
			_ui.addChild(_versionTxt);
			if (GameData.I.config.isFirstRunGame && MainGame.UPDATE_INFO) {
				GameData.I.config.isFirstRunGame = false;
				GameData.I.saveData();
				GameUI.alert("UPDATE", MainGame.UPDATE_INFO);
			}
		}
		
		private function render():void {
			if (_destroyed) {
				GameRender.remove(render);
				return;
			}
			if (GameInputer.anyKey(1)&&!GameInputer.back()&&!_isIngExitGame) {
				showBtns();
			}
			else if(GameInputer.back()&&_ui.currentLabel != "back"&&!_isIngExitGame) {
				GameInputer.enabled = false;
				_isIngExitGame = true;
				GameUI.confirm("EXIT GAME?", "是否退出游戏？", function ():void {
					NativeApplication.nativeApplication.exit();
				}, function ():void {
					_isIngExitGame = false;
					GameInputer.enabled = true;
				});
			}
		}
		
		private function backRender():void {
			if (_destroyed) {
				GameRender.remove(backRender);
				return;
			}
			if (GameInputer.back()&&!_isBackTitleCd) {
				closeBtns();
			}
			
		}
		
		private function showBtns(...params):void {
			_ui.removeEventListener(MouseEvent.CLICK, showBtns);
			
			GameRender.remove(render);
			GameRender.add(backRender);
			
			_ui.buttonMode = false;
			_ui.useHandCursor = false;
			_ui.gotoAndPlay("menu");
			
			SoundCtrl.I.playSwcSound(snd_menu5);
			
			_btnGroup = new MenuBtnGroup();
			_btnGroup.enabled = false;
			_btnGroup.x = 470;
			_btnGroup.y = 100;
			var ct:Sprite = _ui.getChildByName("btnct") as Sprite;
			if (ct) {
				ct.addChild(_btnGroup);
			}
			else {
				_ui.addChild(_btnGroup);
			}
			
			_btnGroup.build();
			_btnGroup.fadIn(0.2, 0.04);
			
			setTimeout(function ():void {
				_btnGroup.enabled = true;
				_isBackTitleCd = false;
			}, 400);
		}
		
	private function closeBtns():void {
		 GameRender.add(render);
		_ui.buttonMode = true;
		_ui.useHandCursor = true;
		_ui.addEventListener(MouseEvent.CLICK,showBtns);
		_ui.gotoAndPlay("back");
		GameInputer.enabled = true;
		SoundCtrl.I.playSwcSound(snd_menu5);
		GameRender.remove(backRender);
		if (_btnGroup) {
			_btnGroup.parent.removeChild(_btnGroup);
			}
		_btnGroup.destory();
		_btnGroup = null;
		_isBackTitleCd = true
	}
		
		public function destory(back:Function = null):void {
			_destroyed = true;
			if (_btnGroup) {
				try {
					_btnGroup.parent.removeChild(_btnGroup);
				}
				catch (e:Error) {
				}
				
				_btnGroup.destory();
				_btnGroup = null;
			}
			
			GameInputer.enabled = false;
		}
	}
}
