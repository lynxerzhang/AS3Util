package common.tool
{
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

public class SingletonMap
{
	public function SingletonMap(){
		SingletonVerify.checkSingleton(this);
	}
	
	public static var instance:SingletonMap = new SingletonMap();
	
	private var map:Dictionary = new Dictionary(false);
	
	public function get(c:Class):*{
		return (map[c]) || (map[c] = new c());
	}
}
}