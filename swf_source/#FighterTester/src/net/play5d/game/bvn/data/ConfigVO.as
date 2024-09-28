/**
 * 已重建完成
 */
package net.play5d.game.bvn.data {
	import flash.display.StageQuality;
	
	import net.play5d.game.bvn.GameConfig;
	import net.play5d.game.bvn.GameQuality;
	import net.play5d.game.bvn.MainGame;
	import net.play5d.game.bvn.ctrl.EffectCtrl;
	import net.play5d.game.bvn.ctrl.SoundCtrl;
	import net.play5d.game.bvn.interfaces.GameInterface;
	import net.play5d.kyo.input.KyoKeyCode;
	import net.play5d.kyo.utils.KyoUtils;
	
	public class ConfigVO {
		
		// 按键 - 菜单模式
		private const KEY_MENU:int = 0;
		// 按键 - p1模式
		private const KEY_P1:int = 1;
		// 按键 - p2模式
		private const KEY_P2:int = 2;
		
		public const key_menu:KeyConfigVO = new KeyConfigVO(KEY_MENU);
		public const key_p1:KeyConfigVO = new KeyConfigVO(KEY_P1);
		public const key_p2:KeyConfigVO = new KeyConfigVO(KEY_P2);
		
		public var select_config:SelectStageConfigVO;
		public var isFirstRunGame :Boolean = true;
		public var AI_level    :int = 1;
		public var fighterHP   :Number = 2;
		public var initFighterQi:int = 100;
		public var fightTime   :int = -1;
		public var quality     :String = GameQuality.MEDIUM;
		public var cameraMaxSize:Number = 1;
        public var initFullFzQi:Boolean = true;
		public var isFullScreen:Boolean = false;
		public var isSmoothLowQuality:Boolean = true;
		public var isSteelBodyFreeze:Boolean = false;
		public var isSlowDown:Boolean = true;
		public var shakeLevel:String = "medium";
		public var soundVolume :Number = 1;
		public var weakHitFreeze:int = 0;
		public var heavyHitFreeze:int = 250;
		public var catchHitFreeze:int = 250;
		public var isInfiniteAttack:String = "medium";
		public var isLongGhostStep:String = "medium";
		public var isBreakCombo:String = "medium";
		public var allowWankai:* = "true";
		public var isChangeSpecialKey:Boolean = false;
		public var arcadeLoseMaxCount:* = 4;
		public var isBlackBack:* = 0.3;
		public var isSmothingEffect:Boolean = true;
		public var bgmVolume   :Number = 1;
		public var keyInputMode:int = 1;
		
//		public var extendConfig:IExtendConfig;
		
		public function ConfigVO() {
			select_config = new SelectStageConfigVO();
			super();
//			extendConfig = GameInterface.instance.getConfigExtend();
			setDefaultConfig(key_menu);
			setDefaultConfig(key_p1);
			setDefaultConfig(key_p2);
		}
		
		public function setDefaultConfig(keyConfig:KeyConfigVO):void {
			switch (keyConfig.id) {
				case KEY_MENU:
					keyConfig.setKeys(
						KyoKeyCode.W.code, KyoKeyCode.S.code, KyoKeyCode.A.code, KyoKeyCode.D.code, 
						KyoKeyCode.J.code, KyoKeyCode.K.code, KyoKeyCode.L.code, 
						KyoKeyCode.U.code, KyoKeyCode.I.code, KyoKeyCode.O.code
					);
					keyConfig.selects = [
						KyoKeyCode.J.code, KyoKeyCode.K.code, KyoKeyCode.L.code, 
						KyoKeyCode.U.code, KyoKeyCode.I.code, KyoKeyCode.O.code
					];
					break;
				case KEY_P1:
					keyConfig.setKeys(KyoKeyCode.W.code, KyoKeyCode.S.code, KyoKeyCode.A.code, KyoKeyCode.D.code, 
						KyoKeyCode.J.code, KyoKeyCode.K.code, KyoKeyCode.L.code,
						KyoKeyCode.U.code, KyoKeyCode.I.code, KyoKeyCode.O.code
					);
					break;
				case KEY_P2:
					keyConfig.setKeys(
						KyoKeyCode.UP.code, KyoKeyCode.DOWN.code, KyoKeyCode.LEFT.code, KyoKeyCode.RIGHT.code, 
						KyoKeyCode.Num1.code, KyoKeyCode.Num2.code, KyoKeyCode.Num3.code, 
						KyoKeyCode.Num4.code, KyoKeyCode.Num5.code, KyoKeyCode.Num6.code
					);
			}
		}
		
		public function toSaveObj():Object {
			var o:Object = {};
			o.key_p1 = key_p1.toSaveObj();
			o.key_p2 = key_p2.toSaveObj();
			o.isFirstRunGame = isFirstRunGame;
			o.AI_level = AI_level;
			o.fighterHP = fighterHP;
			o.initFighterQi = initFighterQi;
			o.fightTime = fightTime;
			o.quality = quality;
			o.cameraMaxSize = cameraMaxSize;
			o.initFullFzQi = initFullFzQi;
			o.isFullScreen = isFullScreen;
			o.isSmoothLowQuality = isSmoothLowQuality;
			o.isSteelBodyFreeze = isSteelBodyFreeze;
			o.isSlowDown = isSlowDown;
			o.shakeLevel = shakeLevel;
			o.weakHitFreeze = weakHitFreeze;
			o.heavyHitFreeze = heavyHitFreeze;
			o.catchHitFreeze = catchHitFreeze;
			o.isInfiniteAttack = isInfiniteAttack;
			o.isLongGhostStep = isLongGhostStep;
			o.isBreakCombo = isBreakCombo;
			o.allowWankai = allowWankai;
			o.isChangeSpecialKey = isChangeSpecialKey;
			o.arcadeLoseMaxCount = arcadeLoseMaxCount;
			o.isBlackBack = isBlackBack;
            o.isSmothingEffect = isSmothingEffect;
			o.keyInputMode = keyInputMode;
			o.soundVolume = soundVolume;
			o.bgmVolume = bgmVolume;
			
//			if (extendConfig) {
//				o.extend_config = extendConfig.toSaveObj();
//			}
			return o;
		}
		
		public function readSaveObj(o:Object):void {
			key_p1.readSaveObj(o.key_p1);
			key_p2.readSaveObj(o.key_p2);
//			if (o.extend_config && extendConfig) {
//				extendConfig.readSaveObj(o.extend_config);
//			}
			delete o["key_p1"];
			delete o["key_p2"];
			
			KyoUtils.setValueByObject(this, o);
		}
		
		public function getValueByKey(key:String):* {
			if (this.hasOwnProperty(key)) {
				return this[key];
			}
//			if (extendConfig) {
//				try {
//					return extendConfig[key];
//				}
//				catch (e:Error) {
//					trace(e);
//				}
//			}
			return null;
		}
		
		public function setValueByKey(key:String, value:*):void {
			if (this.hasOwnProperty(key)) {
				this[key] = value;
				
				switch (key) {
					case "bgmVolume":
						SoundCtrl.I.setBgmVolumn(bgmVolume);
						break;
					case "soundVolume":
						SoundCtrl.I.setSoundVolumn(soundVolume);
				}
//				return;
			}
//			if (extendConfig) {
//				try {
//					extendConfig[key] = value;
//				}
//				catch (e:Error) {
//					trace(e);
//				}
//			}
		}
		
		public function resetDefaultConfig(isRule:Boolean = false):void {
			if (isRule) {
				isInfiniteAttack = "medium";
				isLongGhostStep = "medium";
				isBreakCombo = "medium";
				allowWankai = "true";
				isChangeSpecialKey = false;
			}
			 else {
				AI_level     = 1;
				fighterHP    = 2;
				initFighterQi = 100;
				fightTime    = -1;
				quality      = GameQuality.MEDIUM;
				cameraMaxSize = 1;
				initFullFzQi = true;
				isFullScreen = false;
				isSmoothLowQuality = true;
				isSteelBodyFreeze = false;
				isSlowDown = true;
				shakeLevel = "medium";
				soundVolume  = 1;
				weakHitFreeze = 0;
				heavyHitFreeze = 250;
				catchHitFreeze = 250;
				bgmVolume    = 1;
				keyInputMode = 1;
				arcadeLoseMaxCount = 4;
				isBlackBack = 0.3;
				isSmothingEffect = true;
			}
		}
			
		public function applyConfig():void {
			switch (quality) {
				case GameQuality.LOW:
					MainGame.I.stage.quality = isSmoothLowQuality?StageQuality.MEDIUM:StageQuality.LOW;
					GameConfig.setGameFps(30);
					GameConfig.FPS_SHINE_EFFECT = 15;
					EffectCtrl.EFFECT_SMOOTHING = false;
					break;
				case GameQuality.MEDIUM:
					MainGame.I.stage.quality = isSmoothLowQuality?StageQuality.MEDIUM:StageQuality.LOW;
					GameConfig.setGameFps(60);
					GameConfig.FPS_SHINE_EFFECT = 30;
					EffectCtrl.EFFECT_SMOOTHING = false;
					break;
				case GameQuality.HIGH:
					MainGame.I.stage.quality = StageQuality.MEDIUM;
					GameConfig.setGameFps(60);
					GameConfig.FPS_SHINE_EFFECT = 30;
					EffectCtrl.EFFECT_SMOOTHING = false;
					break;
				case GameQuality.HIGHER:
					MainGame.I.stage.quality = StageQuality.HIGH;
					GameConfig.setGameFps(60);
					GameConfig.FPS_SHINE_EFFECT = 30;
					EffectCtrl.EFFECT_SMOOTHING = true;
					break;
				case GameQuality.BEST:
					MainGame.I.stage.quality = StageQuality.HIGH;
					GameConfig.setGameFps(60);
					GameConfig.FPS_SHINE_EFFECT = 60;
					EffectCtrl.EFFECT_SMOOTHING = true;
			}
			if(isFullScreen) {
				MainGame.I.stage.displayState = "fullScreenInteractive";
			}
			else {
				MainGame.I.stage.displayState = "normal";
			}
			if (arcadeLoseMaxCount != false) {
				GameConfig.ArcadeIntSwitch = false;
			}
			if (allowWankai != false && allowWankai != "true") {
				GameConfig.isLimitedTimedBankai = true;
			}
			else {
				GameConfig.isLimitedTimedBankai = false;
			}
			GameInterface.instance.applyConfig(this);
			SoundCtrl.I.setBgmVolumn(bgmVolume);
			SoundCtrl.I.setSoundVolumn(soundVolume);
		}
	}
}
