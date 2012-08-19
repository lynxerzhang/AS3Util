package load
{

import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

import utils.ObjectUtil;
import utils.DisplayObjectUtil;

/**
 * TODO
 * current version has no cache feature, so every load operation will remove the last resource
 * 
 */ 
public class LoadTool
{
	/*cache the loader to save the performance*/
	private static const loadPool:Dictionary = new Dictionary(false);
	
	/**
	 * @param url           the load url
	 * 
	 * @param completeCall  the complete load callback
	 *  
	 * @param width         strictly specified loaded resource width
	 */ 
	public static function load(host:DisplayObjectContainer, url:String, completeCall:Function, width:Number = NaN):void{
		var loader:SimpleLoader;
		if(loadPool[host]){
			loader = loadPool[host] as SimpleLoader;
			loader.kill();
			loader.refresh(url, completeCall, width);
		}
		else{
			loadPool[host] = new SimpleLoader(url, completeCall, width);
		}
		if(!loader){
			loader = loadPool[host] as SimpleLoader;
		}
		loader.start();
	}
	
	/**
	 * temp close the running loader
	 */ 
	public static function close(host:DisplayObjectContainer):void{
		var loader:SimpleLoader = loadPool[host] as SimpleLoader;
		if(loader){
			loader.kill();
		}
	}
	
	/**
	 * 
	 */
	public static function dispose(host:DisplayObjectContainer):void{
		if(host in loadPool){
			var s:SimpleLoader = loadPool[host] as SimpleLoader;
			if(s){
				s.kill();
				loadPool[host] = undefined;
				delete loadPool[host];
			}
		} 
	}
}
}


import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;

import utils.DebugUtil;
import utils.DisplayObjectUtil;

/**
 *  use 'kill' method to prepare gc the loader
 */ 
internal class SimpleLoader extends Loader{
	
	private var completeCallback:Function;
	private var url:String;
	private var couldNotAccessResourcePixel:Boolean = false;
	private var strictWidth:Number = NaN;
	private var context:LoaderContext;
	public var isComplete:Boolean = false;
	private var loadedType:String;
	
	/**
	 * @param url           the load url
	 * @param completeCall  will call in completeEvent handle
	 * @param strictWidth   the loader's width
	 */ 
	public function SimpleLoader(url:String, completeCall:Function, strictWidth:Number = NaN):void{
		if(!url){
			return;
		}
		refresh(url, completeCall, strictWidth);
	}
	
	public function start():void{
		this.load(new URLRequest(this.url), context);
	}
		
	private function dispose():void{
		try{
			this.close();
		}
		catch(e:Error){
			
		}
		if(!couldNotAccessResourcePixel){
			if(loadedType && loadedType == "swf"){
				if(this.isShouldKill){
					this.unloadAndStop();
				}
			}
		}
		//DebugUtil.gc();
		this.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
		this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		isComplete = false;
	}
	
	public function kill():void{
		this.completeCallback = null;
		this.couldNotAccessResourcePixel = false;
		this.isShouldKill = true;
		dispose();
	}
	
	private var isShouldKill:Boolean = false;
	
	public function refresh(url:String, completeCall:Function, strictWidth:Number = NaN):void{
		this.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
		this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
		this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		
		this.url = url;
		this.completeCallback = completeCall;
		this.strictWidth = strictWidth;
		
		loadedType = DebugUtil.getContentType(this.url);
		
		if(loadedType == "swf"){
			var isLocal:Boolean = DebugUtil.isLocal();
			if(isLocal){
				context = new LoaderContext(true, ApplicationDomain.currentDomain);
			}
			else{
				//prevent headache, but source server must have a crossdomain file
				context = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), SecurityDomain.currentDomain);
			}
		}
		else{
			//if loaded source is jpeg
			context = new LoaderContext(true);
		}
		this.couldNotAccessResourcePixel = false;
		this.isComplete = false;
		this.isShouldKill = false;
	}
	
	private static const contentType:Vector.<String> = new <String>["image/png", "image/jpeg", "image/gif"];
	
	private function loadCompleteHandler(evt:Event):void{
		isComplete = true;
		
		if(completeCallback != null){
			
			var info:LoaderInfo = evt.currentTarget as LoaderInfo;
			
			if(!info.childAllowsParent){
				trace("the loaded source server has not crossdomain.xml or the swf file has no set 'Security.allowDomain' method" + this.url);

				couldNotAccessResourcePixel = true;
				
				if(!isNaN(this.strictWidth)){
					this.width = this.strictWidth;
					this.scaleY = this.scaleX;
				}
				
				completeCallback(this);
			}
			else{
				if(contentType.indexOf(info.contentType) != -1){
					var dobj:DisplayObject = info.content as DisplayObject;
					var bitmap:Bitmap = DisplayObjectUtil.getBitmap(dobj);
					
					if(!isNaN(this.strictWidth)){
						bitmap.width = this.strictWidth;
						bitmap.scaleY = bitmap.scaleX;
					}
					completeCallback(bitmap);	
				}
				else{
					//only the swf object
					if(loadedType && loadedType == "swf"){
						//swf - a timeline object
						//notice the dispose's method(unLoadAndStop), 
						//reAddChild in other Container, otherwise you will found nothing to show
						completeCallback(info.content);
					}
				}
			}
		}
		dispose();
	}
	
	/* io error */
	private function loadIOErrorHandler(evt:IOErrorEvent):void{
		dispose();
		trace("load " + this.url + " encounter a io error");
		trace("load " + this.url + " encounter a io error");
	}
	
	/* security error */
	private function securityErrorHandler(evt:SecurityErrorEvent):void{
		dispose();
		trace("load " + this.url + " encounter a security error");
	}
}
