package utils
{
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
/**
 * 
 */ 	
public class ObjectUtil
{
	public function ObjectUtil()
	{
	}
	
	/**
	 * check the object's length
	 */ 
	public static function isEmptyRawObject(o:Object):Boolean{
		var ns:int = 0;
		if(o){
			for(var item:* in o){
				ns ++;
			}
		}
		return Boolean(ns == 0);
	}
	
	/**
	 * check the object's length
	 */ 
	public static function getRawObjectLen(o:Object):int{
		var len:int = 0;
		if(o){
			for(var item:* in o){
				len ++;
			}
		}
		return len;
	}
	
	/**
	 * check specfied 'parent' Class and 'child' Class is whether has inheritance relation
	 */ 
	public static function checkIsInheritance(parent:Class, child:Class):Boolean{
		if(!(parent && child)){
			return false;
		}//TODO
		if(parent == child){
			return true;
		}
		return (parent.prototype.isPrototypeOf(child.prototype)) as Boolean;
	}

	/**
	 * @param cl               the class to check
	 * @param interfaces       the interface
	 * 
	 * @return                 if specfied parameter cl is implements the parameter interfaces
	 */ 
	public static function checkIsImplementsInterface(cl:Class, interfaces:Class):Boolean{
		return describeType(cl).factory.implementsInterface.(@type == getQualifiedClassName(interfaces)).length() > 0;
	}
	
	
	/**
	 * check the specfied value is whether a primitive value
	 */ 
	public static function checkIsPrimitive(value:Object):Boolean{
		var s:String = typeof value;
		return s == "boolean" || s == "number" || s == "string";
	}
	
	/**
	 * get class name
	 * 
	 * @param removePackage is whether remove package (remove front colon's string)
	 */ 
	public static function getClassName(runIn:Object, removePackage:Boolean = true):String{
		var name:String = getQualifiedClassName(runIn);
		if(removePackage){
			name = name.substr(name.indexOf("::") + 2);
		}
		return name;
	}
	
	/**
	 * @param obj    object or class
	 * @param typeAry    list all type
	 */ 
	public static function assertTypeIsMatch(obj:*, typeAry:Array):Boolean{
		if(!obj || !typeAry){
			return false;
		}
		return typeAry.some(function(item:Class, ...args):Boolean{
			return obj is item;
		});
	} 
	
	/**
	 * copy the target object's saved data to source
	 * 
	 * (shallow copy)
	 * 
	 * @param source
	 * @param target
	 */ 
	public static function copy(source:Object, target:Object):void{
		for(var item:* in target){
			source[item] = target[item];
		}
	}
	
	/**
	 * clear the specfied object's saved data
	 * 
	 * @param target
 	 */ 
	public static function clear(target:Object):void{
		for(var item:* in target){
			delete target[item];
		}
	}
}
}