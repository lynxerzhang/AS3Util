package common.tool
{
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * 提供单例类的验证 
 */
public class SingletonVerify
{
	private static const reference:Dictionary = new Dictionary(false);
	
	public function SingletonVerify(instance:*, c_class:Class){
		//use c_class's static propery 'instance' to get c_class object, c_class will be null
		//and use 'new' operator, this argument c_class is not null
		verify(instance, c_class);
	}
	
	private function verify(o:*, c:Class):void{
		if(c){
			throw new Error(getQualifiedClassName(o) + " <---> " + "do not use 'new' to get instance, use this class's static propery 'instance'");
		}
		
		var cd:Class = (o as Object).constructor as Class;
		
		if(reference[cd]){
			//may be never run this 
			//but add this logic to judge your class maybe have more than one 'instance' style propery
			throw new Error(getQualifiedClassName(o) + " <---> " + 'singletonError');
		}
		else{
			reference[cd] = true;
		}	
	}
	
	private static const singletonMessage:String = "do no use 'new' to get instance, use this class's static property 'instance'";
	
	private static function singletonErrorHandle(c:Object):void{
		throw new IllegalOperationError("<" + getQualifiedClassName(c) + ">" + " is singleton class, " + SingletonVerify.singletonMessage);
	}

	public static function checkSingleton(d:Object):void {
		var c:Class = (d.constructor) as Class;
		if ((c && c["instance"]) || (c["instance"] === undefined)) {
			singletonErrorHandle(d);
		}
	}
}
}

