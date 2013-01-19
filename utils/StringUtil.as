package utils
{
import flash.text.TextField;
import flash.text.TextFormat;
	
public class StringUtil 
{
	
	/**
	 * @example
	 * TODO
	 *
	 * var s:String = "***[0]***[1]***[2]***"
	 * s = replace(s, ["1", "2", "3"]);
	 * //trace(s);
	 *
	 * @param check
	 * @param ary
	 * @return
	 */
	public static function replaceSingleVal(check:String, ary:Array):String {
		if (!ary || !check) {
			return null;
		}
		//var r:RegExp = new RegExp("[\\d+]", "g");
		var r:RegExp = /\[\d+\]/g; //heacache
		var s:Array = check.match(r);
		if (!s || s.length < ary.length) {
			trace("StringUtil's method replace's second arguments length is less than match length");
			return null;
		}
		var len:int = s.length;
		for (var i:int = 0; i < len; i ++) {
			check = check.replace("[" + i + "]", ary[i]);
		}
		return check;
	}
	
	/**
	 * @example
	 * TODO
	 *
	 * var s:String = "***[1]***[0]***[0]***"
	 * s = replace(s, ["1", "2"]);
	 * //trace(s);
	 *
	 * this method can replace Multi-same variable(e.g. above example's [0])
	 * 
	 * @param check
	 * @param ary
	 * @return
	 */
	public static function replaceMultiVal(check:String, ary:Array):String {
		if (!check || !ary) {
			return null;
		}
		var r:RegExp = /\[\d+\]/g;
		var s:Array = check.match(r);
		var d:Array = ArrayUtil.getUnique(s);
		var len:int = d.length;
		for (var i:int = 0; i < len; i ++) {
			check = check.replace(new RegExp("\\[" + i + "\\]", "g"), ary[i])
		}
		return check;
	}
	
	/**
	 * @example
	 * var s:String = "task/1009.png";
	 * var r:RegExp = /\/([0-9]+).(png|jpg)/g;
	 * will get 1009
	 */ 
	public static function getLoadResourceName(url:String, enforce:Class = null):*{
		var r:RegExp = /\/([0-9]+).(png|jpg)/g;
		if(r.test(url)){
			r.lastIndex = 0;
			var d:Array = r.exec(url) as Array;
			if(d){
				return enforce == null ? d[1] : enforce(d[1]);
			}
		}
		return null;
	}
	
	/**
	 * @example source/test.swf will return test
	 */ 
	public static function getFileName(url:String):String{
		return url.slice(url.lastIndexOf("/") + 1, url.lastIndexOf("."));
	}
	
	/**
	 * TODO
	 * trim Left string's empty character
	 */ 
	public static function trimLeft(s:String):String{
		return s.replace(/^\s*/g, "");
	}
	
	/**
	 * TODO
	 * trim right string's empty character
	 */ 
	public static function trimRight(s:String):String{
		return s.replace(/\s*$/g, "");
	}

	/**
	 * TODO
	 * trim string's leftmost and rightmost's empty character
	 */ 
	public static function trim(s:String):String{
		return s.replace(/^\s*|\s*$/g, "");
	}
	
	/**
	 * check string is whether empty
	 */ 
	public static function isEmptyBuffer(s:String):Boolean{
		return trim(s) == "";
	}
	
	/**
	 * check contain specfied string
	 */ 
	public static function contain(str:String, mathStr:String):Boolean{
		var fi:int = str.indexOf(mathStr);
		if(fi != -1){
			return str.substr(fi, mathStr.length) == mathStr;
		}
		return false;
	}
	
	/**
	 * TODO
	 * from google search
	 */ 
	public static function isNotChineseWord(str:String):Boolean{
		return chineseWordReg.test(str);
	}
	
	private static var chineseWordReg:RegExp = /[^\u4e00-\u9fa5]/g;
	
}
}