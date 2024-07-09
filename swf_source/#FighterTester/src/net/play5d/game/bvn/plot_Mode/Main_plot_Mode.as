package net.play5d.game.bvn.plot_Mode
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.ctrl.GameRender;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.ctrl.StateCtrl;
	import net.play5d.game.bvn.ctrl.mosou_ctrls.MosouLogic;
	import net.play5d.game.bvn.data.GameData;
	import net.play5d.game.bvn.data.mosou.MosouModel;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapAreaVO;
	import net.play5d.game.bvn.data.mosou.MosouWorldMapVO;
	import net.play5d.game.bvn.events.GameEvent;
	import net.play5d.game.bvn.ui.GameUI;
	import net.play5d.game.bvn.ui.bigmap.BigmapClould;
	import net.play5d.game.bvn.ui.bigmap.WorldMapPointUI;
	import net.play5d.game.bvn.ui.dialog.DialogManager;
	import net.play5d.game.bvn.utils.BtnUtils;
	import net.play5d.game.bvn.utils.ResUtils;
	import net.play5d.game.bvn.utils.TouchMoveEvent;
	import net.play5d.game.bvn.utils.TouchUtils;
	import net.play5d.kyo.stage.IStage;
	
	
	/**
	 *生存模式
	 */
	public class Main_plot_Mode implements IStage
	{
		private var _ui:Sprite;
		
		private var _mapUI:Sprite;
		
		private var _viewMc:Sprite;
		
		private var _pointMc:Sprite;
		
		private var _maskMc:Sprite;
		
		private var _bgMc:Sprite;
		
		//private var _pointUIs:Vector.<WorldMapPointUI>;
		
		private var _downUIPos:Point
		
		private var _downMousePos:Point;
		
		private var _scale:Number = 1;
		
		private var _position:Point;
		
		//private var _currentPoint:WorldMapPointUI;
		
		//private var _cloudUI:BigmapClould;
		
		private var _backBtn:DisplayObject;
		
		public function Main_plot_Mode()
		{
			_downUIPos = new Point();
			_downMousePos = new Point();
			_position = new Point();
			super();
		}
		
		public function get display():DisplayObject {
			return _ui;
		}
		
		public function build():void {
			_ui = new Sprite();
			_mapUI = ResUtils.I.createDisplayObject(ResUtils.I.bigmap ,ResUtils.BIGMAP);
			_ui.addChild(_mapUI);
			_viewMc = _mapUI.getChildByName("view_mc") as Sprite;
			_pointMc = _mapUI.getChildByName("point_mc") as Sprite;
			_maskMc = _mapUI.getChildByName("mask_mc") as Sprite;
			_bgMc = _mapUI.getChildByName("bg_mc") as Sprite;
			if(_backBtn)
			{
				_backBtn.y = 10;
				_backBtn.x = 10;
				_ui.addChild(_backBtn);
			}
			_viewMc.mask = _maskMc;
			_viewMc.cacheAsBitmap = true;
			_maskMc.cacheAsBitmap = true;
			StateCtrl.I.transOut();
		}
		
		public function afterBuild():void {}
		
		public function destory(back:Function = null):void {
		}
	}
}