package	common.tool
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * 最大二叉堆
 * 
 * @example
 * var dst:BinaryMaxHeap = new BinaryMaxHeap(int);
 * dst.insert(4); 
 * dst.insert(1); 
 * dst.insert(3);
 * dst.insert(2);
 * dst.insert(16);
 * 
 * dst.remove(16);
 * dst.shift();
 * trace(dst);//BinaryHeap{3, 2, 1}
 */
public class BinaryMaxHeap
{
	protected static const VECTOR:String = getQualifiedClassName(Vector);
	
	private var compare:Function;
	private var vectList:*;
	private var elementType:Class;
	
	public function BinaryMaxHeap(type:Class, vector:* = null, compareFun:Function = null) 
	{
		if (compareFun == null) {
			compareFun = function(a:Number, b:Number):Number {
				return a - b;
			}
		}
		var className:String = VECTOR + ".<" + getQualifiedClassName(type) + ">";
		elementType = getDefinitionByName(className) as Class;
		if (vector) {
			vectList = vector;
		}
		else {
			vectList = new elementType();
		}
		compare = compareFun;
	}
	
	/**
	 * 将指定的vector类型数组转换为BinaryHeap对象
	 * @param	vector
	 * @param	type
	 * @param	compareFun
	 * @return
	 */
	public static function createHeap(vector:*, type:Class, compareFun:Function = null):BinaryMaxHeap
	{
		if (!vector) {
			return null;
		}
		var len:int = vector.length;
		var heap:BinaryMaxHeap = new BinaryMaxHeap(type, vector, compareFun);
		if (len > 0) {
			var endLeafIndex:int = int(len * .5);
			while (endLeafIndex) {
				heap.heapSort(vector, endLeafIndex--);
			}
		}
		return heap;
	}
	
	private var left:int;
	private var right:int;
	private var current:int;
	private var heapLen:int;
	
	private function heapSort(list:*, index:int):void
	{
		left = index << 1;
		right = left + 1;
		heapLen = list.length;
		current = index;
		if (heapLen >= left) {
			if (compare(list[int(left - 1)], list[int(current - 1)]) > 0) {
				current = left;
			}
		}
		if (heapLen >= right) {
			if (compare(list[int(right - 1)], list[int(current - 1)]) > 0) {
				current = right;
			}
		}
		if (current != index) {
			var temp:* = list[int(index - 1)];
			list[int(index - 1)] = list[int(current - 1)];
			list[int(current - 1)] = temp;
			heapSort(list, current);
		}
	}
	
	/**
	 * 获取堆内部vector数组长度
	 * @return
	 */
	public function getSize():int
	{
		return vectList.length;
	}
	
	/**
	 * 判断是否存在指定对象
	 * @param	obj
	 * @return
	 */
	public function contain(obj:*):Boolean
	{
		return vectList.indexOf(obj) > -1;
	}
	
	/**
	 * 获取第一个对象
	 * @return
	 */
	public function peek():*
	{
		return vectList[0];
	}
	
	/**
	 * 填入对象
	 * @param	obj
	 */
	public function insert(obj:*):void
	{
		vectList.push(obj);
		var end:int = vectList.length;
		var index:int = end;
		var tmp:* = null;
		while (index > 1) {
			index >>= 1;
			if (compare(obj, vectList[int(index - 1)]) > 0) {
				tmp = vectList[int(index - 1)];
				vectList[int(index - 1)] = vectList[int(end - 1)];
				vectList[int(end - 1)] = tmp;
			}
			else {
				break;
			}
			end = index;
		}
	}
	
	/**
	 * 删除头对象并返回
	 * @param	obj
	 * @return
	 */
	public function shift():*
	{
		var data:* = null;
		var count:int = vectList.length;
		if (count > 0) {
			data = vectList[0];
			vectList[0] = vectList[int(count - 1)];
			vectList.length -= 1;
			count = vectList.length;
			if (count > 1) {
				var left:int;
				var right:int;
				var parent:int = 1;
				var max:int;
				var tmp:* = null;
				var endLeaf:int = int(count * .5);
				while (parent <= endLeaf) {
					left = parent << 1;
					if (left <= count - 1) {
						right = left + 1;
						if (compare(vectList[int(left - 1)], vectList[int(right - 1)]) >= 0) {
							max = left;
						}
						else {
							max = right;
						}
					}
					else {
						max = left;
					}
					if (compare(vectList[int(max - 1)], vectList[int(parent - 1)]) > 0) {
						tmp = vectList[int(parent - 1)];
						vectList[int(parent - 1)] = vectList[int(max - 1)];
						vectList[int(max - 1)] = tmp;
					}
					else {
						break;
					}
					parent = max;
				}
			}
		}
		return data;
	}
	
	/**
	 * 移除指定对象
	 * @param	obj
	 */
	public function remove(obj:*):*
	{
		var find:int = vectList.indexOf(obj);
		var data:* = null;
		if (find > -1) {
			var count:int = vectList.length;
			data = vectList[find];
			vectList[find] = vectList[--count];
			vectList.length -= 1;
			count = vectList.length;
			if (count > 1) {
				var endLeaf:int = int(count * .5);
				var tmp:* = null;
				var c:* = vectList[find];
				if (find + 1 > endLeaf) {
					//处于叶节点(检查父级)
					var index:int = count;
					while (index > 1) {
						index >>= 1;
						if (compare(c, vectList[int(index - 1)]) > 0) {
							tmp = vectList[int(index - 1)];
							vectList[int(index - 1)] = vectList[int(count - 1)];
							vectList[int(count - 1)] = tmp;
						}
						else {
							break;
						}
						count = index;
					}
				}
				else {
					//父节点含有叶节点(检查子级)
					var left:int;
					var right:int;
					var parent:int = find + 1;
					var max:int;
					while (parent <= endLeaf) {
						left = parent << 1;
						if (left < count - 1) {
							right = left + 1;
							if (compare(vectList[int(left - 1)], vectList[int(right - 1)]) >= 0) {
								max = left;
							}
							else {
								max = right;
							}
						}
						else {
							max = left;
						}
						if (compare(vectList[int(max - 1)], vectList[int(parent - 1)]) > 0) {
							tmp = vectList[int(parent - 1)];
							vectList[int(parent - 1)] = vectList[int(max - 1)];
							vectList[int(max - 1)] = tmp;
						}
						else {
							break;
						}
						parent = max;
					}
				}
			}
		}
		return data;
	}
	
	/**
	 * 复制堆内部vector数组
	 * @return
	 */
	public function cloneData(result:* = null):*
	{
		if (result == null) {
			result = new elementType();
		}
		result.length = vectList.length;
		var len:int = vectList.length;
		for (var i:int = 0; i < len; i ++) {
			result[i] = vectList[i];
		}
		return result;
	}
	
	/**
	 * 清除堆内部所有数据
	 */
	public function clear():void
	{
		vectList.length = 0;
	}
	
	/**
	 * 
	 * @return
	 */
	public function toString():String
	{
		var heap:String = "BinaryHeap{";
		var len:int = vectList.length;
		if (len > 0) {
			if (len > 1) {
				for (var i:int = 0; i < len - 1; i ++) {
					heap += vectList[i] + ", ";
				}	
			}
			heap += vectList[i];	
		}
		heap += "}";
		return heap;
	}
}
}