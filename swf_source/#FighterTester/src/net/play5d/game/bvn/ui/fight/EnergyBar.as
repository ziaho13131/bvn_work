/**
 * 已重建完成
 */
package net.play5d.game.bvn.ui.fight {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import net.play5d.game.bvn.fighter.FighterMain;
	
	/**
	 * 气条类
	 */
	public class EnergyBar {
		
		private var _ui:MovieClip;
		
		private var _fighter:FighterMain;
		private var _bar:InsBar;
		private var _txt:InsTxt;
		private var _energyTxtMc:MovieClip;
		private var _energyTxt:TextField;
		
//		private var _renderFlash:Boolean;
//		private var _renderFlashInt:int;
		
		public function EnergyBar(ui:MovieClip) {
			_ui = ui;
			_bar = new InsBar(_ui.barmc.bar);
			_txt = new InsTxt(_ui.txtmc);
			_energyTxtMc = _ui.getChildByName("energytxt") as MovieClip;
			_energyTxt = _energyTxtMc.mc.txt;
		}
		
		public function get ui():DisplayObject {
			return _ui;
		}
		
		public function destory():void {
			_fighter = null;
			_energyTxtMc = null;
		}
		
		public function setFighter(v:FighterMain):void {
			_fighter = v;
			if (v.data) {
				_txt.setType(v.data.comicType);
			}
		}
		
		public function setDirect(v:int):void {
			_txt.setDirect(v);
			if (v < 0) {
			 if (_energyTxtMc) {
				 _energyTxtMc.gotoAndStop(2);
				 _energyTxt = _energyTxtMc.mc.txt;
			 }
				
			}
		}
		
		public function render():void {
			_bar.rate = _fighter.energy / _fighter.energyMax;
			
			if (_fighter.energyOverLoad) {
				_bar.overLoad();
				_txt.overLoad();
			}
			else if (_bar.rate < 0.3) {
				_bar.flash();
				_txt.flash();
			}
			else {
				_bar.normal();
				_txt.normal();
			}
			if (_energyTxt) {
				_energyTxt.text = int(_fighter.energy).toString();
			}
			_bar.render();
			_txt.render();
		}
	}
}

import flash.display.MovieClip;

/**
 * 内部条类
 */
class InsBar {
	
	public var rate:Number = 1;
	
	private var _mc:MovieClip;
//	private var _curRate:Number = 1;
	private var _isOverLoad:Boolean;
	private var _isFlash:Boolean;
	
	private var _renderFlashInt:int;
	private var _renderFlashFrame:int = 2;
	
	public function InsBar(mc:MovieClip) {
		_mc = mc;
	}
	
	public function render():void {
		var diff:Number = rate - _mc.scaleX;
		
		if (Math.abs(diff) < 0.01) {
			_mc.scaleX = rate;
		}
		else {
			_mc.scaleX += diff * 0.4;
		}
		
		if (_isFlash) {
			renderFlash();
		}
	}
	
	private function renderFlash():void {
		if (++_renderFlashInt > 2) {
			_renderFlashInt = 0;
			
			_mc.gotoAndStop(_renderFlashFrame);
			_renderFlashFrame = _renderFlashFrame == 1 ? 2 : 1;
		}
	}
	
	public function normal():void {
		if (!_isOverLoad && !_isFlash) {
			return;
		}
		
		_isOverLoad = false;
		_isFlash = false;
		_mc.gotoAndStop(1);
	}
	
	public function flash():void {
		if (_isFlash) {
			return;
		}
		
		_isFlash = true;
		_renderFlashInt = 0;
		_renderFlashFrame = 2;
	}
	
	public function overLoad():void {
		if (_isOverLoad) {
			return;
		}
		
		_isOverLoad = true;
		_isFlash = false;
		_mc.gotoAndStop(2);
	}
}

import flash.display.MovieClip;

/**
 * 内部文本类
 */
class InsTxt {
	
	private var _mc:MovieClip;
	
	private var _isOverLoad:Boolean;
	private var _isFlash:Boolean;
	
	private var _renderFlashInt:int;
	private var _renderFlashFrame:int;
	
	public function InsTxt(mc:MovieClip) {
		_mc = mc;
	}
	
	public function setDirect(v:int):void {
		_mc.scaleX = v > 0 ? 1 : -1;
	}
	
	public function setType(v:int):void {
		switch (v) {
			case 0:
				_mc.gotoAndStop(1);
				break;
			case 1:
				_mc.gotoAndStop(2);
		}
	}
	
	public function render():void {
		if (_isFlash) {
			renderFlash();
		}
	}
	
	private function renderFlash():void {
		if (!_mc.mc) {
			return;
		}
		
		if (++_renderFlashInt > 2) {
			_renderFlashInt = 0;
			_mc.mc.gotoAndStop(_renderFlashFrame);
			_renderFlashFrame = _renderFlashFrame == 1 ? 2 : 1;
		}
	}
	
	public function normal():void {
		if (!_isOverLoad && !_isFlash) {
			return;
		}
		
		_isOverLoad = false;
		_isFlash = false;
		
		if (_mc.mc) {
			_mc.mc.gotoAndStop(1);
		}
	}
	
	public function flash():void {
		if (_isFlash) {
			return;
		}
		
		_isFlash = true;
		_renderFlashInt = 0;
		_renderFlashFrame = 2;
	}
	
	public function overLoad():void {
		if (_isOverLoad) {
			return;
		}
		
		_isOverLoad = true;
		_isFlash = false;
		
		if (_mc.mc) {
			_mc.mc.gotoAndStop(2);
		}
	}
}
