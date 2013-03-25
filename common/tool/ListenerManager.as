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
	 * @param	dispatch
	 * @param	event
	 * @param	listener
	 */
	public function mapListener(dispatch:EventDispatcher, event:String, listener:Function, useCapture:Boolean = false):void {
		if (!(dispatch in listenerDict)) {
			listenerDict[dispatch] = new Vector.<EventCore>();
		}
		
		var container:Vector.<EventCore> = listenerDict[dispatch];
		var len:int = container.length;
		
		for (var i:int = 0; i < len; i ++ ) {
			var item:EventCore = container[i] as EventCore;
			if (item.eventName == event && 
				item.eventListener == listener &&
				item.useCapture == useCapture) {
				return;
			}
		}
		
		var data:EventCore = new EventCore();
		data.dispatcher = dispatch;
		data.eventListener = listener;
		data.eventName = event;
		data.useCapture = useCapture;
		
		dispatch.addEventListener(event, listener, useCapture);
		container.push(data);
	}
	
	/**
	 * 清除一个指定的事件监听
	 * @param	dispatch
	 * @param	event
	 * @param	listener
	 */
	public function upMapListener(dispatch:EventDispatcher, event:String, listener:Function, useCapture:Boolean = false):void {
		if (dispatch in listenerDict) {
			var container:Vector.<EventCore> = listenerDict[dispatch];
			var len:int = container.length;
			while (--len > -1) {
				var item:EventCore = container[len] as EventCore;
				if (item.eventName == event && item.eventListener == listener && item.useCapture == useCapture) {
					dispatch.removeEventListener(event, listener, useCapture);
					container.splice(len, 1);
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
	 * 
	 * 彻底销毁该事件管理器
	 */
	public function dispose():void {
		removeAll();
		listenerDict = new Dictionary(false);
	}
	
	/**
	 * 清除指定监听者的所有事件监听
	 * @param	dispatch
	 */
	public function removeAllListeners(dispatch:EventDispatcher):void {
		if (dispatch in listenerDict) {
			var container:Vector.<EventCore> = listenerDict[dispatch];
			var len:int = container.length;
			while (--len > -1) {
				var item:EventCore = container[len] as EventCore;
				dispatch.removeEventListener(item.eventName, item.eventListener, item.useCapture);
			}
			listenerDict[dispatch] = undefined;
			delete listenerDict[dispatch];
		}
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
}