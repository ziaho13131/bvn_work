package net.play5d.game.bvn.data.mosou {
	public class MosouWorldMapVO {
		
		
		public var id:String;
		
		public var name:String;
		
		public var areas:Vector.<MosouWorldMapAreaVO>;
		
		private var _areaMap:Object;
		
		public function MosouWorldMapVO() {
			super();
		}
		
		public function initWay(param1:Array):void {
			var _loc3_:* = null;
			var _loc4_:* = null;
			var _loc5_:int = 0;
			areas = new Vector.<MosouWorldMapAreaVO>();
			_areaMap = {};
			_loc5_ = 0;
			while (_loc5_ < param1.length) {
				_loc3_ = param1[_loc5_];
				(_loc4_ = new MosouWorldMapAreaVO()).id = _loc3_.P;
				areas.push(_loc4_);
				_areaMap[_loc4_.id] = _loc4_;
				_loc5_++;
			}
			_loc5_ = 0;
			while (_loc5_ < param1.length) {
				_loc3_ = param1[_loc5_];
				_loc4_ = _areaMap[_loc3_.P];
				if (!(!_loc4_ || !_loc3_.N)) {
					_loc4_.preOpens = new Vector.<MosouWorldMapAreaVO>();
					if (_loc3_.N is Array) {
						for each(var _loc2_:String in _loc3_.N) {
							if (_areaMap[_loc2_]) {
								_loc4_.preOpens.push(_areaMap[_loc2_]);
							}
						}
					}
					else if (_areaMap[_loc3_.N]) {
						_loc4_.preOpens.push(_areaMap[_loc3_.N]);
					}
				}
				_loc5_++;
			}
		}
		
		public function getArea(param1:String):MosouWorldMapAreaVO {
			return _areaMap[param1];
		}
	}
}
