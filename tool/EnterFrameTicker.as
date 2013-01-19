package tool
{
import flash.display.Shape;
import flash.errors.IllegalOperationError;
import flash.events.Event;

import tool.Signal;
	
public class EnterFrameTicker
{
	public function EnterFrameTicker()
	{
		if(instance){
			throw new IllegalOperationError(SingletonVerify.singletonMessage);
		}
	}
	
	public static var instance:EnterFrameTicker = new EnterFrameTicker();
	
	private var tick:Map = new Map();
	
	private function __add():void{
		dispatcher.addEventListener(Event.ENTER_FRAME, tickHandler);
	}
	
	private function __remove():void{
		dispatcher.removeEventListener(Event.ENTER_FRAME, tickHandler);
	}
	
	public function addTickListener(fun:Function, ...args):void{
		tick.add(fun, args);
		if(!tick.isEmpty()){
			__add();
		}
	} 
	
	public function removeTickListener(fun:Function):void{
		tick.remove(fun);
		if(tick.isEmpty()){
			__remove();
		}
	} 
	
	private function tickHandler(evt:Event):void{
		tick.forEachKey(function(fun:Function):void{
			fun.apply(null, tick.get(fun));
		});
	} 
	
	private static var dispatcher:Shape = new Shape();
}

}