/**
 * 已重建完成
 * 2024/6/14 完全移植所有旧版模式开关
 */
package net.play5d.game.bvn.interfaces {
	
	/**
	 * 游戏接口类
	 */
	public class GameInterface {
		
		public static var instance:IGameInterface;			// 实例
		
		// 获得默认菜单
		public static function getDefaultMenu():Array {
			return [{
				txt     : "TEAM PLAY",
				cn      : "小队模式",
				children: [{
					txt: "TEAM ACRADE",
					cn : "闯关模式"
				}, {
					txt: "TEAM VS PEOPLE",
					cn : "2P对战"
				}, {
					txt: "TEAM VS CPU",
					cn : "对战电脑"
				}, {
					txt: "TEAM WATCH",
					cn : "观战电脑"
				}
				]
			},{
				txt   :"PARTNER PLAY",
				cn    : "搭档模式",
				children: [{
					txt: "2v2",
					cn : "搭档对战"					
				},{
					txt:  "3v3",
					cn:   "搭档对战"
				},{
					txt: "2v2CPU", 	
					cn:   "搭档电脑"
				},{
					txt:   "3v3CPU",
					cn:    "搭档电脑"
				},{
					txt: "2v2WATCH", 	
					cn:   "搭档观战"
				},{
					txt: "3v3WATCH", 	
					cn:   "搭档观战"
				}]
			},{	
				txt     : "SINGLE PLAY",
				cn      : "单人模式",
				children: [{
					txt: "SINGLE ACRADE",
					cn : "闯关模式"
				}, {
					txt: "SINGLE VS PEOPLE",
					cn : "2P对战"
				}, {
					txt: "SINGLE VS CPU",
					cn : "对战电脑"
				}, {
					txt: "SURVIVOR",
					cn : "生存模式"
				}, {
					txt: "SINGLE WATCH",
					cn : "观战电脑"
				}
				]
			}, {
				txt: "OPTION",
				cn : "游戏设置"
			}, {
				txt: "TRAINING",
				cn : "练习模式"
			}, {
				txt: "CREDITS",
				cn : "制作组"
			}, {
				txt: "UPDATA",
				cn : "检查更新"
			}, {
				txt: "EXIT",
				cn : "退出游戏?"
			}
			];
		}
	}
}
