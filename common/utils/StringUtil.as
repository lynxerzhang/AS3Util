package common.utils
{
public class StringUtil 
{	
	/**
	 * 修饰字符串
	 * @param str 目标字符串 
	 * @param args 一个数组传入, 一个对象, 或者一个顺序参数列表
	 * @example
	 *       replaceString("helloWor[0][1]", "l", "d");
	 * 	 replaceString("helloWor[0][1]", ["l", "d"]);
	 *	 replaceString("helloWor[first][last]", {"first":"l", "last":"d"});
	 *       replaceString("he[0][0]oWorld", "l");
	 */
	public static function replaceString(str:String, ...args):String{
		var r:RegExp, provider:Object;
		if(args.length == 1 && typeof(args[0]) == "object" && !args[0] is Array){
			r = /\((?i:[a-z]++)\) | \{(?i:[a-z]++)\} | \[(?i:[a-z]++)\]/gx;
			provider = args[0] as Object;
		}
		else{
			r = /\(\d+\) | \{\d+\} | \[\d+\]/gx;
			if(args[0] is Array){
				provider = args[0] as Array;
			}
			else{
				provider = args;
			}
		}
		str = str.replace(r, function(match:String, ...t):String{
			return provider[match.slice(1, match.length - 1)];
		});
		return str;
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
		return s.replace(/^\s+/g, "");
	}
	
	/**
	 * @param s
	 * @return 
	 * @see trim
	 */
	public static function trimRight(s:String):String{
		return s.replace(/\s+$/g, "");
	}

	/**
	 * 清除指定字符串的左右两边的空白字符
	 * @param s
	 * @return 
	 */
	public static function trim(s:String):String{
		return s.replace(/^\s+|\s+$/g, "");
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
	 * 检查字符串是以指定字符串起始
	 * @param	str
	 * @param	checkStr
	 * @return
	 */
	public static function startWith(str:String, checkStr:String):Boolean {
		return str.slice(0, checkStr.length) == checkStr;
	}
	
	/**
	 * 检查字符串是否以指定字符串结尾
	 * @param	str
	 * @param	checkStr
	 * @return
	 */
	public static function endWith(str:String, checkStr:String):Boolean {
		return str.slice(str.length - checkStr.length, str.length) == checkStr;
	}
	
	/**
	 * 检查指定字符串是否为中文字符串
	 * @param str
	 * @return 
	 */
	public static function isChineseWord(str:String):Boolean {
		chineseWord.lastIndex = 0;
		return chineseWord.test(str);
	}
	
	private static var chineseWord:RegExp = /[\u4e00-\u9fa5]/g;
	
}
}
