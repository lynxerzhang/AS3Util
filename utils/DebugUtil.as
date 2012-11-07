package utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.Shape;
import flash.events.Event;
import flash.net.LocalConnection;
import flash.system.Capabilities;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import tool.ResourcePool;

/**
 * 
 * offer some userful debug method
 */ 
public class DebugUtil
{	
	/**
	 * grantskinner's hack method, do not use in release version
	 */ 
	public static function gc():void{
		try{
			new LocalConnection().connect("__forceGC");
			new LocalConnection().connect("__forceGC");
		}
		catch(e:Error){
			trace("garbage collection is running");
		}
	}
	
	/**
	 * check current player's environment whether is debug
	 */ 
	public static function isDebug():Boolean{
		return Capabilities.isDebugger;
	}
	
	/**
	 * check variable is whether null
	 */ 
	public static function isNull(value:*):Boolean{
		var s:String = getQualifiedClassName(value);
		return s == "null" || s == "void" || s == "undefined";
	}
	
	
	/**
	 * just used in debugPlayer's Test version
	 */ 
	public static function getExecuteChain():String{
		var s:String;
		try{
			throw new Error("__GetExecuteChain");
		}
		catch(e:Error){
			s = e.getStackTrace();
		}
		return s;
	}
	
	/**
	 * assert BitmapData is whether dispose
	 */ 
	public static function assertBitmapDataIsDispose(data:BitmapData):Boolean{
		if(data){
			try{
				var w:int = data.width;
				var h:int = data.height;
			}
			catch(e:ArgumentError){
				return true;
			}
			return false;
		}
		return true;
	}
	
	/**
	 * 
	 * assertDisplayObjectIsMayVisible
	 * 
	 * if displayobject is unvisible, maybe it outside stage, or his parent is overall it's edge
	 */ 
	public static function assertDisplayObjectIsMayVisible(dis:DisplayObject):Boolean{
		if(dis){
			if(dis.visible && dis.alpha != 0 && dis.scaleX != 0 && dis.scaleY != 0){
				return dis.stage != null;
			}
			return false;
		}
		return false;
	}
	
	/**
	 * assert the bitmapData is valid
	 */ 
	public static function assertBitmapDataIsValid(data:BitmapData):Boolean{
		return !assertBitmapDataIsDispose(data);
	}
	
	/**
	 * assert expression is true
	 */ 
	public static function assertTrue(expression:*):Boolean{
		return Boolean(expression) == true;
	}
	
	/**
	 * assert expression is false
	 */ 
	public static function assertFalse(expreesion:*):Boolean{
		return Boolean(expreesion) == false;
	}
	
	/**
	 * @param fun the function to delay run with specified frames
	 * @param frames the specfied frames
	 */ 
	public static function runFramesDelay(fun:Function, frames:uint, ...funArgs):Function{
		frames = Math.max(1, frames);
		
		var s:Shape = ResourcePool.instance.getResource(Shape);
		var count:uint = 0;
		preventGC[s] = true;
		
		var t:Function = function(evt:Event):void{
			if(++count == frames){
				preventGC[s] = undefined;
				delete preventGC[s];
				s.removeEventListener(Event.ENTER_FRAME, t);
				ResourcePool.instance.dispose(s);
				s = null;
				delete runFramesDelayDict[t];
				
				if(fun != null){
					fun.apply(null, funArgs);
				}
			}
		}
		s.addEventListener(Event.ENTER_FRAME, t);
		runFramesDelayDict[t] = s;
		return t;
	}

	
	private static const runFramesDelayDict:Dictionary = new Dictionary(false);
	
	public static function cancelRunFramesDelay(fun:Function):void{
		if(fun in runFramesDelayDict){
			var s:Shape = runFramesDelayDict[fun];
			s.removeEventListener(Event.ENTER_FRAME, fun);
			delete runFramesDelayDict[fun];
		}
	}
	
	/**
	 * 
	 * @see 方法 checkTimesDelay
	 * @see 常量 checkTimesDelayDict
	 */ 
	public static function deleteCheckTimesDelay(fun:Function):void{
		if(fun in checkTimesDelayDict){
			var f:Function = checkTimesDelayDict[fun] as Function;
			if(f != null){
				f();
			}
		}
	}
	
	private static const checkTimesDelayDict:Dictionary = new Dictionary(false);
	
	/**
	 * @see runTimesDelay
	 * 
	 * 和runTimesDelay功能一样, 当中添加半途终止的处理, 可以查看deleteCheckTimesDelay方法
	 */ 
	public static function checkTimesDelay(fun:Function, time:Number, ...funArgs):void{
		var s:Shape = ResourcePool.instance.getResource(Shape);
		var d:Number = getTimer();
		var t:Number;
		preventGC[s] = true;
		
		var ended:Function = function(runFun:Boolean):void{
			preventGC[s] = undefined;
			delete preventGC[s];
			
			s.removeEventListener(Event.ENTER_FRAME, enterFrame);
			ResourcePool.instance.dispose(s);
			s = null;
			
			checkTimesDelayDict[fun] = undefined;
			delete checkTimesDelayDict[fun];
			
			if(fun != null && runFun){
				fun.apply(null, funArgs);
			}
		}
			
		var deleteS:Function = function():void{
			ended(false);	
		}
			
		var enterFrame:Function = function(evt:Event):void{
			t = (getTimer() - d) * .001;
			if(t >= time){			
				ended(true);
			}
		}
		
		s.addEventListener(Event.ENTER_FRAME, enterFrame);
		checkTimesDelayDict[fun] = deleteS;
	}
	
