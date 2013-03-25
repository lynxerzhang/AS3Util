package common.utils
{
public class StringUtil 
{
	/**
	 * @param check
	 * @param ary
	 * @return 
	 * @see replaceMultiVal
	 *  @example 
	 *  s = h[0][1][2]o， world
	 *  replaceMultiVal(s, ["e", "l", "l"]);
	 */
	public static function replaceSingleVal(check:String, ary:Array):String {
		if (!ary || !check) {
			return null;
		}
		//var r:RegExp = new RegExp("[\\d+]", "g");
		var r:RegExp = /\[\d+\]/g; //heacache
		var s:Array = check.match(r);
		if (!s || s.length < ary.length) {
			trace("result array less than matched array length");
			return null;
		}
		var len:int = s.length;
		for (var i:int = 0; i < len; i ++) {
			check = check.replace("[" + i + "]", ary[i]);
		}
		return check;
	}
	
	/**
	 * 将指定的字符串中的[0]符号换为指定的数组中指定的值，容许相同的符号定义
	 * @param check
	 * @param ary
	 * @return 
	 * @example 
	 *  s = h[0][1][1]o， world
	 *  replaceMultiVal(s, ["e", "l"]);
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
	 * 获取指定字符串的文件名, 同getFileName方法, 只是该方法只获取字符串中的数值部分
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
	 * 获取文件名
	 * @param url
	 * @return 
	 */
	public static function getFileName(url:String):String{
		return url.slice(url.lastIndexOf("/") + 1, url.lastIndexOf("."));
	}
	
	/**
	 * @param s
	 * @return 
	 * @see trim
	 */
	public static function trimLeft(s:String):String{
		return s.replace(/^\s*/g, "");
	}
	
	/**
	 * @param s
	 * @return 
	 * @see trim
	 */
	public static function trimRight(s:String):String{
		return s.replace(/\s*$/g, "");
	}

	/**
	 * 清除指定字符串的左右两边的空白字符
	 * @param s
	 * @return 
	 */
	public static function trim(s:String):String{
		return s.replace(/^\s*|\s*$/g, "");
	}
	
	/**
	 * 检查字符串是否为空字符串
	 * @param s
	 * @return 
	 */
	public static function isEmpty(s:String):Boolean{
		return trim(s) == "";
	}
	
	/**
	 * 检查指定字符串中是否包含指定子字符串
	 * @param str
	 * @param mathStr
	 * @return 
	 */
	public static function contain(str:String, subStr:String):Boolean{
		var index:int = str.indexOf(subStr);
		if(index != -1){
			return str.substr(index, subStr.length) == subStr;
		}
		return false;
	}
	
	/**
	 * 检查指定字符串是否为中文字符串
	 * @param str
	 * @return 
	 */
	public static function isNotChineseWord(str:String):Boolean{
		return chineseWordReg.test(str);
	}
	
	private static var chineseWordReg:RegExp = /[^\u4e00-\u9fa5]/g;
	
}
}