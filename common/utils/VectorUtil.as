package common.utils 
{
import flash.display.DisplayObject;
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
	 * 利用快速排序对vector对象进行自定义排序
	 * @param	v
	 * @param	compare
	 * @param	modifyOriginal
	 * @return
	 */
	public static function sortDisplayObjects(v:Vector.<DisplayObject>, compare:Function, modifyOriginal:Boolean = true):Vector.<DisplayObject> {
		var result:Vector.<DisplayObject> = modifyOriginal ? v : v.slice();
		quickSort(result, compare, 0, result.length - 1);
		return result;
	}
	
	/**
	 * @see http://www.cprogramming.com/tutorial/computersciencetheory/quicksort.html
	 */
	private static function quickSort(v:Vector.<DisplayObject>, c:Function, s:int, e:int):void {
		var rpivot:int = (e + s) * .5;
		if (s >= e || rpivot >= e) {
			return;
		}
		var mPivot:int = createPivot(v, c, s, e, rpivot);
		quickSort(v, c, s, mPivot - 1);
		quickSort(v, c, mPivot + 1, e);
	}
	
	private static function createPivot(v:Vector.<DisplayObject>, c:Function, s:int, e:int, rpivot:int):int {
		swap(v, rpivot, e);
		var value:DisplayObject = v[e];
		for (var i:int = s; i < e; i ++) {
			if (c(v[i], value) <= 0) {
				swap(v, s++, i);
			}
		}
		swap(v, s, e);
		return s;
	}
	
	private static function swap(v:Vector.<DisplayObject>, next:int, prev:int):void {
		var temp:DisplayObject = v[next];
		v[next] = v[prev];
		v[prev] = temp;
	}
	
	/**
	 * 利用插入排序对vector对象进行自定义排序
	 * @param	v
	 * @param	compare
	 * @param	modifyOriginal
	 * @return
	 */
	public static function insertionSortDisplayObjects(v:Vector.<DisplayObject>, compare:Function, modifyOriginal:Boolean = true):Vector.<DisplayObject> {
		var result:Vector.<DisplayObject> = modifyOriginal ? v : v.slice();
		insertionSort(result, compare);
		return result;
	}
	
	private static function insertionSort(v:Vector.<DisplayObject>, c:Function):void {
		if (v.length <= 1) {
			return;
		}
		var len:int = v.length;
		var value:DisplayObject;
		var i:int, j:int;
		for (i = 1; i < len; i ++) {
			value = v[i];
			j = i - 1;
			while (j >= 0 && c(value, v[j]) <= 0) {
				swap(v, j, j + 1);
				j--;
			}
			v[j + 1] = value;
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