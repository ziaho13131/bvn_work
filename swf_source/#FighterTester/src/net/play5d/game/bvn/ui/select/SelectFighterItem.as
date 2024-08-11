/**
 * 已重建完成
 */
package net.play5d.game.bvn.ui.select {
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import flash.filters.GlowFilter;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import net.play5d.kyo.display.BitmapText;
	import flash.geom.Point;
	
	import net.play5d.game.bvn.ctrl.AssetManager;
	import net.play5d.game.bvn.data.FighterVO;
	import net.play5d.game.bvn.data.SelectCharListItemVO;
	import net.play5d.game.bvn.utils.ResUtils;
	
	/**
	 * 选择角色节点
	 */
	public class SelectFighterItem extends EventDispatcher {
		
		public var selectData:SelectCharListItemVO;
		public var fighterData:FighterVO;
		public var ui:MovieClip = ResUtils.I.createDisplayObject(ResUtils.I.select, "slt_item_mc");
		public var isMore:Boolean = false;
		private var _moreText:BitmapText;
		private var _destoryed:Boolean = false;
		private var _tweenFrom:Point;
		private var _tweenTo:Point;
		
		public var position:Point = new Point();
		
		private var faceSize:Point;
		private var _listeners:Object = {};
		
		public function SelectFighterItem(fighterData:FighterVO, selectData:SelectCharListItemVO, isMore:Boolean = false) {
			position = new Point();
			faceSize = new Point(50,50);
			this.selectData = selectData;
			this.fighterData = fighterData;
			this.isMore = isMore;
			super();
			var ct:ColorTransform = null;
			var face:DisplayObject = AssetManager.I.getFighterFace(fighterData);
			if (face) {
				ui.ct.addChild(face);
			}
			if (selectData != null && selectData.moreFighterIDs) {
				initMoreUI();
			}
			if (ui.more_bg) {
				ui.more_bg.visible = isMore;
				ui.more_bg.mouseChildren = false;
				ui.more_bg.mouseEnabled = false;
				ct = new ColorTransform();
				ct.redOffset = 255;
				ct.blueOffset = -255;
				ui.more_bg.transform.colorTransform = ct;
			}
			ui.mouseChildren = false;
			ui.buttonMode = true;
		}
		
		override public function addEventListener(
			type:String, listener:Function,
			useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if (ui.hasEventListener(type)) {
				return;
			}
			
			ui.addEventListener(type, selfHandler, useCapture, priority, useWeakReference);
			_listeners[type] = listener;
		}
		
		public function removeAllEventListener():void {
			for (var i:String in _listeners) {
				ui.removeEventListener(i, _listeners[i]);
			}
			
			_listeners = {};
		}
		
		private function selfHandler(e:Event):void {
			var listener:Function = _listeners[e.type] as Function;
			if (listener != null) {
				listener(e.type, this);
			}
		}
		public function get positionId():String {
			return getIdByPoint(position.x,position.y);
		}
		
		public static function getIdByPoint(pos1:int, pos2:int):String {
			return pos1 + "," + pos2;
		}
		
		public function initMoreTween(pointFrom:Point, pointTo:Point):void {
			_tweenFrom = pointFrom;
			_tweenTo = pointTo;
		}
		
		public function showMore(v:Number = 0.1):void {
			var delay:Number;
			if (_destoryed) {
				return;
			}
			delay = v;
			ui.x = _tweenFrom.x;
			ui.y = _tweenFrom.y;
			ui.mouseEnabled = false;
			TweenLite.to(ui,0.2,{
				"x":_tweenTo.x,
				"y":_tweenTo.y,
				"ease":Back.easeOut,
				"delay":delay,
				"onComplete":function():void {
					ui.mouseEnabled = true;
				}
			});
		}
		
		public function hideMore():void {
			if (_destoryed) {
				return;
			}
			TweenLite.to(ui,0.1,{
				"x":_tweenFrom.x,
				"y":_tweenFrom.y,
				"onComplete":function():void
				{
					try {
						ui.parent.removeChild(ui);
					}
					catch(e:Error){}
				}
			});
		}
		
		private function initMoreUI():void {
			var moreTxt:BitmapText = new BitmapText(false,16776960,[new GlowFilter(0,1,5,5,3)]);
			moreTxt.width = 50;
			moreTxt.defaultTextFormat.bold = true;
			moreTxt.defaultTextFormat.color = 16776960;
			moreTxt.defaultTextFormat.size = 16;
			moreTxt.y = -3;
			moreTxt.text = selectData.moreFighterIDs.length + "+";
			moreTxt.update();
			ui.addChild(moreTxt);
			_moreText = moreTxt;
		}
		
		public function setMoreNumberVisible(v:Boolean):void {
			if (_moreText == null)return;
			_moreText.visible = v;
		}
		
		public function destory():void {
			_destoryed = true;
			if (ui) {
				removeAllEventListener();
			}
			if (ui && ui.parent) {
				try {
					ui.parent.removeChild(ui);
				}
				catch (e:Error) {
				}
				
				ui = null;
			}
		}
	}
}
