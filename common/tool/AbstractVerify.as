package common.tool
{
import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;
	
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
}
}