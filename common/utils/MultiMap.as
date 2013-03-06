package common.utils
{
import flash.utils.Dictionary;
/**
 * 
 */ 
public class MultiMap
{
	public function MultiMap(weakKeys:Boolean = false)
	{
		map = new Dictionary(weakKeys);
	}
	
	private var map:Dictionary;

	/**
	 * @param key
	 * @param valueArgs
	 */ 
	public function addPairs(key:*, ...valueArgs):void{
		if(!map[key]){
			map[key] = new Dictionary();
		}
		var d:Dictionary = map[key];
		for each(var item:* in valueArgs){
			d[item] = true;
		}
	}
	
	/**
	 * @param key
	 * @param value
	 */
	public function addPair(key:*, value:*):void{
		if(!map[key]){
			map[key] = new Dictionary();
		}
		map[key][value] = true;
	}
	
	/**
	 * @param pair
	 */ 
	public function addRawPair(pair:Object):void{
		for(var item:* in pair){
			if(!map[item]){
				map[item] = new Dictionary();
			}
			map[item][pair[item]] = true;
		}
	}
	
	/**
	 * @param key
	 */ 
	public function getKey(key:*):Dictionary{
		return map[key];
	}
	
	/**
	 * @param key
	 */ 
	public function containKey(key:*):Boolean{
		return map[key] != undefined;
	}
	
	/**
	 * @param value
	 */ 
	public function containValue(value:*):Boolean{
		for(var item:* in map){
			if(value in map[item]){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @param value
	 */  
	public function getMatchKey(value:*):Array{
		var k:Array = [];
		for(var item:* in map){
			if(value in map[item]){
				k.push(item);
			}
		}
		return k;
	}
	
	/**
	 * @param key
	 * @param value
	 */ 
	public function containKeyValue(key:*, value:*):Boolean{
		 var d:Dictionary = map[key];
		 if(!d){
			 return false;
		 }
		 return d[value];
	}
	
	/**
	 * @param key
	 */ 
	public function removeKey(key:*):void{
		if(containKey(key)){
			delete map[key];
		}
	}
	
	/**
	 * @param key
	 * @param value
	 */ 
	public function removePairValue(key:*, value:*):void{
		if(containKey(key)){
			delete map[key][value];
		}
	}
	
	/**
	 * @param key
	 */ 
	public function isEmptyKey(key:*):Boolean{
		if(containKey(key)){
			for(var i:* in map[key]){
				return false;
			}
			return true;
		}
		return false;
	}
	
	/**
	 * @param value
	 */ 
	public function removeValue(value:*):void{
		var d:Dictionary, item:*;
		for(item in map){
			d = map[item];
			delete d[value];	
		}
	}
	
	/**
	 *  
	 */
	public function removeAll():void{
		for(var item:* in map){
			delete map[item];
		}
	}
}
}