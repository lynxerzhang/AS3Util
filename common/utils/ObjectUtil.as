package common.utils
{
import flash.net.getClassByAlias;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
		
public class ObjectUtil
{	
	/**
	 * 判断指定动态对象是否为空
	 * @param o
	 * @return 
	 */
	public static function isEmpty(o:Object):Boolean{
		if(o){
			for(var item:* in o){
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 获取指定对象的内部动态属性数目 
	 * @param o
	 * @return 
	 */
	public static function getLen(o:Object):int{
		var t:int = 0;
		if(o){
			for(var item:* in o){
				t ++;
			}
		}
		return t;
	}
	
	/**
	 * 判断指定child类型与parent类型是否拥有继承关系
	 * @param parent
	 * @param child
	 * @return 
	 */
	public static function checkIsInheritance(parent:Class, child:Class):Boolean{
		if(!(parent && child)){
			return false;
		}//TODO
		if(parent == child){
			return true;
		}
		return Boolean(parent.prototype.isPrototypeOf(child.prototype));
	}

	private static const classDefMapCache:Object = {};
	
	/**
	 * 获取指定对象的类定义
	 * @param d 
	 * @return 
	 */
	public static function getClassDefinition(d:*):Class{
		var s:String = getQualifiedClassName(d);
		var cls:Class;
		if(classDefMapCache[s]){
			cls = (classDefMapCache[s]) as Class;
		}
		else{
			//一个例外
			//Function                         匿名函数
			//builtin.as$0::MethodClosure      方法闭包
			if(s == "builtin.as$0::MethodClosure"){
				//or will ReferenceError: Error #1065: 变量 MethodClosure 未定义。
				cls = classDefMapCache[s] = Object(d).constructor as Class;
			}
			else{
				cls = classDefMapCache[s] = getDefinitionByName(s) as Class;
			}
		}
		return cls
	}
	
	/**
	 * 用于注册类定义 
	 * @param cls
	 * @return 
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
	 * 检查a对象和b对象的引用是否相同
	 * @param a
	 * @param b
	 * @return 
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
	 * 检查指定对象是否为动态类型的对象 
	 * @param data
	 * @return 
	 */
	public static function isDynamic(data:Object):Boolean{
		var xml:XML = describeType(data);
		var isDynamic:Boolean = xml.@isDynamic;
		DebugUtil.disposeXML(xml);
		return isDynamic;
	}
	
	
	/**
	 * 判定指定类是否实现指定接口 
	 * @param cl
	 * @param interfaces
	 * @return 
	 */
	public static function checkIsImplementsInterface(cl:Class, interfaces:Class):Boolean{
		var xml:XML = describeType(cl);
		var isImpl:Boolean = xml.factory.implementsInterface.(@type == getQualifiedClassName(interfaces)).length() > 0;
		DebugUtil.disposeXML(xml);
		return isImpl;
	}
	
	/**
	 * 判断指定值对象是否为简单类型对象 
	 * @param value
	 * @return 
	 */
	public static function checkIsPrimitive(value:Object):Boolean{
		var s:String = typeof value;
		return s == "boolean" || s == "number" || s == "string";
	}
	
	/**
	 * 返回指定对象的类名 
	 * @param runIn
	 * @param removePackage 是否移除包名字符串
	 * @return 
	 */
	public static function getClassName(obj:Object, removePackage:Boolean = true):String{
		var name:String = getQualifiedClassName(obj);
		if(removePackage){
			name = name.substr(name.indexOf("::") + 2);
		}
		return name;
	}
	
	/**
	 * 获取指定对象的包名字符串
	 * @param runIn
	 * @return 
	 */
	public static function getPackageName(obj:Object):String{
		var name:String = getQualifiedClassName(obj);
		return name.substring(0, name.indexOf("::"));
	}
	
	/**
	 * 获取指定对象的类名字符串格式
	 * @param instanceOrClass
	 * @param singleDot
	 * @return 
	 */
	public static function getCompleteClassName(instanceOrClass:*, singleDot:Boolean = true):String{
		var clsName:String = getQualifiedClassName(instanceOrClass);
		if(clsName && singleDot){
			clsName = clsName.split("::").join(".");
		}
		return clsName;
	}

	/**
	 * 判断指定对象是否为包外类 (internal class)
	 * @example 
	 *  Test是一个包外类
	 * 	在flashBuilder中的得到如下字符串
	 * 	Test.as$93::BufferStateIconDisplay
	 *  在Flash IDE中得到如下字符串
	 *  ::Test
	 * @param runIn
	 */ 
	public static function isInternalClass(obj:Object):Boolean{
		var name:String = getQualifiedClassName(obj);
		if(StringUtil.contain(name, "::")){
			//同时检查Flash IDE和flashBuilder中的表现
			if(getPackageName(obj) == "" || StringUtil.contain(name, "as")){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 浅复制一个指定的对象的动态属性
	 * @param source
	 * @param target
	 */
	public static function copy(source:Object, target:Object):void{
		for(var item:* in target){
			if(source.hasOwnProperty(item)){
				source[item] = target[item];
			}
		}
	}
	
	/**
	 * 浅复制指定的原生Object对象
	 * @param	source
	 * @return
	 */
	public static function clone(source:Object):Object {
		var d:Object = { };
		for (var item:* in source) {
			d[item] = source[item];
		}
		return d;
	}
	
	/**
	 * 清除指定对象中的动态属性
	 * @param target
	 */
	public static function clear(target:Object):void{
		for(var item:* in target){
			delete target[item];
		}
	}
	
	/**
	 * 复制一个复杂类型对象, 但是如果被复制属性值为复杂类型, 那么该复制仍旧为浅复制。
	 * @param source
	 * @param target
	 * @note 不包含静态属性或者私有, 保护属性
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
	 * 判断指定对象是否为所列出的类型之一
	 */ 
	public static function assertTypeIsMatch(obj:*, typeAry:Array):Boolean{
		if(!obj || !typeAry){
			return false;
		}
		return typeAry.some(function(item:Class, ...args):Boolean{
			return obj is item;
		});
	} 
	
	private static const cleanMasterPoint:Dictionary = new Dictionary();
	/**
	 * @see jackson as3's blog "how to fixed XML's memory leak"
	 * @param	str
	 * 不过经过测试发现, 即便是XML对象只要不是引用属性(E4X中的@号)的值, 都可以被回收, 不产生对原始XML对象的依赖
	 * (使用flash.sample.getMasterString()方法测试), 如果被引用了属性, 那么即使调用System.disposeXML也无法被回收。
	 */
	public static function cleanMasterString(str:String):void {
		cleanMasterPoint[str] = true;
		delete cleanMasterPoint[str];
	}
	
	/**
	 * 检查指定对象是否可以使用for...in 或者 for...each迭代
	 * @param	obj
	 * @return
	 */
	public static function isCouldForEach(obj:*):Boolean {
		return typeof(obj) == "object" && (obj is Array || getQualifiedClassName(obj).indexOf(getQualifiedClassName(Vector)) > -1);
	}
	
	/**
	 * 获取指定对象的方法字符串集合
	 * @param	obj       
	 * @param	includeInherit  是否包含继承父级的方法
	 * @return  返回字符串类型的Vector对象
	 */
	public static function functionCollection(obj:*, includeInherit:Boolean = false):Vector.<String> {
		var result:Vector.<String> =  new Vector.<String>();	
		var type:XML = describeType(obj);
		var len:int, methodName:String, list:XMLList;
		if (includeInherit) {
			list = type.*.(name() == "method");
		}
		else {
			list = type.*.(name() == "method" && attribute("declaredBy") == String(getQualifiedClassName(obj)));
		}
		if(list && list.length() > 0){
			len = list.length();
			while(--len > -1){
				methodName = String(list[len].@name);
				result.push(methodName);
			}
		}
		return result;
	}
	
	/**
	 * 获取指定对象的方法名称, 以字符串格式返回
	 * @param	obj
	 * @param	func
	 * @return
	 */
	public static function functionName(obj:Object, func:Function):String {
		var collection:Vector.<String> = functionCollection(obj, true);
		var foundName:String = "";
		if (collection && collection.length > 0) {
			collection.some(function(name:String, ...args):Boolean {
				if (obj[name] == func) {
					foundName = name;
					return true;
				}
				return false;
			});
		}
		return foundName;
	}
	
	/**
	 * 检查指定对象是否为原生的object类型对象
	 * @param	obj
	 * @return
	 */
	public static function isRawObject(obj:*):Boolean {
		return getDefinitionByName(getQualifiedClassName(obj)) as Class == Object;
	}
	
	/**
	 * 删除对象在指定属性集合中列出的属性名
	 * @param	obj
	 * @param	...args
	 * @return
	 */
	public static function omit(obj:Object, ...args):Object{
		var t:Array = args.length == 1 && args[0] is Array ? args[0] as Array : args;
		var c:Object = clone(obj);
		var len:int = t.length;
		for (var i:int = 0; i < len; i ++) {
			if (c.hasOwnProperty(t[i])) {
				delete c[t[i]];
			}
		}
		return c;
	}
	
}
}