	/**
	 * @param fun  the function to delay run with specified elapsed seconds
	 * @param time the seconds elapsed will run the function
	 */ 
	public static function runTimesDelay(fun:Function, time:Number, ...funArgs):void{
		var s:Shape = ResourcePool.instance.getResource(Shape);
		var d:Number = getTimer();
		var t:Number;
		
		preventGC[s] = true;
		s.addEventListener(Event.ENTER_FRAME, function(evt:Event):void{
			t = (getTimer() - d) * .001;
			if(t >= time){
				preventGC[s] = undefined;
				delete preventGC[s];
				s.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				ResourcePool.instance.dispose(s);
				s = null;
				if(fun != null){
					fun.apply(null, funArgs);
				}
			}
		});
	}
	
	/**
	 * TODO
	 * 
	 * @param s   		  the displayObject to handle the render event
	 * @param fun 		  the listener
	 * @param ...funArgs  the function's argument
	 */ 
	public static function renderInvalid(s:DisplayObject, fun:Function, ...funArgs):void{
		if(!s || !s.stage){
			trace("do not execute specfied listener, because your displayObject is null or not on the stage");
			return;
		}
		
		preventGC[s] = true;
		
		s.addEventListener(Event.RENDER, function(evt:Event):void{
			preventGC[s] = undefined;
			delete preventGC[s];
			s.removeEventListener(Event.RENDER, arguments.callee);
			if(fun != null){
				fun.apply(null, funArgs);
			}
		});
		
		s.stage.invalidate();
	}
	
	private static var preventGC:Dictionary = new Dictionary(false);
	
	/**
	 * TODO
	 * check whether the specfied dis is a static displayobject ('no internal motion')
	 * this function use is need more careful 
	 */ 
	public static function assertDisplayObjectIsStatic(dis:DisplayObject, notifyFun:Function):void{
		var d:BitmapData = DisplayObjectUtil.getOpaqueDisObj(dis);
		var result:Boolean = false;
		var check:BitmapData;
		
		if(d){
			var c:Shape = ResourcePool.instance.getResource(Shape);
			var count:int = 1;	
			preventGC[c] = true;
			
			c.addEventListener(Event.ENTER_FRAME, function(evt:Event):void{
				
				if(count++ == 2){
					preventGC[c] = undefined;
					delete preventGC[c];
					
					c.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					check = DisplayObjectUtil.getOpaqueDisObj(dis);
					result =  DisplayObjectUtil.checkBitmapDataIsEqual(d, check);
					ResourcePool.instance.dispose(c);
					
					d.dispose();
					check.dispose();
					c = null;
					
					if(notifyFun != null){
						notifyFun(result);
					}
				}
			});
		}
		else{
			
			d.dispose();
			
			if(notifyFun != null){
				notifyFun(result);
			}
			
		}
	}
	
	/**
	 * check player running on the local machine
	 */ 
	public static function isLocal():Boolean{
		return Boolean(Capabilities.playerType == "Desktop" || (new LocalConnection( ).domain == "localhost")); 
	}
	
	/**
	 * check whether specfied resource is could draw
	 */ 
	public static function isCouldDraw(IBD:IBitmapDrawable):Boolean{
		if(IBD is DisplayObject){
			return (DisplayObject(IBD).width > 0 && DisplayObject(IBD).height > 0);
		}
		if(IBD is BitmapData){
			return BitmapData(IBD).width > 0 && BitmapData(IBD).height > 0;
		}
		return false;
	}
	
	/**
	 * dump specfied container for debug purpose
	 */ 
	public static function dumpDisplayChildren(container:DisplayObjectContainer):String{
		var len:int = container.numChildren;
		var s:String = "dumpDisplayList begin ---- > \n";
		for(var i:int = 0; i < len; i++){
			var t:DisplayObject = container.getChildAt(i);
			s += "depth : " + i + " ----> " + getQualifiedClassName(t) + "\n";
		}
		s += "dumpDisplayList end ---- > \n";
		return s;
	}
	
	
	/**
	 * 
	 * get the fucking same type as specfied parameter type
	 * 
	 */ 
	public static function getChildByType(container:DisplayObjectContainer, type:Class):Array{
		if(!container || container.numChildren == 0){
			return null;
		}
		var ary:Array = [];
		var len:int = container.numChildren;
		for(var i:int = 0; i < len; i ++){
			var d:DisplayObject = container.getChildAt(i);
			if(d is type){
				ary.push(d);
			}
		}
		return ary;
	}

	public static function getContentType(url:String):String{
		return url.slice(url.lastIndexOf(".") + 1, url.length).toLocaleLowerCase();
	}
	
	/**
	 * TODO
	 * 
	 * format size 
	 * 
	 * @example 1234 will return 1,234
	 */ 
	public static function formatSize(s:String):String{
		var len:int = Math.ceil(s.length / 3);
		if(formatSizeAry.length > 0){
			formatSizeAry.length = 0;
		}
		for(var i:int = 0; i < len; i ++){
			formatSizeAry.unshift(s.slice(-3));
			s = s.slice(0, s.length - 3);
		}
		return formatSizeAry.join(",");
	}
	
	private static const formatSizeAry:Array = [];
	
}
}