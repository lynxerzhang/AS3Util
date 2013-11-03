package common.utils
{
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.IEventDispatcher;

/**
 * 仅执行一次事件处理方法, 随即删除
 * @see http://stackoverflow.com/questions/2476386/as3-event-listener-that-only-fires-once?rq=1
 * @example
 * this.stage.addEventListener(MouseEvent.CLICK, once(function(evt:MouseEvent):void{
 * 		trace("only trace once", this.stage);
 * }, this)); //传入this是为保证在监听函数方法内部能正确使用this
 */ 
public function once(fun:Function, scope:* = null):Function{
	return function(evt:Event):void{
		if(scope){
			fun.call(scope, evt);
		}
		else{
			fun(evt);
		}
		IEventDispatcher(evt.currentTarget).removeEventListener(evt.type, arguments.callee, evt.eventPhase == EventPhase.CAPTURING_PHASE);
	}
}
}