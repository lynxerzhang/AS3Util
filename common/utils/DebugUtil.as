package common.utils
{
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.Loader;
import flash.display.Shape;
import flash.events.Event;
import flash.net.LocalConnection;
import flash.system.Capabilities;
import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

public class DebugUtil
{
	/**
	 * 改方法引导FlashPlayer触发GC, 可用于调试, Debug版本可使用
	 * System.gc()方法, 考虑GC阶段分为Mark-Sweep, 所以需要调用
	 * 2次
	 * @see could read gskinner's tech blog for this detail
	 */ 
	public static function gc():void{
		try{
			new LocalConnection().connect("__forceGCDoNotUseInReleaseVersionSWF");
			new LocalConnection().connect("__forceGCDoNotUseInReleaseVersionSWF");
		}
		catch(e:Error){
			trace("garbage collection is running");
		}
	}
	
	/**
	 * 销毁xml对象并释放所占内存 
	 * @param xml
	 */ 
	public static function disposeXML(xml:XML):void{
		if(xml){
			if(Object(System).hasOwnProperty("disposeXML")){
				System["disposeXML"](xml);
			}
		}
	}
	
	/**
	 * 将指定的loader标记为可以回收
	 * @param loader
	 */ 
	public static function disposeLoader(loader:Loader):void{
		if(loader){
			try{
				loader.close();
			}
			catch(e:Error){
			}
			loader.unloadAndStop();
		}
	}
	
	/**
	 * 判断当前运行SWF的FlashPlayer环境是否为debug版本
	 */ 
	public static function isDebug():Boolean{
		return Capabilities.isDebugger;
	}
	
	/**
	 * 检查当前运行swf的player是否为浏览器中运行
	 * 同时可以通过判断这个显示对象(比如文档类实例)的loaderInfo.loader是否为空来判断
	 * @return
	 */
	public static function isOnline():Boolean {
		return Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX";
	}
	
	private static const HELPER_CHECK_SWF:RegExp = /.as:[0-9]+]$/m;
	
	/**
	 * 检查当前运行在player中的swf文件是否为debug版本
	 * @return
	 */
	public static function isDebuggerSWF():Boolean {
		var s:String  = new Error().getStackTrace();
		if (s == null) {
			return false;
		}
		return s.search(HELPER_CHECK_SWF) != -1;
	}
	
	/**
	 * 判定当前指定值是否为无意义的null值
	 * @param value 
	 */ 
	public static function isNull(value:*):Boolean{
		var s:String = getQualifiedClassName(value);
		return s == "null" || s == "void" || s == "undefined";
	}
	
	/**
	 * 仅仅判断指定属性是否在指定对象中
	 * 添加try{...}catch操作避免该属性不在指定对象中, 
	 * 会调用该对象的toString()方法
	 * 该对象的toString如果被重写过, 可能会造成空对象报错, 
	 * 建议使用数组访问符[]访问指定对象
	 * 
	 * @param property
	 * @param hub
	 */ 
	public static function isIn(property:*, hub:Object):Boolean{
		try{
			property in hub;
		}
		catch(e:TypeError){
			return false;
		}
		return property in hub;
	}
	
	/**
	 * 判断指定的bitmapData对象是否可以访问 
	 * @param data
	 * @see ArgumentError: Error #2015: 无效的 BitmapData。
	 */ 
	public static function bitmapDataIsDispose(data:BitmapData):Boolean{
		if(data){
			try{
				data.width;
				data.height;
			}
			catch(e:ArgumentError){
				return true;
			}
			return false;
		}
		return true;
	}
	
	/**
	 * 判定指定显示对象是否为可显示状态
	 */ 
	public static function displayObjectIsVisible(dis:DisplayObject):Boolean{
		if(dis){
			return dis.visible && dis.alpha > 0 && dis.scaleX != 0 && dis.scaleY != 0 && dis.stage != null;
		}
		return false;
	}
	
	/**
	 * 判断指定的位图对象是否已经失效
	 */ 
	public static function bitmapDataIsValid(data:BitmapData):Boolean{
		return !bitmapDataIsDispose(data);
	}
	
	/**
	 * 判断指定表达式为true
	 */ 
	public static function assertTrue(expression:*):Boolean{
		return Boolean(expression) == true;
	}
	
	/**
	 * 判断指定表达式为false
	 */ 
	public static function assertFalse(expreesion:*):Boolean{
		return Boolean(expreesion) == false;
	}
	
	private static const HELPER_DICT:Dictionary = new Dictionary(false);
	private static const HELPER_TICKER:Shape = new Shape();
	
	/**
	 * 获取swf版本号
	 * @see http://www.senocular.com/flash/actionscript/?file=ActionScript_3.0/com/senocular/utils/SWFReader.as
	 */
	public static function getSwfVersion():uint {
		var s:LoaderInfo = LoaderInfo.getLoaderInfoByDefinition(HELPER_TICKER)
		var d:ByteArray = s.bytes;
		d.endian = Endian.LITTLE_ENDIAN;
		d.position = 0;
		var swfFC:uint = d.readUnsignedByte();
		var swfW:uint = d.readUnsignedByte();
		var swfS:uint = d.readUnsignedByte();
		return d.readUnsignedByte();
	}
	
	/**
	 * 将指定方法延迟指定的帧数执行
	 * @param	fun
	 * @param	frames
	 * @param	...funArgs
	 * @return
	 */
	public static function delayFrame(fun:Function, frames:uint, ...funArgs):void{
		if (fun in HELPER_DICT) {
			return;
		}
		if(frames < 1){
			frames = 1;
		}
		var count:uint = 0;
		var t:Function = function(evt:Event):void{
			if(++count == frames){
				HELPER_TICKER.removeEventListener(Event.ENTER_FRAME, t);
				if (fun in HELPER_DICT) {
					delete HELPER_DICT[fun];
					if(fun != null){
						fun.apply(null, funArgs);
					}
				}
			}
		}
		HELPER_TICKER.addEventListener(Event.ENTER_FRAME, t);
		HELPER_DICT[fun] = t;
	}

	/**
	 * 清除指定的延迟帧执行的方法
	 */ 
	public static function deleteFrameDelay(fun:Function):void{
		if(fun in HELPER_DICT){
			var t:Function = HELPER_DICT[fun];
			if (t != null) {
				HELPER_TICKER.removeEventListener(Event.ENTER_FRAME, t);
				delete HELPER_DICT[fun];
			}
		}
	}
	
	/**
	 * 将指定方法延迟指定的时间(秒数)执行
	 * @param fun
	 * @param time
	 * @param funArgs
	 */ 
	public static function delayTime(fun:Function, time:Number, ...funArgs):void {
		if (fun in HELPER_DICT) {
			return;
		}
		var d:Number = getTimer();
		var t:Number;
		var enterFrame:Function = function(evt:Event):void{
			t = (getTimer() - d) * .001;
			if (t >= time) {
				HELPER_TICKER.removeEventListener(Event.ENTER_FRAME, enterFrame);
				if (fun in HELPER_DICT) {
					delete HELPER_DICT[fun];
					if(fun != null){
						fun.apply(null, funArgs);
					}
				}
			}
		}
		HELPER_TICKER.addEventListener(Event.ENTER_FRAME, enterFrame);
		HELPER_DICT[fun] = enterFrame;
	}
	
	/**
	 * 清除由delayTime方法所设定的延迟指定时间执行的方法
	 * @param fun
	 */ 
	public static function deleteTimeDelay(fun:Function):void{
		if(fun in HELPER_DICT){
			var f:Function = HELPER_DICT[fun] as Function;
			if (f != null) {
				HELPER_TICKER.removeEventListener(Event.ENTER_FRAME, f);
				delete HELPER_DICT[fun];
			}
		}
	}
	
	/**
	 * 定在渲染事件抛出时的执行某一特定方法
	 * @param	s
	 * @param	fun
	 * @param	...funArgs
	 */
	public static function renderInvalid(s:DisplayObject, fun:Function, ...funArgs):void{
		if(!s || !s.stage){
			trace("your displayObject is null or not on the stage");
			return;
		}
		HELPER_DICT[s] = true;
		s.addEventListener(Event.RENDER, function(evt:Event):void{
			delete HELPER_DICT[s];
			s.removeEventListener(Event.RENDER, arguments.callee);
			if(fun != null){
				fun.apply(null, funArgs);
			}
		});
		s.stage.invalidate();
	}
	
	/**
	 * 判断当前运行swf环境 为本地还是线上
	 */ 
	public static function isLocal():Boolean{
		return Boolean(Capabilities.playerType == "Desktop" || (new LocalConnection( ).domain == "localhost")); 
	}
	
	/**
	 * 检查指定的实现IBitmapDrawable接口对象是否可以绘制
	 * @param	IBD
	 * @return
	 */
	public static function isCouldDraw(IBD:IBitmapDrawable):Boolean{
		if(IBD is DisplayObject){
			return (DisplayObject(IBD).width > 0) && (DisplayObject(IBD).height > 0);
		}
		if(IBD is BitmapData){
			return (BitmapData(IBD).width > 0) && (BitmapData(IBD).height > 0);
		}
		return false;
	}
	
	/**
	 * 获取指定显示对象容器中匹配指定类型的集合
	 * @param container 
	 * @param type
	 */ 
	public static function getChildByType(container:DisplayObjectContainer, type:Class):Array{
		if(!container || container.numChildren == 0){
			return null;
		}
		var ary:Array = [];
		var len:int = container.numChildren;
		while(--len > -1){
			var d:DisplayObject = container.getChildAt(len);
			if(d is type){
				ary.push(d);
			}
		}
		return ary;
	}
	
	
	private static const formatSizeAry:Array = [];
	/**
	 * @param s
	 * 返回指定内存大小的格式化输出
	 * @example
	 * var o = {};
	 * formatSize(String(getSize(o)));
	 */ 
	public static function formatSize(s:String):String {
		formatSizeAry.length = 0;
		var len:int = Math.ceil(s.length / 3);
		for(var i:int = 0; i < len; i ++){
			formatSizeAry.unshift(s.slice(-3));
			s = s.slice(0, s.length - 3);
		}
		return formatSizeAry.join(",");
	}
	
	private static const NORMAL_IMMINENT:Number = .98;
	private static const LESS_IMMINENT:Number = .1;
	
	/**
	 * 给予gc以回收时机的提示
	 * @param	highImminent
	 */
	public static function gcOccasion(highImminent:Boolean):void {
		System.pauseForGCIfCollectionImminent(highImminent == true ? NORMAL_IMMINENT : LESS_IMMINENT);
	}
	
	/**
	 * 给予使gc以立即执行的提示
	 * @param	isDebug
	 * @see gc, isDebuggerSWF, isDebug
	 */
	public static function promptImmediateGC(isDebug:Boolean = false):void {
		gcOccasion(LESS_IMMINENT);
		if (isDebug) {
			System.gc();
			System.gc();
		}
		else {
			gc();
			gc();
		}
	}
}
}
