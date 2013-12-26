package common.data
{
import flash.utils.Dictionary;


public class Map
{
	private var map:Dictionary;
	
	private var len:int = 0;
	
	/**
	 * constructor
	 */ 
	public function Map(){
		map = new Dictionary(false);
	}
	
	/**
	 * 移除指定的键
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
	 * 移除所有的键
	 */ 
	public function removeAll():void{
		for(var key:* in map){
			map[key] = undefined;
			delete map[key];
		}
		len = 0;
	}
	
	/**
	 * 销毁该map对象
	 */ 
	public function dispose():void{
		this.removeAll();
		map = null;
	}
	
	/**
	 * 以键值形式存储至map对象中
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
	 * 根据键获取匹配值
	 */ 
	public function get(key:*):*{
		return map[key];
	}
	
	/**
	 * 检查指定的键是否存在某值与其对应
	 */ 
	public function contains(key:*):Boolean{
		return (map[key] != null) && (map[key] != undefined);
	}
	
	/**
	 * 清空存储
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
	 * 获取内部的Dictionary对象
	 */ 
	public function getInternalData():Dictionary{
		return map;
	}
	
	/**
	 * 将存储的键值形式以Object对象返回
	 */ 
	public function toObject():Object{
		var o:Object = {};
		for(var item:* in map){
			o[item] = map[item];
		}
		return o;
	}
	
	/**
	 * 将存储的键值形式以数组对象返回
	 */ 
	public function toArray():Array{
		var ary:Array = [];
		for(var item:* in map){
			ary.push(map[item]);
		}
		return ary;
	}
	
	/**
	 * 获取map长度
	 */ 
	public function getLen():int{
		return len;
	}
	
	/**
	 * 检查该map是否为空
	 */ 
	public function isEmpty():Boolean{
		return getLen() == 0;
	}
	
	/**
	 * 循环遍历map中的所有键, 退出循环条件由指定方法判定
	 * @param fun
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
	 * 循环遍历map中的所有值, 退出循环条件由指定方法判定
	 * @param fun
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
	 * 遍历所有键, 并根据传入的方法对键依次操作
	 * @param fun
	 */
	public function forEachKey(fun:Function):void{
		for(var item:* in map){
			if(item){
				fun(item);
			}
		}
	}
	
	/**
	 * 遍历所有值, 并根据传入的方法对值依次操作
	 * @param fun
	 */
	public function forEachValue(fun:Function):void{
		for each(var item:* in map){
			if(item){
				fun(item);
			}
		}
	}
	
	/**
	 * 执行对键的过滤，并对成功匹配或失败匹配的键做对应操作 
	 * @param fun   execute fun
	 * @param check filter fun
	 * @see         forEachValueWithFilter
	 */ 
	public function forEachKeyWithFilter(fun:Function, check:Function, unMatch:Function = null):void{
		for(var item:* in map){
			if(check(item)){
				if(fun != null){
					fun(item);
				}
			}
			else{
				if(unMatch != null){
					unMatch(item);
				}
			}
		}
	}
	
	/**
	 * 执行对值的过滤，并对成功匹配或失败匹配的值做对应操作 
	 * @param fun      execute fun
	 * @param check    filter  fun
	 * @param unMatch  unMatch fun
	 */ 
	public function forEachValueWithFilter(fun:Function, check:Function, unMatch:Function = null):void{
		for each(var item:* in map){
			if(check(item)){
				if(fun != null){
					fun(item);
				}
			}
			else{
				if(unMatch != null){
					unMatch(item);
				}
			}
		}
	}
	
	/**
	 * 获取对该map对象中匹配指定的值的所有键
	 * @param value
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
	 * 移除该map对象中匹配指定值的所有键
	 * @param value
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