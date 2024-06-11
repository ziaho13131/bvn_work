/**
 * 已重建完成
 */
package net.play5d.game.bvn.stage {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.events.SetBtnEvent;
	import net.play5d.game.bvn.interfaces.GameInterface;
	import net.play5d.game.bvn.ui.SetBtnGroup;
	import net.play5d.game.bvn.utils.ResUtils;
	import net.play5d.kyo.stage.IStage;
	
	/**
	 * 制作组场景类
	 */
	public class CreditsStage implements IStage {
		
		private var _ui:Sprite;
		private var _btngroup:SetBtnGroup;
		private var _createsSp:DisplayObject;
		
		public function get display():DisplayObject {
			return _ui;
		}
		
		public function build():void {
			SoundCtrl.I.BGM(AssetManager.I.getSound("back"));
			
			_ui = new Sprite();
			var bgbd:BitmapData = ResUtils.I.createBitmapData(
				ResUtils.I.common_ui,
				"cover_bgimg",
				GameConfig.GAME_SIZE.x,
				GameConfig.GAME_SIZE.y
			);
			
			var bg:Bitmap = new Bitmap(bgbd);
			_ui.addChild(bg);
			
			var msg:String = getCreditsText();
			
			_createsSp = GameInterface.instance.getCreadits(msg);
			if (!_createsSp) {
				_createsSp = getDefaultCredits(msg);
			}
			
			_ui.addChild(_createsSp);
			
			_btngroup = new SetBtnGroup();
			_btngroup.y = GameConfig.GAME_SIZE.y - 150;
			_btngroup.setBtnData([{
				label: "BACK",
				cn   : "返回"
			}]);
			_btngroup.addEventListener(SetBtnEvent.SELECT, selectBtnHandler);
			
			_ui.addChild(_btngroup);
		}
		
		public function afterBuild():void {}
		
		public function destory(back:Function = null):void {
			if (_btngroup) {
				_btngroup.destory();
				_btngroup.removeEventListener(SetBtnEvent.SELECT, selectBtnHandler);
				_btngroup = null;
			}
		}
		
		private static function selectBtnHandler(e:SetBtnEvent):void {
			MainGame.I.goMenu();
		}
		
		private static function getCreditsText():String {
			return "程序：剑jian<br/>" +
				"人物：剑jian、数字化流天、L、V.临界幻想、Azrael、影、赤炎<br/>" +
				"辅助：小海、主流<br/>" +
				"图片：剑jian、数字化流天、社长星<br/>" +
				"策划：剑jian、数字化流天<br/>" +
				"贡献：灰原·银<br/><br/>" +
				"优化：流水“渺渺<br/>" +
				"长大后的你是否实现了当初的愿望？";
		}
		
		private static function getDefaultCredits(msg:String):Sprite {
			var sp:Sprite = new Sprite();
			var txt:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			
			tf.font = "Microsoft YaHei";
			tf.size = 20;
			tf.color = 0xFFFF00;
			tf.leading = 15;
			
			txt.defaultTextFormat = tf;
			txt.multiline = true;
			txt.mouseEnabled = false;
			txt.mouseWheelEnabled = false;
			txt.htmlText = msg;
			txt.autoSize = TextFormatAlign.LEFT;
			txt.x = 50;
			txt.y = 30;
			
			sp.addChild(txt);
			return sp;
		}
	}
}
