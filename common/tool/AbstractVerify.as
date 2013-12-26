package common.tool
{
import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;
	
/**
 * 提供抽象类的验证
 * @example
 * 
 * class Test{
 * 		function Test():void{
 * 			new AbstractVerify(this, Test);
 * 		}
 * }
 */ 	
public class AbstractVerify
{
	public function AbstractVerify(instance:*, a_class:Class):void{
		verify(instance, a_class);
	}
	
	private function verify(o:*, c:Class):void{
		var d:Object = o as Object;
		if(d && Class(d.constructor) == c){
			throw new IllegalOperationError(getQualifiedClassName(o) + " ---> " + 'abstractError');
		}
	}
	
	private static function abstractErrorHandle(d:Object, c:Class):void{
		throw new IllegalOperationError("<" + String(c) + ">" + " is abstract class. ");
	}

	public static function checkAbstract(d:Object, c:Class):void {
		var ds:Object = d as Object;
		if(ds && Class(ds.constructor) == c){
			abstractErrorHandle(ds, c);
		}
	}
}
}