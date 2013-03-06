package common.tool
{
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * 
 * map some class with only one instance, 
 * but this class is not provide static 'instance' pattern 
 * 
 * just inside instance into dictionary
 */ 
public class SingletonMap{
	public function SingletonMap(){
		if(instance){
			SingletonVerify.singletonErrorHandle(this);
		}
	}
	
	public static var instance:SingletonMap = new SingletonMap();
	
	private var map:Dictionary = new Dictionary(false);
	
	public function get(c:Class):*{
		return (map[c]) || (map[c] = new c());
	}
}
}