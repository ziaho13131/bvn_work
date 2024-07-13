package net.play5d.game.bvn.data.mosou.utils {
	import net.play5d.game.bvn.data.mosou.player.MosouFighterVO;
	
	public class MosouFighterFactory {
		
		
		public function MosouFighterFactory() {
			super();
		}
		
		public static function create(id:String):MosouFighterVO {
			var fv:MosouFighterVO = new MosouFighterVO();
			fv.id = id;
			return fv;
		}
	}
}
