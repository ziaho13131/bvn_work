package net.play5d.game.bvn.data.mosou {
	import net.play5d.game.bvn.data.FighterModel;
	import net.play5d.game.bvn.data.FighterVO;
	
	public class MosouFighterModel {
		
		private static var _i:MosouFighterModel;
		
		
		public var fighters:Vector.<MosouFighterSellVO>;
		
		private var _inited:Boolean = false;
		
		public function MosouFighterModel() {
			super();
		}
		
		public static function get I():MosouFighterModel {
			if (!_i) {
				_i = new MosouFighterModel();
			}
			return _i;
		}
		
		public function init():void {
			if (!_inited) {
				initFighters();
				_inited = true;
			}
		}
		
		public function allCustom():void {
			fighters = new Vector.<MosouFighterSellVO>();
			_inited = true;
		}
		
		private function initFighters():void {
			// 获取所有 fighter 的数据
			var fighterObj:Object = FighterModel.I.getAllFighters();
			// fighter 抽离出 id 和 金钱的数组
			var fighterArray:Array = [];
			// 这里用 Array 不用 Object 的原因是需要利用数组排序的特性，如果是Object就无法完成排序
			var item:Array;
			for each(var fv:FighterVO in fighterObj) {
				var id:String = fv.id;
				var money:int = fv.money;
				// 排除小兵、随机人物和活动人物
				if (fv.isZako || id.indexOf("random") != -1 || fv.isActivities) {
					continue;
				}
				item = [id, money];
				fighterArray.push(item);
			}
			// 使用默认 unicode 方法对其排序
			fighterArray.sort();
			
			var len:uint = fighterArray.length;
			fighters = new Vector.<MosouFighterSellVO>();
			for (var i:uint = 0; i < len; ++i) {
				item = fighterArray[i] as Array;
				var sellvo:MosouFighterSellVO = new MosouFighterSellVO(item[0], item[1]);
				fighters.push(sellvo);
			}
		}
		
		public function addFighter(id:String, param2:int):void {
			if (containsFighter(id)) {
				CONFIG::DEBUG {
					Trace("MosouFighterModel.addFighter 重复：" + id);
				}
				return;
			}
			fighters.push(new MosouFighterSellVO(id, param2));
		}
		
		private function containsFighter(id:String):Boolean {
			for each(var _loc2_:MosouFighterSellVO in fighters) {
				if (_loc2_.id == id) {
					return true;
				}
			}
			return false;
		}
	}
}
