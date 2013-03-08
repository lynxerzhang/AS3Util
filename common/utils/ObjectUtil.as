package common.utils
{
import flash.net.getClassByAlias;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
		
public class ObjectUtil
{	
	/**
	 * check the object's length
	 * @param o 
	 * 判断指定对象是否为空对象
	 */ 
	public static function isEmptyRawObject(o:Object):Boolean{
		if(o){
			for(var item:* in o){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * check the object's length
	 * @param o
	 * 返回指定对象的键值数
	 */ 
	public static function getRawObjectLen(o:Object):int{
		var t:int = 0;
		if(o){
			for(var item:* in o){
				t ++;
			}
		}
		return t;
	}
	
	/**
	 * check specfied 'parent' Class and 'child' Class is whether has inheritance relation
	 * @param parent
	 * @param child
	 * 判断指定child类型与parent类型是否拥有继承关系
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

	private static const classDefMapCache:Object = {};
	public static function getClassDefinition(d:*):Class{
		var s:String = getQualifiedClassName(d);
		if(classDefMapCache[s]){
			return (classDefMapCache[s]) as Class;
		}
		//一个例外
		//Function                         匿名函数
		//builtin.as$0::MethodClosure      方法闭包
		if(s == "builtin.as$0::MethodClosure"){
			//or will ReferenceError: Error #1065: 变量 MethodClosure 未定义。
			return classDefMapCache[s] = Object(d).constructor as Class;
		}
		return classDefMapCache[s] = getDefinitionByName(s) as Class;
	}
	
	/**
	 * @param cls  instance or class
	 * 用于注册类定义
	 */ 
	public static function registerClassDefinition(cls:*):Boolean{
		if(DebugUtil.isNull(cls)){
			return false;
		}
		var clsName:String = getQualifiedClassName(cls);
		try{
			if((getClassByAlias(clsName) as Class) != null){
				return false;
			}
		}
		catch(e:ReferenceError){
			//if no define, will handle a referenceError, so slience this error
		}
		var c:Class = cls is Class ? cls as Class : getDefinitionByName(clsName) as Class;
		clsName = clsName.split("::").join(".");
		registerClassAlias(clsName, c);
		return !!getClassByAlias(clsName) as Class;
	}
	
	/**
	 * check a and b is same reference
	 * @param a
	 * @param b
	 */
	public static function isSameReference(a:Object, b:Object):Boolean{
		if(DebugUtil.isNull(a) || DebugUtil.isNull(b)){
			return false;
		}
		if(isDynamic(a) || isDynamic(b)){
			return a == b;
		}
		var byteA:ByteArray = new ByteArray();
		byteA.writeObject(a);
		byteA.position = 0;
		var byteB:ByteArray = new ByteArray();
		byteB.writeObject(b);
		byteB.position = 0;
		return Boolean(byteA.toString() == byteB.toString());
	}
	
	/**
	 * check specfied object is whether dynamic class
	 * @param data
	 */ 
	public static function isDynamic(data:Object):Boolean{
		var xml:XML = describeType(data);
		var isDynamic:Boolean = xml.@isDynamic;
		DebugUtil.disposeXML(xml);
		return isDynamic;
	}
	
	/**
	 * @param cl               the class to check
	 * @param interfaces       the interface
	 * 
	 * @return                 if specfied parameter cl is implements the parameter interfaces
	 * 判定指定类是否实现指定接口
	 */ 
	public static function checkIsImplementsInterface(cl:Class, interfaces:Class):Boolean{
		var xml:XML = describeType(cl);
		var isImpl:Boolean = xml.factory.implementsInterface.(@type == getQualifiedClassName(interfaces)).length() > 0;
		DebugUtil.disposeXML(xml);
		return isImpl;
	}
	
	/**
	 * check the specfied value is whether a primitive value
	 * @param value
	 * 判断指定值对象是否为简单类型对象
	 */ 
	public static function checkIsPrimitive(value:Object):Boolean{
		var s:String = typeof value;
		return s == "boolean" || s == "number" || s == "string";
	}
	
	/**
	 * get class name
	 * 
	 * @param removePackage is whether remove package (remove front colon's string)
	 * 
	 * 返回指定对象的类名
	 */ 
	public static function getClassName(runIn:Object, removePackage:Boolean = true):String{
		var name:String = getQualifiedClassName(runIn);
		if(removePackage){
			name = name.substr(name.indexOf("::") + 2);
		}
		return name;
	}
	
	/**
	 * get specfied object's package name
	 * 
	 * @param runIn
	 */ 
	public static function getPackageName(runIn:Object):String{
		var name:String = getQualifiedClassName(runIn);
		return name.substring(0, name.indexOf("::"));
	}
	
        /**
	 * get specfied object or class 's name
	 */ 
	public static function getCompleteClassName(instanceOrClass:*, singleDot:Boolean = true):String{
		var clsName:String = getQualifiedClassName(instanceOrClass);
		if(clsName && singleDot){
			clsName = clsName.split("::").join(".");
		}
		return clsName;
	}

	/**
	 * TODO
	 * check specfied object's class is Internal Package class
	 * 
	 * @example 
	 * 	in FlashBuilder 
	 * 	BufferStatePanel.as$93::BufferStateIconDisplay
	 *  
	 *  in FlashIDE
	 *  ::BufferStateIconDisplay
	 * @param runIn
	 */ 
	public static function isInternalClass(runIn:Object):Boolean{
		var name:String = getQualifiedClassName(runIn);
		if(StringUtil.contain(name, "::")){
			//check FlashIDE and FlashBuilder
			if(getPackageName(runIn) == "" || StringUtil.contain(name, "as")){
				return true;
			}
		}
		return false;
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
	
	/**
	 * TODO  not contain static property or private protected property
	 * @param source
	 * @param target
	 */ 
	public static function copyComplex(source:Object, target:Object):void{
		var sourceClstr:String = getQualifiedClassName(source);
		if(sourceClstr == getQualifiedClassName(target)){
			var variableList:XML = describeType(source);
			var len:int, propertyName:String, currentValue:*, type:Class;
			var list:XMLList = variableList.*.(name() == "variable" || (name() == "accessor" && 
				(attribute("access") == "writeonly" || attribute("access") == "readwrite")));
			if(list && list.length() > 0){
				len = list.length();
				while(--len > -1){
					propertyName = String(list[len].@name);
					currentValue = target[propertyName]; 
					type = getDefinitionByName(String(list[len].@type)) as Class;
					source[propertyName] = type(currentValue);
				}
			}
			DebugUtil.disposeXML(variableList);
		}
	}
	
	/**
	 * copy value from targetRaw to complex
	 * @param complex
	 * @param targetRaw   
	 */ 
	public static function copyFromObject(complex:Object, targetRaw:Object):void{
		if(complex && targetRaw){
			for(var item:String in targetRaw){
				if(complex.hasOwnProperty(item)){
					complex[item] = targetRaw[item];
				}
			}
		}
	}
	
}
}
