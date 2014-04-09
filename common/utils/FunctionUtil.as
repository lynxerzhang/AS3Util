package common.utils 
{
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.Dictionary;
import flash.utils.setInterval;
import flash.utils.setTimeout;

public class FunctionUtil 
{
	public function FunctionUtil() 
	{
	}
	
	/**
	 * 同flash.utils.setTimeout方法 
	 * @param	fun
	 * @param	seconds
	 * @param	...args
	 */
	public static function executeTimeout(fun:Function, seconds:int, ...args):void {
		if (fun in DICT) {
			return;
		}
		var callID:int;
		var f:Function = function():void {
			args.unshift(fun);
			execute.apply(null, args);
			clearTimeout(callID);
			delete DICT[fun];
		}
		seconds *= 1000;
		callID = setTimeout(f, seconds);
		DICT[fun] = callID;
	}
	
	/**
	 * 同flash.utils.setInterval方法 
	 * @param	fun
	 * @param	seconds
	 * @param	count
	 * @param	...args
	 */
	public static function executeTimeInterval(fun:Function, seconds:int, count:int, ...args):void {
		if (fun in DICT) {
			return;
		}
		var callID:int;
		var c:int = 0;
		args.unshift(fun);
		var f:Function = function():void {
			execute.apply(null, args);
			if (++c >= count) {
				clearInterval(callID);
				delete DICT[fun];
			}
		}
		seconds *= 1000;
		callID = setInterval(f, seconds);
		DICT[fun] = callID;
	}
	
	/**
	 * 同flash.utils.clearTimeout方法
	 * @param	fun
	 */
	public static function deleteTimeout(fun:Function):void {
		if (fun in DICT) {
			var id:int = DICT[fun];
			clearTimeout(id);
			delete DICT[fun];
		}
	}
	
	/**
	 * 同flash.utils.clearInterval方法
	 * @param	fun
	 */
	public static function deleteTimeInterval(fun:Function):void {
		if (fun in DICT) {
			var id:int = DICT[fun];
			clearInterval(id);
			delete DICT[fun];
		}
	}
	
	private static const DICT:Dictionary = new Dictionary();
	
	/**
	 * 执行指定方法
	 * @param	fun
	 * @param	...args
	 */
	public static function execute(fun:Function, ...args):void {
		if (args.length == 1 && args[0] is Array) {
			args = args[0];
		}
		var funArgs:int = args.length;
		if (funArgs == 0) {
			fun();
		}
		else if (funArgs == 1) {
			fun(args[0]);
		}
		else if (funArgs == 2) {
			fun(args[0], args[1]);
		}
		else if (funArgs == 3) {
			fun(args[0], args[1], args[2]);
		}
		else {
			fun.apply(null, args);
		}
	}
	
}

}