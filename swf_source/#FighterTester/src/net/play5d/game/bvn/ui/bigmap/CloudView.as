package net.play5d.game.bvn.ui.bigmap {
	import flash.display.MovieClip;
	
	import net.play5d.game.bvn.ctrl.AssetManager;
	
	public class CloudView {
		
		public var speed:Number = 0;
		public var mc:MovieClip;
		
		public function CloudView(x:Number, y:Number) {
			var mcClass:Class = AssetManager.I.getSWFEffectClass("cloud_mc", AssetManager.I.bigMapSwfPath);
			mc = new mcClass() as MovieClip;
			
			mc.x = x;
			mc.y = y;
			mc.alpha = 0.2 + Math.random() * 0.3;
			mc.gotoAndStop(1 + int(Math.random() * mc.totalFrames));
			speed = 0.02 + Math.random() * 0.1;
		}
		
		public function render():Boolean {
			mc.y -= speed;
			return mc.y < -mc.height + 30;
		}
	}
}
