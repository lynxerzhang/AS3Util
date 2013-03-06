package common.tool
{
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import common.utils.DebugUtil;
import common.utils.ObjectUtil;
import common.tool.SingletonVerify;

public class ResourcePool
{
	public function ResourcePool()
	{
		if(instance){
			throw new IllegalOperationError(SingletonVerify.singletonMessage);
		}
	}
	
	/**
	 * 
	 */ 
	public static const instance:ResourcePool = new ResourcePool();
	
	/**
	 * 
	 */ 
	private static const poolDict:Dictionary = new Dictionary(false);
	
	/**
	 * get pool with specfied type (the type is class or object)
	 */ 
	public function getPool(d:*):VectorMap{
		var c:Class = getType(d);
		return c in poolDict ? poolDict[c] as VectorMap : poolDict[c] = new VectorMap(c);
	}
	
	/**
	 * get specfied type's object
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
	 * get specfied instance's pool is sufficient
	 */ 
	public function isSuffi(d:*):Boolean{
		return getPool(d).getLen() > 0;
	} 
	
	/**
	 * dispose specfied instance's pool 
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
	 * @param d get parameter's Class definition 
	 */ 
	private function getType(d:*):Class{
		return d is Class ? d as Class : getClass(d);
	}
	
	/**
	 * @param d assume parameter is instance
	 */ 
	private function getClass(d:*):Class{
		if(ObjectUtil.isInternalClass(d)){
			return Object(d).constructor;
		}
		return getDefinitionByName(getQualifiedClassName(d)) as Class;
	}
	
	/**
	 * this construct method maybe look bad smell, 
	 * but now I could't found a better way to 'dynamic' construct a class
	 * 
	 * construct method couldn't use function's method 'apply' or 'call'
	 * 
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
	 * dispose a object to specfied pool （the lastIndexOf method maybe bring a performance issue）
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
