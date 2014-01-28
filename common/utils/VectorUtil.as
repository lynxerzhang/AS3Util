package common.utils 
{
import flash.errors.IllegalOperationError;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class VectorUtil 
{
	public function VectorUtil() 
	{
	}
	
	/**
	 * 将vector类型转化为数组形式
	 * @param	vec
	 * @return
	 */
	public static function toArray(vec:*):Array {
		if (!(vec is Vector.<*> || vec is Vector.<int> || vec is Vector.<uint> || vec is Vector.<Number>)) {
			throw new IllegalOperationError("VectorUtil.toArray's method parameter 'vec' is not a vector");
		}
		var len:int = vec.length;
		var result:Array = [];
		for (var i:int = 0; i < len; i ++) {
			result[i] = vec[i];
		}
		return result;
	}
	
	/**
	 * 利用合并排序对vector对象进行自定义排序
	 * @param	vect					vector实例
	 * @param	type					vector类型
	 * @param	compareFun				自定义排序方法
	 * @param	modifyOriginalOrder		是否修改原始vector
	 * @return
	 */
	public static function sort(vect:*, type:Class, compareFun:Function, modifyOriginalOrder:Boolean = true):*{
		var tempResult:* = createVectorByType(type);
		tempResult.length = vect.length;
		var result:* = modifyOriginalOrder ? vect : vect.slice();
		mergeSort(0, vect.length, compareFun, tempResult, result);
		return result;
	}
	
	/**
	 * @see	http://www.cprogramming.com/tutorial/computersciencetheory/mergesort.html
	 */
	private static function mergeSort(s:int, e:int, c:Function, t:*, r:*):void {
		if (e == s + 1) {
			return;
		}
		var len:int = e - s;
		var middleIndex:int = len * .5;
		var leftLoopIndex:int = s;
		var rightLoopIndex:int = s + middleIndex;
		mergeSort(s, s + middleIndex, c, t, r);
		mergeSort(s + middleIndex, e, c, t, r);
		for (var i:int = 0; i < len; i ++) {
			if ((leftLoopIndex < s + middleIndex) && ((rightLoopIndex == e) || (c(r[leftLoopIndex], r[rightLoopIndex]) <= 0))) {
				t[i] = r[leftLoopIndex];
				leftLoopIndex++;
			}
			else {
				t[i] = r[rightLoopIndex];
				rightLoopIndex++;
			}
		}
		for (i = s; i < e; i ++) {
			r[i] = t[i - s];
		}
	}
	
	/**
	 * 类似于数组的sortOn方法, Vector暂未提供sortOn方法
	 * @param	vec				vector实例
	 * @param	type			vector类型
	 * @param	fieldName		属性名	
	 * @param	options			Array的排序静态常量组合
	 * @see		Array.sortOn
	 * @return
	 */
	public static function sortOn(vec:*, type:Class, fieldName:Object, options:Object = null):* {
		var k:Array = toArray(vec);
		var result:* = vec;
		var isReturnIndex:Boolean = false;
		var i:int, len:int;
		if (options) {
			if (isNaN(Number(options))) {
				if (options is Array) {
					isReturnIndex = (options as Array).some(function(value:uint, ...args):Boolean {
						return (value & Array.RETURNINDEXEDARRAY) != 0;
					});
				}
			}
			else {
				if ((uint(options) & Array.RETURNINDEXEDARRAY) != 0) {
					isReturnIndex = true;
				}
			}
		}
		k = k.sortOn(fieldName, options);
		if (isReturnIndex) {
			result = createVectorByType(type);
			for (i = 0, len = k.length; i < len; i ++) {
				result[i] = vec[k[i]];	
			}
		}
		else {
			for (i = 0, len = k.length; i < len; i ++) {
				result[i] = k[i];
			}
		}
		return result;
	}
	
	private static const SIGN:String = getQualifiedClassName(Vector);
	
	private static function createVectorByType(cls:Class):*{
		var type:String = SIGN + ".<" + getQualifiedClassName(cls) + ">";
		var typeCls:Class = getDefinitionByName(type) as Class;
		return new typeCls();
	}
}
}