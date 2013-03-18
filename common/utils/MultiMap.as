package common.utils
{
import flash.utils.Dictionary;

/**
 * 以一对多形式存储数据
 */ 
public class MultiMap
{
	/**
	 * @param weakKeys 是否为弱引用, 如果为复杂数据对象, 
	 * 诸如flash的Sprite,MovieClip,或者自定义类,弱引用能
	 * 够正常工作, 但是如果键为简单类型(Boolean,String,Number)
	 * 则不存在自动移除的可能, 需要使用delete自行删除
	 */ 
	public function MultiMap(weakKeys:Boolean = false)
	{
		configMap = new Dictionary(isWeak = weakKeys);
	}
	
	private var configMap:Dictionary;
	private var isWeak:Boolean;
	
	/**
	 * 将指定的键和值，以一对多的形式存入该结构中
	 * @param key
	 * @param valueArgs
	 */ 
	public function addPairs(key:*, ...valueArgs):void{
		if(!configMap[key]){
			configMap[key] = new Dictionary();
		}
		var d:Dictionary = configMap[key];
		if(valueArgs[0] is Array && valueArgs.length == 1){
			var k:Array = valueArgs[0] as Array;
			var len:int = k.length, i:int;
			for(i = 0; i < len; i ++){
				d[k[i]] = true;
			}
		}
		else{
			for each(var item:* in valueArgs){
				d[item] = true;
			}
		}
	}
	
	
	/**
	 * 将指定的键值存入该结构
	 * @param key   
	 * @param value
	 */ 
	public function addPair(key:*, value:*):void{
		if(!configMap[key]){
			configMap[key] = new Dictionary();
		}
		configMap[key][value] = true;
	}
	
	/**
	 * 将指定的原始Object对象存入该结构中
	 * @param pair
	 * @example
	 * var data:Object = {"name":abc, "country":xyz};
	 * addRawPair(data);
	 */ 
	public function addRawPair(pair:Object):void{
		for(var item:* in pair){
			if(!configMap[item]){
				configMap[item] = new Dictionary();
			}
			configMap[item][pair[item]] = true;
		}
	}
	
	/**
	 * 将匹配指定键的Dictionary对象返回
	 * @param key
	 */ 
	public function getKey(key:*):Dictionary{
		return configMap[key];
	}
	
	/**
	 * 检查指定键是否存在
	 * @param key
	 */ 
	public function containKey(key:*):Boolean{
		return configMap[key] != undefined;
	}
	
	/**
	 * 检查是否有指定值在任意的键结构中
	 * @param value
	 */ 
	public function containValue(value:*):Boolean{
		for(var item:* in configMap){
			if(value in configMap[item]){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 将匹配指定值的对应键以数组形式返回
	 * @param value
	 */ 
	public function getMatchKey(value:*):Array{
		var k:Array = [];
		for(var item:* in configMap){
			if(value in configMap[item]){
				k.push(item);
			}
		}
		return k;
	}
	
	/**
	 * 返回配置指定值的键
	 * @param value 指定值
	 * @see getMatchKey 如果不同的键存在相同的值对, 返回所有匹配指定值的键名
	 */ 
	public function getMatchValueKey(value:*):*{
		for(var item:* in configMap){
			if(value in configMap[item]){
				return item;
			}
		}
		return null;
	}
	
	/**
	 * 以数组形式返回所有键的名称
	 */ 
	public function getKeysName():Array{
		var k:Array = [];
		for(var item:* in configMap){
			k.push(item);
		}
		return k;
	}
	
	/**
	 * 检查指定的键是否存储有指定的值
	 * @param key
	 * @param value
	 */ 
	public function containKeyValue(key:*, value:*):Boolean{
		 var d:Dictionary = configMap[key];
		 if(!d){
			 return false;
		 }
		 return d[value];
	}
	
	/**
	 * 清除指定的键, 所连带的value值对也全部删去
	 * @param key
	 */ 
	public function removeKey(key:*):void{
		if(containKey(key)){
			delete configMap[key];
		}
	}
	
	/**
	 * 清除指定的键和值
	 * @param key
	 * @param value
	 */ 
	public function removePairValue(key:*, value:*):void{
		if(containKey(key)){
			delete configMap[key][value];
			if(isWeak && isEmptyKey(key)){
				delete configMap[key];
			}
		}
	}
	
	/**
	 * 查看指定键是否存在并为空
	 * @param key 
	 */ 
	public function isEmptyKey(key:*):Boolean{
		if(containKey(key)){
			for(var i:* in configMap[key]){
				return false;
			}
			return true;
		}
		return false;
	}
	
	/**
	 * 清除指定所有存储键中的指定值
	 * @param value 需要删除的值
	 */ 
	public function removeValue(value:*):void{
		var d:Dictionary, item:*;
		for(item in configMap){
			d = configMap[item];
			delete d[value];
			if(isWeak && isEmptyKey(item)){
				delete configMap[item];
			}
		}
	}
	
	/**
	 * 清除所有键值对
	 */ 
	public function removeAll():void{
		for(var item:* in configMap){
			delete configMap[item];
		}
	}
	
	
	/**
	 * 返回结构中的键值对的字符串形式
	 */ 
	public function toString():String{
		var s:String = "[MultiMap Object]";
		s += "\n";
		s += "{" + "\n";
		var keys:Array = getKeysName(), k:Array = [], len:int = keys.length, i:int, item:String;
		for(i = 0; i < len; i ++){
			item = keys[i];
			s += "\t" + String(item) + ":" + "---->";
			for(var value:* in configMap[item]){
				k.push(String(value));
			}
			s += k.join(",");
			if(i != len - 1){
				s += "\n";
			}
			k.length = 0;
		}
		s += "\n" + "}";
		return s;
	}
}
}
