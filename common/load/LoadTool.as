package common.load
{

import common.utils.DisplayObjectUtil;
import common.utils.ObjectUtil;
import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

public class LoadTool
{
	/*每一个显示容器缓存一个loader*/
	private static const loadPool:Dictionary = new Dictionary(false);
	
	/**
	 * 
	 * @param	host
	 * @param	url
	 * @param	completeCall
	 * @param	width
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
	 * 中断加载
	 */ 
	public static function close(host:DisplayObjectContainer):void{
		var loader:SimpleLoader = loadPool[host] as SimpleLoader;
		if(loader){
			loader.kill();
		}
	}
	
	/**
	 * 中断并销毁加载
	 */
	public static function dispose(host:DisplayObjectContainer):void{
		try{
			host in loadPool;
		}
		catch(e:TypeError){
			delete loadPool[host];
			return;
		}
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


import common.utils.BitmapUtil;
import common.utils.DebugUtil;
import common.utils.DisplayObjectUtil;
import common.utils.ObjectUtil;

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

internal class SimpleLoader extends Loader
{	
	/**
	 * 加载成功回调
	 */
	private var completeCallback:Function;
	
	/**
	 * 加载路径地址
	 */
	private var url:String;
	
	/**
	 * 该资源是否有安全许可, 如果没有, 则在draw时会触发安全报错
	 */
	private var couldNotAccessResourcePixel:Boolean = false;
	
	/**
	 * 严格制定宽
	 */
	private var strictWidth:Number = NaN;
	
	/**
	 * 加载策略
	 */
	private var context:LoaderContext;
	
	/**
	 * 判断是否加载成功
	 */
	private var isComplete:Boolean = false;
	
	/**
	 * 加载类型(png or swf or something else)
	 */
	private var loadedType:String;
	
	/**
	 * @param	url
	 * @param	completeCall
	 * @param	strictWidth
	 */
	public function SimpleLoader(url:String, completeCall:Function, strictWidth:Number = NaN):void{
		if(!url){
			return;
		}
		refresh(url, completeCall, strictWidth);
	}
	
	/**
	 * 开始加载
	 */
	public function start():void{
		this.load(new URLRequest(this.url), context);
	}
	
	/**
	 * 清除加载
	 */
	private function dispose():void{
		try{
			this.close();
		}
		catch(e:Error){
		}
		try{
			this.unload();
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
		
		loadedType = getContentType(this.url);
		
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
	
	private static function getContentType(url:String):String{
		return url.slice(url.lastIndexOf(".") + 1, url.length).toLocaleLowerCase();
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
				if(contentType.indexOf(info.contentType) != -1 || (info.content != null && loadedType && loadedType != "swf")){
					var dobj:DisplayObject = info.content as DisplayObject;
					var bitmap:Bitmap = BitmapUtil.getBitmap(dobj);
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
						if(!isNaN(this.strictWidth)){
							info.content.width = this.strictWidth;
							info.content.scaleY = info.content.scaleX;
						}
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
		trace("loadIOErrorHandler " + this.url + " encounter a io error");
	}
	
	/* security error */
	private function securityErrorHandler(evt:SecurityErrorEvent):void{
		dispose();
		trace("securityErrorHandler " + this.url + " encounter a security error");
	}
}
