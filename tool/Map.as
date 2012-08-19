package tool
{
import flash.sampler.getSize;
import flash.utils.Dictionary;

/**
 * 
 * TODO
 */ 
public class Map
{
	/**
	 * use dictionary, do not use raw object (because the 'key' maybe is a as3 internal object)
	 */ 
	private var map:Dictionary;
	
	/**
	 * record the map length
	 */ 
	private var len:int = 0;
	
	/**
	 * constructor
	 */ 
	public function Map(){
		map = new Dictionary(false);
	}
	
	/**
	 * remove key from dictionary
	 */ 
	public function remove(key:*):*{
		var data:Object;
		if(contains(key)){
			len--;
			data = map[key];
			map[key] = undefined;
			delete map[key];
		}
		return data;
	}
	
	/**
	 * remove all key from dictionary
	 */ 
	public function removeAll():void{
		for(var key:* in map){
			map[key] = undefined;
			delete map[key];
		}
		len = 0;
	}
	
	/**
	 * 
	 */ 
	public function dispose():void{
		this.removeAll();
		map = null;
	}
	
	/**
	 * add "key=value" to dictionary
	 */ 
	public function add(key:*, value:*):Boolean{
		if(contains(key)){
			remove(key);
		}
		map[key] = value;
		len++;
		return true;
	}
	
	/**
	 * get value with key
	 */ 
	public function get(key:*):*{
		return map[key];
	}
	
	/**
	 * check key is whether exist
	 */ 
	public function contains(key:*):Boolean{
		return (map[key] != null) && (map[key] != undefined);
	}
	
	/**
	 * clearAllData
	 */ 
	public function clear():void{
//		for(var item:* in map){
//			map[item] = undefined;
//			delete map[item];
//		}
		len = 0;
		map = new Dictionary(false);
	}
	
	/**
	 * get internal dictionary
	 */ 
	public function getInternalData():Dictionary{
		return map;
	}
	
	/**
	 * to raw object
	 */ 
	public function toObject():Object{
		var o:Object = {};
		for(var item:* in map){
			o[item] = map[item];
		}
		return o;
	}
	
	/**
	 * to raw array
	 */ 
	public function toArray():Array{
		var ary:Array = [];
		for(var item:* in map){
			ary.push(map[item]);
		}
		return ary;
	}
	
	/**
	 * get size
	 */ 
	public function getLen():int{
		return len;
	}
	
	/**
	 * for each key is specfied function's arguments
	 */ 
	public function someKey(fun:Function):void{
		for(var item:* in map){
			if(item){
				if(Boolean(fun(item))){ //if 'void' function will return undefined;
					return;
				}
			}
		}
	}
	
	/**
	 * for each value is specfied function's arguments
	 */ 
	public function someValue(fun:Function):void{
		for each(var item:* in map){
			if(item){
				//if 'void' function will return undefined
				if(Boolean(fun(item))){
					return;
				}
			}
		}
	}
	
	/**
	 * run the specfied function and fill in the map's key
	 */ 
	public function forEachKey(fun:Function):void{
		for(var item:* in map){
			if(item){
				fun(item);
			}
		}
	}
	
	/**
	 * run the specfied function and fill in the map's value
	 */ 
	public function forEachValue(fun:Function):void{
		for each(var item:* in map){
			if(item){
				fun(item);
			}
		}
	}
	
	/**
	 * filter every element's key and run the execute fun in match item
	 * 
	 * @param fun   execute fun
	 * @param check filter fun
	 * @see         forEachValueWithFilter
	 */ 
	public function forEachKeyWithFilter(fun:Function, check:Function, unMatch:Function = null):void{
		for(var item:* in map){
			if(check(item)){
				fun(item);
			}
			else{
				if(unMatch != null){
					unMatch(item);
				}
			}
		}
	}
	
	/**
	 * filter every element's value and run the execute fun in match items
	 * 
	 * @param fun      execute fun
	 * @param check    filter  fun
	 * @param unMatch  unMatch fun
	 */ 
	public function forEachValueWithFilter(fun:Function, check:Function, unMatch:Function = null):void{
		for each(var item:* in map){
			if(check(item)){
				fun(item);
			}
			else{
				if(unMatch != null){
					unMatch(item);
				}
			}
		}
	}
	
	/**
	 * TODO
	 */ 
	public function getValueToKey(value:*):Array{
		var k:Array = [];
		for(var item:* in map){
			if(map[item] == value){
				k.push(item);
			}
		}
		return k;
	}
	
	/**
	 * TODO
	 */ 
	public function removeValue(value:*):void{
		var key:Array = getValueToKey(value);
		var len:int = key.length;
		while(--len > -1){
			remove(key[len]);
		}
	}
}
}