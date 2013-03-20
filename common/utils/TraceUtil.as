package common.utils
{	
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.getQualifiedClassName;

public class TraceUtil
{
	/**
	 * 将指定的字符串重复指定的次数
	 * @param str
	 * @param repeat
	 * @return 
	 */
	public static function getRepeat(str:String, repeat:int):String {
		var s:String = "";
		for(var i:int = 1; i <= repeat; i ++){
			s += str;
		}
		return s;
	}
	
	/**
	 * 字符串描述格式的格式字符(tab键)
	 */
	private static var prefix:String = "\t";
	
	/**
	 * 默认的输出方法, 为内置的trace方法 
	 */
	public static var output:Function = trace;
	
	/**
	 * 记录当下对象字符串描述格式的字符串
	 */
	private static var outputstr:String = "";
	
	/**
	 * 输出标题 
	 */
	private static var _title:String;

	/**
	 * trace指定对象的内部属性，只针对对象的动态属性,如Object,
	 * 如果为密封类，则不能通过for..in来获取, 可以通过调用describeType来获取xml格式的描述
	 * @param o
	 * @param title
	 */
	public static function dump(o:Object, title:String = null):void {
		_title = title == null ? "" : title;
		outputstr += (_title + "\n");
		outputstr += ("begin Dump ------> " + "{" + "\n");
		outputstr += rdump(o);
		outputstr += ("end Dump ------>" + "}" + "\n");
		output(outputstr);
		outputstr = "";
	}
	
	/**
	 * 返回指定对象的字符串描述格式
	 * @param o
	 * @param r
	 * @return 
	 */
	private static function rdump(o:Object, r:int = 1):String {
		var s:String = "";
		var pre:String = getRepeat(prefix, r);
		var k:int;
		for (var item:* in o) {
			if (typeof(o[item]) == "object") {
				s += pre + String(item) + " : " + type(o[item]) + "{" + "\n";
				k = r;
				s += rdump(o[item], ++k);
				s += pre + "}" + "\n";
			}
			else {
				s += pre + String(item) + " : " + String(o[item]) + " <" + type(o[item]) + "> " + "\n";
			}
		}
		return s;
	}
	
	private static function type(d:Object):String{
		return getQualifiedClassName(d);
	}
	
	/**
	 * 遍历指定显示对象容器, 并将内部显示对象的类型名以字符串格式返回
	 */ 
	public static function dumpDisplayChildren(container:DisplayObjectContainer):String{
		var len:int = container.numChildren;
		var s:String = "dumpDisplayList begin ---- > \n";
		for(var i:int = 0; i < len; i++){
			var t:DisplayObject = container.getChildAt(i);
			s += "depth : " + i + " ----> " + getQualifiedClassName(t) + "\n";
		}
		s += "dumpDisplayList end ---- > \n";
		return s;
	}
}
}

import flash.utils.Dictionary;

/**
 * TODO
 * 
 * this class cache "describeType" 's xml
 */ 
internal class RecordCache
{
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
