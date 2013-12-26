package common.utils.global
{
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.IEventDispatcher;

/**
 * @see once
 * @example
 * this.stage.addEventListener(MouseEvent.CLICK, event(function(evt:MouseEvent, value:int):void{
 *		trace(evt);
 *		trace(value);
 * }, null)(5));
 * will out put mouseEvent's verbose infomation and a int value 5
 */ 
public function event(fun:Function, scope:* = null, once:Boolean = false):Function{
	return function(...args):Function{
		return function(evt:Event):void{
			if(scope){
				fun.apply(scope, [evt].concat(args));
			}
			else{
				if(fun.length == 1){
					fun(evt);
				}
				else{
					fun.apply(null, [evt].concat(args));
				}
			}
			if(once){
				IEventDispatcher(evt.currentTarget).removeEventListener(evt.type, arguments.callee, evt.eventPhase == EventPhase.CAPTURING_PHASE);
			}
		}
	}
}
}
