package common.utils
{
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.IEventDispatcher;

/**
 * @see once
 * @example 
 * this.stage.addEventListener(MouseEvent.CLICK, execute(trace, this, false)(this.stage, "global execute$ method test"));
 * will output scope's name information and provide parameter "global execute$ method test"
 */ 
public function execute(fun:Function, scope:* = null, once:Boolean = false):Function{
	return function(...args):Function{
		return function(evt:Event):void{
			if(scope){
				fun.apply(scope, args);
			}
			else{
				if(args.length == 0){
					fun();
				}
				else{
					fun.apply(null, args);
				}
			}
			if(once){
				IEventDispatcher(evt.currentTarget).removeEventListener(evt.type, arguments.callee, evt.eventPhase == EventPhase.CAPTURING_PHASE);
			}
		}
	}
}
}