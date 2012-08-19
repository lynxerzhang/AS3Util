package tool
{
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * 
 * a resourcePool (the 'resource' maybe create, remove frequently, so use the pool to improve performance)
 * 
 */ 
public class ResourcePool
{
	public function ResourcePool()
	{
		new SingletonVerify(this, ResourcePool);
	}
	
	/**
	 * 
	 */ 
	public static var instance:ResourcePool = new ResourcePool();
	
	/**
	 * 
	 */ 
	private static const poolDict:Dictionary = new Dictionary(false);
	
	/**
	 * get pool with specfied type (the type is class or object)
	 */ 
	public function getPool(d:*):Array{
		var c:Class = getType(d);
		return c in poolDict ? poolDict[c] as Array : poolDict[c] = [];
	}
	
	/**
	 * get specfied type's object
	 */ 
	public function getResource(d:*, ...args):*{
		var k:Array = getPool(d);
		if(k.length > 0){
			return k.pop();
		}
		var c:Class = getType(d);
		return construct(c, args);
	}
	
	public function disposeAll(d:*):void{
		var k:Array = getPool(d);
		if(k){
			k.length = 0;
			var c:Class = getType(d);
			poolDict[c] = undefined;
			delete poolDict[c];
		}
	}
	
	private function getType(d:*):Class{
		var c:Class = d is Class ? d as Class : getDefinitionByName(getQualifiedClassName(d)) as Class;
		return c;
	}
	
	/**
	 * this construct method maybe look bad smell, 
	 * but now I could't found a better way to 'dynamic' construct a class
	 */ 
	private function construct(c:Class, args:Array):*{
		var len:int = args.length;
		var o:*;
		switch(len){
			case 0: o = new c(); break;
			case 1: o = new c(args[0]); break;
			case 2: o = new c(args[0], args[1]); break;
			case 3: o = new c(args[0], args[1], args[2]); break;
			case 4: o = new c(args[0], args[1], args[2], args[3]); break;
			case 5: o = new c(args[0], args[1], args[2], args[3], args[4]); break;
			case 6: o = new c(args[0], args[1], args[2], args[3], args[4], args[5]); break;
			case 7: o = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
			case 8: o = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);	break;
			case 9: o = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]); break;
			case 10: o = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]); break;
			default:
				trace("you specfied class's construct's method's arguments length more than 10,"  + 
								  "so check 'construct' method in ResourcePool");
				break;
		}
		return o;
	}
	
	
	/**
	 * dispose a object to specfied pool （the lastIndexOf method maybe bring a performance issue）
	 */ 
	public function dispose(d:*):void{
		var k:Array = getPool(d);
		if(k.lastIndexOf(d) == -1){
			k.push(d);
		} 
	}
}
}
