package common.tool
{
import flash.utils.Dictionary;
/**
 * 
 * 该类的dispatch方法参考Starling框架的Juggler动画管理类对存储在内部数组的对象的动态管理
 * @example
 * 
 * var s:Slot = new Slot;
 * s.add(test1);
 * s.add(test2);
 * s.add(test3);
 * ... ...
 * function test2():void{
 *     s.remove(test3); //直接在播报中删除test3, test3方法将不再被执行
 * 	   s.add(test4);    //该方法为新添加, 所以本轮的播报不会触发, 需要在下一次的
 * 						//dispatch中触发
 * }
 * s.dispatch();
 */ 
public class Slot
{
	public function Slot()
	{
	}
	
	private var onceCheck:Dictionary = new Dictionary(false);
	private var base:Vector.<Function> = new <Function>[];
	private var count:int = 0;
	private var slotPool:Array = [];
	
	/**
	 * 添加一个指定方法
	 * @param	fun            
	 * @param	executeOnce
	 */
	public function add(fun:Function, executeOnce:Boolean = false):void{
		if (!contain(fun)) {
			var n:Node;
			if (slotPool.length > 0) {
				n = slotPool.pop();
				n.executeOnce = executeOnce;
				n.index = base.push(n) - 1;
			}
			else {
				n = new Node(executeOnce, base.push(fun) - 1);
			}
			onceCheck[fun] = n;
			count++;
		}
	}
	
	/**
	 * 移除一个指定方法
	 * @param	fun
	 */
	public function remove(fun:Function):void{
		if(contain(fun)){
			var node:Node = onceCheck[fun];
			base[node.index] = null;
			delete onceCheck[fun];
			count--;
			slotPool.push(node);
		}
	}
	
	/**
	 * 检查是否存在指定方法
	 * @param	fun
	 * @return
	 */
	public function contain(fun:Function):Boolean{
		return fun in onceCheck;
	}
	
	/**
	 * 获取当前signal长度
	 */ 
	public function get length():int{
		return count;
	}
	
	/**
	 * 移除所有监听方法
	 */ 
	public function removeAll():void{
		for(var fun:* in onceCheck){
			remove(fun);
		}
	}
	
	/**
	 * 检查是否为空
	 */ 
	public function isEmpty():Boolean{
		return count == 0;
	}
	
	/**
	 * 查找指定方法的索引
	 */ 
	public function indexOf(fun:Function):int{
		var i:int = -1;
		if (fun in onceCheck) {
			i = onceCheck[fun].index;
		}
		return i;
	}
	
	/**
	 * 开始派送
	 * @param	...args
	 */
	public function dispatch(...args):void{
		if(isEmpty()){
			return;
		}
		var len:int = base.length, i:int, fill:int;
		var fun:Function;
		for(i = 0; i < len; i++){
			fun = base[i];
			if(fun != null){
				if(args.length == 0){
					fun();
				}
				else if(args.length == 1){
					fun(args[0]);
				}
				else if (args.length == 2) {
					fun(args[0], args[1]);
				}
				else if (args.length == 3) {
					fun(args[0], args[1], args[2]);
				}
				else if (args.length == 4) {
					fun(args[0], args[1], args[2], args[3]);
				}
				else{
					fun.apply(null, args); 
				}
				if(onceCheck[fun]){
					if(onceCheck[fun].executeOnce){
						remove(fun);
					}
					else {
						if(fill < i){
							base[fill] = fun;
							onceCheck[fun].index = fill;
							base[i] = null;
						}
						fill++;
					}
				}
			}
		}
		if(i != fill){
			len = base.length;
			while(i < len){
				base[fill] = base[i];
				onceCheck[base[fill]].index = fill;
				base[i] = null;
				fill++;
				i++;
			}
			base.length = fill;
		}
	}
}
}

/**
 * 记录方法的配置策略
 * 
 */ 
internal class Node 
{
	/**
	 * 是否执行一次即自行删除
	 */
	public var executeOnce:Boolean = false;
	
	/**
	 * 索引
	 */
	public var index:int = -1;
	
	/**
	 * 
	 * @param	once
	 * @param	index
	 */
	public function Node(once:Boolean, index:int):void
	{
		this.executeOnce = once;
		this.index = index;
	}
}


