package utils
{
import flash.utils.describeType;

/**
 * TODO
 * 
 * TrackUtil for debug purpose
 */
public class TraceUtil
{
	/**
	 * get repeat string
	 *
	 * @param str the string value for repeat
	 * @param repeat the repeat value
	 * @return
	 */
	public static function getRepeat(str:String, repeat:int):String {
		//*
		var s:Array = [];
		for (var i:int = 1; i <= repeat; i ++) {
			s[s.length] = str;
		}
		return s.join("");
		/*/
		var s:String = "";
		for(var i:int = 1; i <= repeat; i ++){
			s += str;
		}
		return s;
		//*/
	}
		
	/**
	 * check param o whether has none property
	 * @param o
	 * @return has zero property
	 */
	public static function isEmpty(o:Object):Boolean {
		var item:int = 0;
		for (var i:* in o) {
			item ++;
		}
		return Boolean(item == 0);
	}

	/**
	 * get object's type
	 * @param o
	 * @return get object's type for string format
	 */
	public static function getType(o:Object):String {
		if(!RecordCache.has(o)){
			RecordCache.add(o, describeType(o));
		}
		var xml:XML = RecordCache.get(o);
		return String(xml.@name);
	}
	
	
	/**
	 * prefix to format output data (we need prefix is tab space) 
	 */
	private static var prefix:String = "\t";
	
	
	/**
	 * output function, the initial is trace
	 */
	public static var output:Function = trace;
	
	/**
	 * check the object is whether dynamic
	 * @param o
	 * @return 
	 */
	public static function isDynamic(o:Object):Boolean {
		if(!RecordCache.has(o)){
			RecordCache.add(o, describeType(o));
		}
		var xml:XML = RecordCache.get(o);
		return String(xml.@isDynamic) == "true";
	}
	
	private static var outputstr:String = "";
	
	/**
	 * dump the generic object for debug
	 * this method only run the 'trace' method to dump, not return any value
	 * @param o
	 */
	public static function dump(o:Object):void {
		outputstr = "";
		outputstr += "beginDump ----> {" + "\n";
		outputstr += rdump(o);
		outputstr += "endDump <-----}";
		output(outputstr);
	}//
	
	/**
	 * this method return dump string
	 */ 
	public static function rdump(o:Object, r:int = 1):String {
		//*
		var s:String = "";
		var pre:String = getRepeat(prefix, r);
		for (var item:* in o) {
			if (typeof(o[item]) == "object" && isDynamic(o[item])) {
				s += pre + String(item) + " : " + getType(o[item]) + "{" + "\n";
				var k:int = r;
				s += rdump(o[item], ++k);
				s += pre + "}" + "\n";
			}
			else {
				s += pre + String(item) + " : " + String(o[item]) + " <" + getType(o[item]) + "> " + "\n";
			}
		}
		return s; //1645
		
		/*/
		var ary:Array = [];
		var pre:String = getRepeat(prefix, r);
		for (var item:* in o) {
			if (typeof(o[item]) == "object" && isDynamic(o[item])) {
				ary.push(pre + String(item) + " : " + getType(o[item]) + "{");
				
				var k:int = r;
				ary.push(rdump(o[item], ++k));
				ary.push(pre + "}");
			}
			else {
				ary.push(pre + String(item) + " : " + String(o[item]) + " <" + getType(o[item]) + "> ");
			}
		}
		return ary.join("\n");
		//*/
	}
}
}
import flash.utils.Dictionary;
/**
 * TODO
 * 
 * this class cache "describeType" 's xml
 */ 
internal class RecordCache{
	public function RecordCache():void{
	}
	private static var cache:Dictionary = new Dictionary(true);
	public static function add(o:Object, xml:XML):void{
		if(has(o)){
			return;
		}
		cache[o] = xml;
	}
	// if o is dictionary's internal function's name, 
	// e.g (toString, our xml isn't inject into cache, so just add below test to prevent this case occur) 
	public static function has(o:Object):Boolean{
		return o in cache && typeof(cache[o]) != "function";
	}
	public static function get(o:Object):XML{
		if(has(o)){
			return cache[o];
		}
		return null;
	}
}
