package common.tool
{
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;

public class ResourceManager
{
	/**
	 * 记录当前应用程序域
	 */
	private static var currentDomain:ApplicationDomain;
	
	/**
	 * 是否报警告错误信息
	 */ 
	private static var showErrorMessage:Boolean = false;
	
	/**
	 * 初始化当前应用程序主域
	 */ 
	public static function initDomain(domain:ApplicationDomain, isShowErrorMessage:Boolean = false):void{
		currentDomain = domain;
		showErrorMessage = isShowErrorMessage;
	}
	
	/**
	 * 检查当前域中是否存在指定的类定义
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
	 * 检查给定的Vector对象中是否存储指定的类定义字符串
	 * @param name
	 * @param vector
	 * @return 
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
	 * @see hasThisStuffInVector
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
	 * 获取指定类名的资源实例
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
	 * 获取类定义
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
	 * @see getDefinition
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
	 * 获取给定的对象的类名
	 */ 
	public static function getResourceName(o:Object, isOnlyClassName:Boolean = false):String{
		var s:String = getQualifiedClassName(o);
		if(isOnlyClassName){
			s = s.split("::")[1];
		}
		return s;
	}
	
	/**
	 * @see getResourceName
	 */ 
	public static function getClassName(o:Object):String{
		return getResourceName(o, true);
	}
	
	/**
	 * 在给定的loader对象中获取指定类型资源
	 * @param className class's name
	 * @param loader    loader
	 */ 
	public static function getResourceByDomain(className:String, loader:Loader):*{
		var currentDomain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
		if(currentDomain && currentDomain.hasDefinition(className)){
			var cl:Class = currentDomain.getDefinition(className) as Class;
			return cl(new cl());
		}
	    trace("getResourceByDomain could not be found this resource", className);
		return null;
	}
	
	/**
	 * @param className class's name
	 * @param loader    loader
	 * @see getResourceByDomain
	 */ 
	public static function getDefinitionByDomain(className:String, loader:Loader):Class{
		var currentDomain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
		if(currentDomain && currentDomain.hasDefinition(className)){
			return currentDomain.getDefinition(className) as Class;
		}
		trace("getDefinitionByDomain could not be found this resource", className);
		return null;
	}
	
	/**
	 * 存储loader对象 
	 */
	private static const loaderMap:Map = new Map();
	
	/**
	 * 根据给定的url, 来存储对应的loader对象
	 * @param url
	 * @param loader
	 */
	public static function setLoader(url:String, loader:Loader):void{
		if(loaderMap.contains(url)){
			trace("setLoader encounter a predefined problem", url);
		}
		loaderMap.add(url, loader);
	}
	
	/**
	 * 根据加载的url,获取对应loader对象
	 */ 
	public static function getLoader(url:String):Loader{
		if(loaderMap.contains(url)){
			return loaderMap.get(url) as Loader;
		}
		trace("getLoader could not be found url", url);
		return null;
	}
	
	/**
	 * 销毁存储在map中的loader对象
	 * @param url          the url 
	 * @param selfRemove   the selfRemove 
	 */ 
	public static function disposeLoader(url:String, selfRemove:Boolean = false):void{
		if(loaderMap.contains(url)){
			if(loaderMap.get(url) is Loader){
				if(selfRemove){
					try{
						(loaderMap.get(url) as Loader).close();
					}
					catch(e:Error){
					}
					(loaderMap.get(url) as Loader).unloadAndStop();
				}
				loaderMap.remove(url);
			}
		}
	}
	
	/**
	 * 根据url来获取资源
	 * @see setLoader
	 */ 
	public static function getResourceByURL(url:String, className:String):*{
		var currentDomain:ApplicationDomain = getDomain(url);
		if(currentDomain && currentDomain.hasDefinition(className)){
			var cl:Class = currentDomain.getDefinition(className) as Class;
			return cl(new cl());
		}
		trace("getResourceByURL could not be found this resource", url, className);
		return null;
	}
	
	/**
	 * @param url
	 * @param className
	 * @return 
	 * @see getResourceByURL
	 */
	public static function getDefinitionByURL(url:String, className:String):Class{
		var currentDomain:ApplicationDomain = getDomain(url);
		if(currentDomain && currentDomain.hasDefinition(className)){
			return currentDomain.getDefinition(className) as Class;
		}
		trace("getDefinitionByURL could not be found this resource", url, className);
		return null;
	}
	
	/**
	 * 获取加载指定url的loader的应用程序域
	 * @param url
	 * @return 
	 * @see setLoader
	 */
	public static function getDomain(url:String):ApplicationDomain{
		var loader:Loader = getLoader(url);
		if(loader){
			return loader.contentLoaderInfo.applicationDomain;
		}
		trace("getDomain could not be found url", url);
		return null;
	}
}
}