package common.tool.gc
{
import flash.utils.Dictionary;

/**
 * this class inspiration from gskinner.com
 * @see wwww.gskinner.com
 * 
 * 用于测试对象是否被顺利gc
 */ 
public class WeakMap
{
	private var weakConfig:Dictionary;
	
	public function WeakMap():void{
		weakConfig = new Dictionary(false);
	}
	
	/**
	 * key is just a marker, and value is weak value
	 * @param key
	 * @param value
	 * @see flash.utils.Dictionary
	 */
	public function addWeak(key:*, value:*):void{
		if(!(key in weakConfig)){
			weakConfig[key] = new Weak(value);
		}
	}
	
	/**
	 * remove specfied key-value pair
	 * @param key
	 */
	public function removeWeak(key:*):void{
		if(key in weakConfig){
			weakConfig[key] = undefined;
			delete weakConfig[key];
		}
	}
	
	/**
	 * record weakMap's key-value pair count
	 * @return 
	 */
	public function sumAvailable():int{
		var count:int = 0;
		for(var item:* in weakConfig){
			if(weakConfig[item].contain()){
				count++;
			}
		}
		return count;
	}
	
	/**
	 * iterate weakMap and delete the record value has been gc's key
	 */
	public function refresh():void{
		for(var item:* in weakConfig){
			if(!(weakConfig[item].contain())){
				weakConfig[item] = undefined;
				delete weakConfig[item];
			}
		}
	}
}
}

import flash.utils.Dictionary;

internal class Weak
{
	private var map:Dictionary = new Dictionary(true);
	
	public function Weak(key:*):void{
		map[key] = true;
	}
	
	/**
	 * get the weak value
	 * @return 
	 */
	public function get():*{
		for(var item:* in map){
			return item;
		}
		return null;
	}
	
	/**
	 * check is whether contain
	 * @return 
	 */
	public function contain():Boolean{
		return get() != null;
	}
	
}