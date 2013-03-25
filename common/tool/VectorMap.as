package common.tool
{
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
	

public class VectorMap
{
	protected static const VECTOR:String = getQualifiedClassName(Vector);
	protected var record:Dictionary = new Dictionary();
	protected var vector:*;
	
	/**
	 * 根据传入的对象类型, 创建该类型的VectorMap对象 
	 * @param type
	 */
	public function VectorMap(type:Class)
	{
		var e:String = VECTOR　+ ".<" + getQualifiedClassName(type) + ">";
		var typeClass:Class = getDefinitionByName(e) as Class;
		vector = new typeClass();
		objectType = type;
	}
	
	private var objectType:Class;
	/**
	 * 获取Class类型
	 * @return 
	 */
	public function getType():Class{
		return objectType;
	}
	
	/**
	 * 判定指定对象是否存在该map中
	 * @param item
	 * @return 
	 */
	public function contain(item:*):Boolean{
		return Boolean(item in record);
	}
	
	/**
	 * 判断在该map中的对象的属性值是否为给定的值
	 * @param property
	 * @param value
	 * @return 
	 */
	public function containSpecfiedValue(property:*, value:*):Boolean{
		for(var item:* in record){
			if(item[property] == value){
				return true;
			}
		}
		return false;
	}

	/**
	 * 获取该map的长度
	 * @return 
	 */
	public function getLen():int{
		return vector.length;
	}
	
	/**
	 * 清除该map中的所有对象 
	 */
	public function removeAll():void{
		vector.length = 0;
		record = new Dictionary();
	}
	
	/**
	 * 检查该map中是否不存在对象
	 * @return 
	 */
	public function isEmpty():Boolean{
		return vector.length == 0;
	}
	
	/**
	 * 添加一个指定类型的对象
	 * @param item
	 */
	public function add(item:*):void{
		if(contain(item)){
			remove(item);
		}
		record[item] = vector.push(item) - 1;
	}
	
	/**
	 * @param args
	 * @see add
	 */
	public function addAll(...args):void{
		var len:int = args.length, i:int;
		for(i = 0; i < len; i ++){
			add(args[i]);
		}
	}

	/**
	 * 移除一个指定的对象
	 * @param item
	 */
	public function remove(item:*):void{
		if(contain(item)){
			var c:* = vector.pop();
			if(c != item){
				var p:int = record[item];
				vector[p] = c;
				record[c] = p;
			}
			record[item] = undefined;
			delete record[item];
		}
	}
	
	/**
	 * 获取指定对象的索引
	 * @param item
	 * @return 
	 */
	public function getIndex(item:*):int{
		if(contain(item)){
			return record[item];
		}
		return -1;
	}
	
	/**
	 * 获取位于指定索引的对象
	 * @param index
	 * @return 
	 */
	public function getContent(index:int):*{
		var value:*;
		try{
			value = this.vector[index];
		}
		catch(e:RangeError){
			
		}
		return value;
	}
	
	/**
	 * 获取内部的vector对象
	 */ 
	public function getVector():*{
		return this.vector;
	}
	
	/**
	 * 顺序遍历结构中的每一个对象并执行给定的方法
	 * @param execute
	 */
	public function forEach(execute:Function):void{
		if(getLen() > 0){
			var c:* = this.vector.concat();
			c.forEach(function(item:*, ...args):void{
				execute(item);
			});
		}
	}
	
	/**
	 * @param listenerName
	 * @param args
	 * @see forEach
	 */
	public function map(listenerName:String, ...args):void{
		if(getLen() > 0){
			var c:* = this.vector.concat();
			c.forEach(function(item:*, ...args):void{
				if(Object(item).hasOwnProperty(listenerName)){
					item[listenerName].apply(item, args);
				}
			});
		}
	}
}
}
