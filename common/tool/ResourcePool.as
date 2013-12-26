package common.tool
{
import common.data.VectorMap;
import common.utils.ObjectUtil;

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ResourcePool
{
	public function ResourcePool()
	{
		SingletonVerify.checkSingleton(this);
	}
	
	public static const instance:ResourcePool = new ResourcePool();
	
	private static const poolDict:Dictionary = new Dictionary(false);
	
	/**
	 * 获取指定对象类型的对象池
	 * @param d
	 * @return 
	 */
	public function getPool(d:*):VectorMap{
		var c:Class = getType(d);
		return c in poolDict ? poolDict[c] as VectorMap : poolDict[c] = new VectorMap(c);
	}
	
	/**
	 * 获取指定类型的对象, 其中如果需要对某些对象执行reset方法, 则需要实现IResourcePoolSetter接口
	 * @param d
	 * @param args 
	 * @return 
	 */
	public function getResource(d:*, ...args):*{
		var k:VectorMap = getPool(d);
		if(k.getLen() > 0){
			var t:* = k.getContent(k.getLen() - 1);
			if(ObjectUtil.checkIsImplementsInterface(getClass(t), IResourcePoolSetter)){
				IResourcePoolSetter(t).reset.apply(t, args);
			}
			k.remove(t);
			return t;
		}
		var c:Class = getType(d);
		return construct(c, args);
	}
	
	/**
	 * 检查指定类型的对象池是否拥有对应的对象
	 * @param d
	 * @return 
	 */
	public function isSuffi(d:*):Boolean{
		return getPool(d).getLen() > 0;
	} 
	
	/**
	 * 销毁指定类型的对象池 
	 * @param d
	 * @param func 可以传入方法, 其中方法的参数就是需要销毁的那个类型的对象
	 * 
	 */
	public function disposeAll(d:*, func:Function = null):void{
		var c:Class = getType(d);
		var k:VectorMap = getPool(c);
		if(k){
			if(func != null){
			  k.forEach(func);
			}
			k.removeAll();
			poolDict[c] = undefined;
			delete poolDict[c];
		}
	}
	
	/**
	 * 获取指定对象的class类型
	 * @param d
	 * @return 
	 */
	private function getType(d:*):Class{
		return d is Class ? d as Class : getClass(d);
	}
	
	/**
	 * @param d
	 * @return 
	 * @see getType
	 */
	private function getClass(d:*):Class{
		if(ObjectUtil.isInternalClass(d)){
			return Object(d).constructor;
		}
		return getDefinitionByName(getQualifiedClassName(d)) as Class;
	}
	
	
	/**
	 * 构造一个指定类型的对象, 由于构造方法无法使用Function的apply或call，所以只能根据参数个数逐个编写, 假设参数数目有10个
	 * @param c
	 * @param args
	 * @return 
	 */
	private function construct(c:Class, args:Array):*{
		var d:*;
		switch(args.length){
			case 0: d = new c(); break;
			case 1: d = new c(args[0]); break;
			case 2: d = new c(args[0], args[1]); break;
			case 3: d = new c(args[0], args[1], args[2]); break;
			case 4: d = new c(args[0], args[1], args[2], args[3]); break;
			case 5: d = new c(args[0], args[1], args[2], args[3], args[4]); break;
			case 6: d = new c(args[0], args[1], args[2], args[3], args[4], args[5]); break;
			case 7: d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
			case 8: d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);	break;
			case 9: d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]); break;
			case 10: d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]); break;
			default:
				trace("you specfied class's construct's method's arguments length more than 10, so check 'construct' method in ResourcePool");
				break;
		}
		return d;
	}
	
	/**
	 * 销毁一个对象, 按照类型将其放入指定的对象池
	 * @param d
	 * @param fun 可以传入一个方法, 执行具体的析构方法
	 */
	public function dispose(d:*, fun:Function = null):void{
		if(!d){
			return;
		}
		var k:VectorMap = getPool(d);
		if(!k.contain(d)){
			if(fun != null){
				fun(d);
			}
			k.add(d);
		}
	}
}
}
