package common.utils
{
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ArrayUtil
{	
	/**
	 * return a unique element's array
	 * 获取指定数组中拥有唯一元素的copy (shallow copy)
	 * @param ary
	 * @return
	 */
	public static function getUnique(ary:Array):Array {
		var result:Array = [];
		var len:int = ary.length;
		for (var i:int = 0; i < len; i ++) {
			if(result.lastIndexOf(ary[i]) == -1){
				result.push(ary[i]);
			}
		}
		return result;
	}
	
	/**
	 * 根据指定的prop属性名过滤ary已使返回的数组中包含唯一的对象
	 */ 
	public static function removeSameElement(ary:Array, prop:String):Array{
		var result:Array = [], len:int = ary.length, d:*, value:*
		for (var i:int = 0; i < len; i ++) {
			d = ary[i];
			if(d){
				value = d[prop];
				if(__checkNotContain(result, prop, value)){
					result.push(d);
				}
			}
		}
		return result;
	}
	
	private static function __checkNotContain(ary:Array, prop:String, value:*):Boolean{
		return ary.every(function(data:Object, ...args):Boolean{
			return data.hasOwnProperty(prop) && data[prop] != value;
		});
	}
	
//	public static function removeSameElement(ary:Array):Array{
//		return ary.filter(function(d:*, ...args):Boolean{
//			return args[0] == 0 ? true : args[1].lastIndexOf(d, args[0] - 1) == -1;
//		});
//	}
	
	/**
	 * check two array has same value
	 * @param aryA
	 * @param aryB
	 * 检查指定2数组拥有元素是否相同
	 */ 
	public static function checkSame(aryA:Array, aryB:Array):Boolean{
		if(!(aryA && aryB)){
			return false;
		}
		if(aryA.length != aryB.length){
			return false;
		}
		var len:int = aryA.length;
		for(var i:int = 0; i < len; i ++){
			if(aryA[i] !== aryB[i]){
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 将指定对象的键存入数组并返回
	 * @param o
	 * @return
	 */
	public static function toKeyAry(o:Object):Array {
		var ary:Array = [];
		for (var item:* in o) {
			ary.push(item);
		}
		return ary;
	}
	
	/**
	 * 将指定对象的值存入数组并返回
	 * @param o
	 * @return
	 */ 
	public static function toValueAry(o:Object):Array{
		var ary:Array = [];
		for each(var item:* in o) {
			ary.push(item);
		}
		return ary;
	}
	
	
	/**
	 * covert array to vector
	 * 将指定的数组转化为Vector, 该Vector类型参照该数组中的一个元素的类型
	 * @param ary 
	 */ 
	public static function toVector(ary:Array):*{
		if((!ary) || (ary && ary.length == 0)){
			return null;
		}
		var type:Class = getDefinitionByName(getQualifiedClassName(ary[0])) as Class;
		var vector:String = getQualifiedClassName(Vector);
		var combine:String = vector　+ ".<" + getQualifiedClassName(type) + ">";
		var typeClass:Class = getDefinitionByName(combine) as Class;
		var t:* = new typeClass();
		var len:int = ary.length;
		for(var i:int = 0; i < len; i ++){
			t.push(ary[i]);
		}
		return t;
	}
	
	/**
	 * 返回指定数组的copy版本 （deep copy）
	 */ 
    public static function deepClone(source:Array):Array{
		var myBA:ByteArray = new ByteArray(); 
		myBA.writeObject(source); 
		myBA.position = 0; 
		return myBA.readObject() as Array; 
	}
	
	/**
	 * @param source             original array
	 * @param desireRemoveable   
	 */ 
	public static function updateByRemove(source:Array, desireRemoveable:Array):void{
		var i:int;
		desireRemoveable.forEach(function(d:*, ...args):void{
			i = source.lastIndexOf(d);
			while(i != -1){
				source.splice(i, 1);
				i = source.lastIndexOf(d);
			}
		});
	}
	
	/**
	 * 
	 * 
	 *  @param ary
	 *  @param data
	 */ 
	public static function obtainIndex(ary:Array, data:Object, prop:String):int{
		var index:int = -1;
		if(ary.length > 0){
			ary.some(function(d:Object, ...args):Boolean{
				if(d[prop] == data[prop]){
					index = args[0];
					return true;
				}
				return false;
			});
		}
		return index;
	}
}
}