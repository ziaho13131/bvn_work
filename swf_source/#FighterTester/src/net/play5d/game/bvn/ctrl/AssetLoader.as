/**
 * 已重建完成
 */
package net.play5d.game.bvn.ctrl {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	import net.play5d.game.bvn.interfaces.IAssetLoader;
	import net.play5d.kyo.loader.KyoURLoader;
	
	/**
	 * 素材加载器
	 */
	public class AssetLoader implements IAssetLoader {
		
		public function loadXML(url:String, back:Function, fail:Function = null):void {
			KyoURLoader.load(url, function (v:String):void {
				if (back != null) {
					back(new XML(v));
				}
			}, fail);
		}
		
		
		public function loadSwf(url:String, back:Function, fail:Function = null, process:Function = null):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProcess);
			loader.load(new URLRequest(url));
			
			function loadComplete(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (back != null) {
					back(loader);
				}
			}
			function loadError(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (fail != null) {
					fail();
				}
			}
			function loadProcess(e:ProgressEvent):void {
				if (process != null) {
					process(e.bytesLoaded / e.bytesTotal);
				}
			}
		}
		
		public function loadBitmap(url:String, back:Function, fail:Function = null, process:Function = null):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProcess);
			loader.load(new URLRequest(url));
			
			function loadComplete(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (back != null) {
					back(loader.content);
				}
			}
			function loadError(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (fail != null) {
					fail();
				}
			}
			function loadProcess(e:ProgressEvent):void {
				if (process != null) {
					process(e.bytesLoaded / e.bytesTotal);
				}
			}
		}
		
		public function loadSound(url:String, back:Function, fail:Function = null, process:Function = null):void {
			var sound:Sound = new Sound(new URLRequest(url));
			sound.addEventListener(Event.COMPLETE, loadCom);
			sound.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
			sound.addEventListener(ProgressEvent.PROGRESS, loadProcess);
			
			function loadCom(e:Event):void {
				sound.removeEventListener(Event.COMPLETE, loadCom);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, loadErr);
				sound.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (back != null) {
					back(sound);
				}
			}
			function loadErr(e:IOErrorEvent):void {
				sound.removeEventListener(Event.COMPLETE, loadCom);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, loadErr);
				sound.removeEventListener(ProgressEvent.PROGRESS, loadProcess);
				if (fail != null) {
					fail();
				}
			}
			function loadProcess(e:ProgressEvent):void {
				if (process != null) {
					process(e.bytesLoaded / e.bytesTotal);
				}
			}
		}
		
		public function dispose(url:String):void {}
		
		public function needPreLoad():Boolean {
			return false;
		}
		
		public function loadPreLoad(back:Function, fail:Function = null, process:Function = null):void {}
		
		public function loadJSON(param1:String, param2:Function, param3:Function = null) : void
		{
			var url:String = param1;
			var back:Function = param2;
			var fail:Function = param3;
			ȁ(url,function(param1:ByteArray):void
			{
				var _loc2_:Object = null;
				if(back != null)
				{
					param1.position = 0;
					_loc2_ = null;
					try
					{
						_loc2_ = JSON.parse(param1.readUTFBytes(param1.length));
					}
					catch(e:Error)
					{
					}
					back(_loc2_);
				}
			},fail);
		}
		
		private function ȁ(param1:String, param2:Function, param3:Function, param4:Function = null) : void
		{
			var dir:String;
			var dirIndex:int;
			var slashIndex:int;
			var ȉ:Boolean;
			var dotIndex:int;
			var ext:String;
			var url:String = param1;
			var back:Function = param2;
			var fail:Function = param3;
			var process:Function = param4;
			var loadComplete:* = function(param1:ByteArray):void
			{
				var _loc3_:* = null;
				var _loc2_:* = 0;
				var _loc4_:* = 0;
				if(needDecrypt)
				{
					_loc3_ = param1;
					param1.clear();
				}
				else
				{
					_loc3_ = param1;
				}
				if(back != null)
				{
					back(_loc3_);
				}
			};
			var needDecrypt:Boolean = false;
			ȉ = false;
			loadBytes("assets/" + url,loadComplete,fail,process);
		}
		
		private function loadBytes(param1:String, param2:Function, param3:Function = null, param4:Function = null) : void
		{
			var url:String = param1;
			var back:Function = param2;
			var fail:Function = param3;
			var progress:Function = param4;
			var onComplete:* = function(param1:Event):void
			{
				if(back != null)
				{
					back(loader.data as ByteArray);
				}
				loader = null;
			};
			var onError:* = function(param1:IOErrorEvent):void
			{
				if(fail != null)
				{
					fail();
				}
				loader = null;
			};
			var onProgress:* = function(param1:ProgressEvent):void
			{
				if(progress != null)
				{
					progress(param1.bytesLoaded / param1.bytesTotal);
				}
			};
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = "binary";
			loader.addEventListener("complete",onComplete);
			loader.addEventListener("ioError",onError);
			loader.addEventListener("progress",onProgress);
			loader.load(new URLRequest(url));
		}
	}
}
