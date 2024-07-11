﻿/**
 * 已重建完成
 */
package net.play5d.game.bvn.fighter.events {
	import flash.events.Event;
	
	import net.play5d.game.bvn.interfaces.BaseGameSprite;
	
	/**
	 * 人物事件
	 */
	public class FighterEvent extends Event {
		
		public static const FIRE_BULLET:String = "FIRE_BULLET";
		public static const ADD_ATTACKER:String = "ADD_ATTACKER";
		public static const ADD_ASSISTER:String = "ADD_ASSISTER";
		
		public static const HIT_TARGET:String = "HIT_TARGET";
		public static const HURT_RESUME:String = "HURT_RESUME";
		public static const HURT_DOWN:String = "HURT_DOWN";
		public static const DIE:String = "DIE";
		
		public static const DO_ACTION:String = "DO_ACTION";
		
		public static const LOSE_HP:String = "LOSE_HP";
		public static const ADD_HP:String = "ADD_HP";
		
		public static const LOSE_QI:String = "LOSE_QI";
		public static const ADD_QI:String = "ADD_QI";
		
		
		public var params:*;
		
		public var fighter:BaseGameSprite;
		
		public function FighterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}