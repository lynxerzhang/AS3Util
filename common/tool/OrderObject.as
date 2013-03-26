package common.tool
{
import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
 * 顺序存储指定键值对象
 */
dynamic public class OrderObject extends Proxy
{
	private var keyValueMap:Object;
	private var keyIndexSearch:Array;
	
	public function OrderObject(keyValue:Array = null)
	{
		initFill(keyValue);
	}
	
	private function initFill(k:Array):void{
		keyValueMap = {};
		keyIndexSearch = [];
		insert(k);
	}
	
	/**
	 * 直接插入键值数组
	 * @param	k
	 */
	public function insert(k:Array):void{
		if(k){
			var len:int = k.length;
			for(var i:int = 0; i < len - 1; i += 2){
				keyIndexSearch.push(k[i]);
				keyValueMap[k[i]] = k[i + 1];
			}
		}
	}
	
	/**
	 * 删除指定属性, delete 操作符
	 * @param	name
	 * @return
	 */
	override flash_proxy function deleteProperty(name:*):Boolean{
		if(keyValueMap[name.localName]){
			delete keyValueMap[name.localName];
			keyIndexSearch.splice(keyIndexSearch.indexOf(name.localName), 1);
			return true;
		}
		return false;
	}
	
	/**
	 * 获取指定属性
	 * @param	name
	 * @return
	 */
	override flash_proxy function getProperty(name:*):*{
		return keyValueMap[name.localName];
	}
	
	/**
	 * 返回是否存在指定键, 'in'操作符
	 * @param	name
	 * @return
	 */
	override flash_proxy function hasProperty(name:*):Boolean{
		return name in keyValueMap;
	}
	
	/**
	 * 设置对应键值
	 * @param	name
	 * @param	value
	 */
	override flash_proxy function setProperty(name:*, value:*):void{
		if(keyValueMap[name.localName]){
			keyValueMap[name.localName] = value;
		}
		else{
			keyValueMap[name.localName] = value;
			keyIndexSearch.push(name.localName);
		}
	}
	
	/**
	 * for...in迭代
	 * @param	index
	 * @return
	 */
	override flash_proxy function nextName(index:int):String{
		return keyIndexSearch[index - 1];
	}
	
	/**
	 * for...in迭代
	 * @param	index
	 * @return
	 */
	override flash_proxy function nextNameIndex(index:int):int{
		if(index >= keyIndexSearch.length){
			return 0;
		}
		return index + 1;
	}
	
	/**
	 * for each 遍历
	 * @param	index
	 * @return
	 */
	override flash_proxy function nextValue(index:int):*{
		return keyValueMap[keyIndexSearch[index - 1]]; 
	}
	
	/**
	 * 获取长度
	 */
	public function get length():int{
		return keyIndexSearch.length;
	}
	
	/**
	 * 设置长度
	 */
	public function set length(val:int):void{
		keyIndexSearch.length = val;
		for(var item:* in keyValueMap){
			if(keyIndexSearch.indexOf(item) == -1){
				delete keyValueMap[item];
			}
		}
	}
	
	/**
	 * toString
	 * @return
	 */
	public function toString():String{
		var len:int = keyIndexSearch.length;
		var s:String = "OrderObject_start -->" + "\n";
		for(var i:int = 0; i < len; i ++){
			s += "\t" + "key:" + keyIndexSearch[i] + "->" + "value:" + keyValueMap[keyIndexSearch[i]] + "\n";
		}
		s += "OrderObject_end -->";
		return s;
	}
}
}