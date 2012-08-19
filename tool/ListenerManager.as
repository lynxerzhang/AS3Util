package tool
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
	
/**
 * TODO
 * this class is used to manager eventdispatcher's listener
 * 
 */
public class ListenerManager {
	
	private var listenerDict:Dictionary;
	
	/**
	 * constructor
	 */
	public function ListenerManager():void {
		listenerDict = new Dictionary(false);	
	}
	
	/**
	 * map a listener with specific event
	 * 
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
		container[container.length] = data;
	}
	
	/**
	 * remove a listener with a specific dispatch
	 * 
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
	 * remove all eventdispatcher's listener
	 */
	public function removeAll():void {
		for (var item:* in listenerDict) {
			removeAllListeners(item as EventDispatcher);
		}
	}
	
	/**
	 * 
	 * dipose all eventdispatcher
	 */
	public function dispose():void {
		removeAll();
		listenerDict = new Dictionary(false);
	}
	
	/**
	 * remove all listener specific eventdispatcher
	 * 
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
	 * record dispatcher
	 */
	public var dispatcher:EventDispatcher;
	
	/**
	 * record event's name
	 */
	public var eventName:String;
	
	/**
	 * record event's listener
	 */
	public var eventListener:Function;
	
	/**
	 * record event's capture
	 */
	public var useCapture:Boolean;
}