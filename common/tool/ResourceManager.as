package common.tool
{
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;

import common.tool.VectorMap;

public class ResourceManager
{
	
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
	
	//below are get child applicationDomain's resource
	//****************************************************************
	/**
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
	 */ 
	public static function getDefinitionByDomain(className:String, loader:Loader):Class{
		var currentDomain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
		if(currentDomain && currentDomain.hasDefinition(className)){
			return currentDomain.getDefinition(className) as Class;
		}
		trace("getDefinitionByDomain could not be found this resource", className);
		return null;
	}
	
	
	//below are child of applicationDomain
	//*****************************************************************
	private static const loaderMap:Map = new Map();
	/**
	 * add a specfied loader
	 */ 
	public static function setLoader(url:String, loader:Loader):void{
		if(loaderMap.contains(url)){
			trace("setLoader encounter a predefined problem", url);
		}
		loaderMap.add(url, loader);
	}
	/**
	 * get a specfied loader
	 */ 
	public static function getLoader(url:String):Loader{
		if(loaderMap.contains(url)){
			return loaderMap.get(url) as Loader;
		}
		trace("getLoader could not be found url", url);
		return null;
	}
	/**
	 * dispose specfied loader
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
	 * get resource by specfied url
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
	 * get definition by specfied url
	 * 
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
	 * get specfied application domain
	 */ 
	public static function getDomain(url:String):ApplicationDomain{
		var loader:Loader = getLoader(url);
		if(loader){
			return loader.contentLoaderInfo.applicationDomain;
		}
		trace("getDomain could not be found url", url);
		return null;
	}
	//*****************************************************************
}
}