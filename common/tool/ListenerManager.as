package common.tool
{
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
	
public class ListenerManager 
{	
	private var listenerDict:Dictionary;
	
	/**
	 * constructor
	 */
	public function ListenerManager():void {
		listenerDict = new Dictionary(false);	
	}
	
	/**
	 * 配置指定的EventDispatcher事件处理
	 * 
	 * @param	dispatch
	 * @param	event
	 * @param	listener
	 */
	public function mapListener(dispatcher:EventDispatcher, event:String, listener:Function, useCapture:Boolean = false):void {
		if (!(dispatcher in listenerDict)) {
			listenerDict[dispatcher] = new Vector.<EventCore>();
		}
		
		var c:Vector.<EventCore> = listenerDict[dispatcher];
		var hasFind:Boolean = c.some(function(item:EventCore, ...args):Boolean{
			return (item.eventName == event) && (item.eventListener == listener) && (item.useCapture == useCapture);
		});
		
		if(hasFind){
			return;
		}
		
		var data:EventCore = new EventCore();
		data.dispatcher = dispatcher;
		data.eventListener = listener;
		data.eventName = event;
		data.useCapture = useCapture;
		
		dispatcher.addEventListener(event, listener, useCapture);
		c.push(data);
	}
	
	/**
	 * 清除一个指定的事件监听
	 * @param	dispatch
	 * @param	event
	 * @param	listener
	 */
	public function upMapListener(dispatcher:EventDispatcher, event:String, listener:Function, useCapture:Boolean = false):void {
		if (dispatcher in listenerDict) {
			var container:Vector.<EventCore> = listenerDict[dispatcher];
			var len:int = container.length;
			while (--len > -1) {
				var item:EventCore = container[len];
				if (item.eventName == event && item.eventListener == listener && item.useCapture == useCapture) {
					dispatcher.removeEventListener(event, listener, useCapture);
					(container.splice(len, 1)[0] as EventCore).dispose();
					break;
				}
			}
		}
	}
	
	/**
	 * 清除所有的监听
	 */
	public function removeAll():void {
		for (var item:* in listenerDict) {
			removeAllListeners(item as EventDispatcher);
		}
	}
	
	/**
	 * 彻底销毁该事件管理器
	 */
	public function dispose():void {
		removeAll();
		listenerDict = null;
	}
	
	/**
	 * 清除指定监听者的所有事件监听
	 * @param	dispatch
	 */
	public function removeAllListeners(dispatcher:EventDispatcher):void {
		if (dispatcher in listenerDict) {
			var c:Vector.<EventCore> = listenerDict[dispatcher];
			c.forEach(function(item:EventCore, ...args):void{
				dispatcher.removeEventListener(item.eventName, item.eventListener, item.useCapture);
			});
			listenerDict[dispatcher] = undefined;
			delete listenerDict[dispatcher];
		}
	}
	
	/**
	 * 移除指定事件类型的监听
	 * @param dispatcher 
	 * @param eventType  event's const name
	 */ 
	public function removeListenersByType(dispatcher:EventDispatcher, eventType:String):void{
		if(dispatcher in listenerDict){
			var c:Vector.<EventCore> = listenerDict[dispatcher];
			if(c){
				var len:int = c.length;
				var item:EventCore;
				while(--len > -1){
					item = c[len];
					if(item.eventName == eventType){
						dispatcher.removeEventListener(item.eventName, item.eventListener, item.useCapture);
						(c.splice(len, 1)[0] as EventCore).dispose();
					}
				}
			}
		}
	}
	
	
	/**
	 * 获取指定事件监听者的所有事件监听方法
	 * @param dispatcher 
	 */ 
	public function getMapEventNameListener(dispatcher:EventDispatcher):Object{
		if(!(dispatcher in listenerDict)){
			return null;
		}
		var c:Vector.<EventCore> = listenerDict[dispatcher];
		var map:Object = {};
		if(c){
			var k:Array;
			c.forEach(function(item:EventCore, ...args):void{
				if(!(item.eventName in map)){
					map[item.eventName] = [];
				}
				k = map[item.eventName];			
				k.push({listener:item.eventListener, useCapture:item.useCapture});
			});
		}
		return map;
	}
	
	/**
	 * 检查是否存在指定事件类型的监听方法
	 * @param dispatcher
	 * @param evtName
	 * @param listener
	 */ 
	public function containListener(dispatcher:EventDispatcher, evtName:String, listener:Function):Boolean{
		if(!(dispatcher in listenerDict)){
			return false;
		}
		var c:Vector.<EventCore> = listenerDict[dispatcher];
		return c.some(function(ec:EventCore, ...args):Boolean{
			return ec.eventName == evtName && ec.eventListener == listener;
		});
	}
	
	/**
	 * 获取指定事件监听者的对应事件类型所有方法配置
	 * @param dispatcher
	 * @param evtName
	 */ 
	public function getListeners(dispatcher:EventDispatcher, evtName:String):Vector.<Object>{
		if(!(dispatcher in listenerDict)){
			return null;
		}
		var c:Vector.<EventCore> = listenerDict[dispatcher];
		var f:Vector.<Object> = new <Object>[];
		if(c){
			c.forEach(function(item:EventCore):void{
				if(item.eventName == evtName){
					f.push({listener:item.eventListener, useCapture:item.useCapture});
				}
			});
		}
		return f;
	}
}
}

import flash.events.EventDispatcher;

class EventCore 
{
	/**
	 * 事件监听者
	 */
	public var dispatcher:EventDispatcher;
	
	/**
	 * 事件名
	 */
	public var eventName:String;
	
	/**
	 * 监听者方法
	 */
	public var eventListener:Function;
	
	/**
	 * 是否处于捕捉阶段
	 */
	public var useCapture:Boolean;
	
	
	public function dispose():void{
		this.dispatcher = null;
		this.eventName = null;
		this.eventListener = null;
	}
}