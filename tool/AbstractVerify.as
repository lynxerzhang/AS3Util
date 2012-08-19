package tool
{
import flash.utils.getQualifiedClassName;	
	
/**
 * for abstract verify
 * 
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
			throw new Error(getQualifiedClassName(o) + " ---> " + 'abstractError');
		}
	}
}
}