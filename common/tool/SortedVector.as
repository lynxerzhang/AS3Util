package common.tool
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * 保持数组中对象的顺序
 * @see http://jacksondunstan.com/articles/1848
 * 
 * @example
 * 	var list:SortedVector = new SortedVector(int);
 * 	list.add(2);
 * 	list.add(20);
 * 	list.add(-5);
 * 	//....
 * 	trace(list.getResult()); //-5, 2, 20
 */
public class SortedVector 
{
	protected static const VECTOR:String = getQualifiedClassName(Vector);
	
	/**
	 * 
	 * @param	type		数组中存储的对象类型
	 * @param	compareFun	比较2个对象的方法, 以此判断数组中对象顺序	
	 */
	public function SortedVector(type:Class, compareFun:Function = null) 
	{
		var className:String = VECTOR + ".<" + getQualifiedClassName(type) + ">";
		elementType = getDefinitionByName(className) as Class;
		if (compareFun == null) {
			compareFun = function(a:Number, b:Number):Number {
				return a - b;
			}
		}
		compare = compareFun;
		vectList = new elementType();
		classType = type;
	}
	
	protected var vectList:*;
	protected var classType:Class;
	protected var elementType:Class;
	
	private var leftIndex:int = 0;
	private var rightIndex:int = 0;
	private var findIndex:int = -1;
	private var compare:Function;
	
	/**
	 * 获取指定对象在数组中的索引
	 * @param	obj
	 * @return
	 */
	public function getIndex(obj:*):int
	{
		leftIndex = 0;
		rightIndex = vectList.length - 1;
		findIndex = -1;
		if (rightIndex >= leftIndex) { 
			var middleIndex:int;
			var compareValue:Number;
			var element:*;
			while (rightIndex >= leftIndex) {
				middleIndex = int((rightIndex + leftIndex) * .5);
				element = vectList[middleIndex];
				compareValue = compare(element, obj);
				if (compareValue < 0) {
					leftIndex = middleIndex + 1;
				}
				else if (compareValue > 0) {
					rightIndex = middleIndex - 1;
				}
				else {
					findIndex = middleIndex;
					break;
				}
			}
		}
		return findIndex;
	}
	
	/**
	 * 添加指定对象至数组中
	 * @param	obj
	 */
	public function add(obj:*):void 
	{
		var index:int = getIndex(obj);
		if (index != -1) {
			if (index + 1 == vectList.length) {
				vectList.push(obj);
			}
			else {
				vectList.splice(index + 1, 0, obj);
			}
		}
		else {
			if (leftIndex == 0) {
				vectList.unshift(obj);
			}
			else {
				if (leftIndex == vectList.length) {
					vectList.push(obj);
				}
				else {
					vectList.splice(leftIndex, 0, obj);
				}
			}
		}
	}
	
	/**
	 * 根据指定索引获取对象
	 * @param	index
	 * @return
	 */
	public function getObj(index:int):*
	{
		var obj:* = null;
		if (index >= 0 && index < vectList.length) {
			obj = vectList[index];
		}
		return obj;
	}
	
	/**
	 * 根据指定索引移除对象
	 * @param	index
	 * @return
	 */
	public function removeIndex(index:int):*
	{
		var obj:* = getObj(index);
		if (obj != null) {
			remove(obj);
		}
		return obj;
	}
	
	/**
	 * 移除指定对象
	 * @param	obj
	 * @return
	 */
	public function remove(obj):*
	{
		var index:int = getIndex(obj);
		if (index != -1) {
			vectList.splice(index, 1);
		}
	}
	
	/**
	 * 检查是否存在某个指定对象
	 * @param	obj
	 * @return
	 */
	public function contain(obj:*):Boolean 
	{
		return getIndex(obj) != -1;
	}
	
	/**
	 * 添加多个对象
	 * @param	...args
	 */
	public function addGroup(...args):void
	{
		if (args.length == 1 && args[0] is Array) {
			args = args[0];
		}
		var len:int = args.length;
		for (var i:int = 0; i < len; i ++) {
			add(args[i]);
		}
	}
	
	/**
	 * 获取该数组中所有对象
	 * @param	result
	 * @return
	 */
	public function getResult(result:* = null):*
	{
		if (result == null) {
			result = new elementType();
		}
		else {
			result.length = 0;
		}
		var len:int = vectList.length;
		for (var i:int = 0; i < len; i ++) {
			result.push(vectList[i]);
		}
		return result;
	}
}
}