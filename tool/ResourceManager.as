package tool
{
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;

/**
 * 
 * TODO
 */ 
public class ResourceManager
{
	public function ResourceManager()
	{
		//nothing to do
	}
	
	/**
	 * current applicationdomain container reference
	 */ 
	private static var currentDomain:ApplicationDomain;
	
	/**
	 * check is whether show Error Message
	 */ 
	private static var showErrorMessage:Boolean = false;
	
	/**
	 * 
	 * set applictiondomain resource container
	 */ 
	public static function initDomain(domain:ApplicationDomain, isShowErrorMessage:Boolean = false):void{
		currentDomain = domain;
		showErrorMessage = isShowErrorMessage;
	}
	
	/**
	 * get this currentDomain's container whether has className's resource
	 * 
	 */ 
	public static function hasThisStuff(className:String):Boolean{
		if(!isDomainExist()){
			return false;
		}
		if(!className || className == ""){
			return false;
		}
		return currentDomain.hasDefinition(className);
	}
	
	/**
	 * get this currentDomain's container whether specified name in vector array
	 */ 
	public static function hasThisStuffInVector(name:String, vector:Vector.<String>):Boolean{
		if(!isDomainExist()){
			return false;
		}
		if(vector && vector.length > 0){
			var h:int = vector.indexOf(name);
			if(h == -1){
				return false;
			}
			return currentDomain.hasDefinition(name);
		}
		return false;
	}
	
	/**
	 * get this current domain's container whether specified name in ary 
	 */ 
	public static function hasThisStuffInArray(name:String, ary:Array):Boolean{
		if(!isDomainExist()){
			return false;
		}
		if(ary && ary.length > 0){
			var h:int = ary.indexOf(name);
			if(h == -1){
				return false;
			}
			return currentDomain.hasDefinition(name);
		}
		return false;
	}
	
	
	/**
	 * get Resource by provided resource name
	 */ 
	public static function getResource(className:String):*{
		if(!isDomainExist()){
			return null;
		}
		if(currentDomain.hasDefinition(className)){
			var cl:Class = currentDomain.getDefinition(className) as Class;
			return cl(new cl());
		}
		if(showErrorMessage){
			throw new IllegalOperationError("className : " + className + " is not found.");
		}
		trace("the className : " + className + " " + "is not found in this domain ---> ", currentDomain, " check 'initDomain' method what you set");
		return null;
	}
	
	/**
	 * get class definition by resource of class name
	 */ 
	public static function getDefinition(className:String):Class{
		if(!isDomainExist()){
			return null;
		}
		if(currentDomain.hasDefinition(className)){
			return currentDomain.getDefinition(className) as Class;
		}
		return null;
	}
	
	/**
	 * same with getDefinition
	 */ 
	public static function getClass(className:String):Class{
		return getDefinition(className);
	}
	
	private static function isDomainExist():Boolean{
		if(!currentDomain){
			trace("the currentDomain static property is null , please active initDomain() method first");
			return false;
		}
		return true;
	}
	
	/**
	 * get the given object's definition name
	 */ 
	public static function getResourceName(o:Object, isOnlyClassName:Boolean = false):String{
		var s:String = getQualifiedClassName(o);
		if(isOnlyClassName){
			s = s.split("::")[1];
		}
		return s;
	}
	
	/**
	 * get the give object's class Name
	 */ 
	public static function getClassName(o:Object):String{
		return getResourceName(o, true);
	}
	
}
}