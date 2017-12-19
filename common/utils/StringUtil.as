package common.utils
{

public class StringUtil 
{	
	private static const HELPER_MATCH_RESULT:Array = [];
	/**
	 * 根据给定的正则表达式返回匹配的字符串
	 * 
	 * @param str		指定字符串
	 * @param reg		待匹配的正则表达式
	 * @param result	返回匹配结果数组
	 */ 
	public static function getMatch(str:String, reg:RegExp, result:Array = null):Array
	{
		if(!result){
			result = HELPER_MATCH_RESULT;
		}
		result.length = 0;
		if(reg){
			reg.lastIndex = 0;
			if(reg.test(str)){
				reg.lastIndex = 0;
				var d:Object;
				do{
					d = reg.exec(str);
					if(d){
						if(d.index == reg.lastIndex){
							//prevent infinite loop
							break;
						}
						if(d.length >= 1){
							result.push(d[0]);
						}
					}
				}
				while(d)
			}
		}
		return result;
	}
	
	/**
	 * @see getMatch
	 * @param str		指定字符串
	 * @param reg		待匹配的正则表达式
	 * @param result	返回匹配结果数组
	 * @param titleName	用于标识数组中存储对象的type字符串
	 */
	public static function createTypeMatch(str:String, reg:RegExp, result:Array = null, 
								titleName:String = null):Array
	{
		if(!result){
			result = [];
		}
		else{
			result.length = 0;
		}
		
		if(reg){
			reg.lastIndex = 0;
			if(reg.test(str)){
				reg.lastIndex = 0;
				var d:Object;
				var r:Object;
				do{
					d = reg.exec(str);
					if(d){
						if(d.index == reg.lastIndex){
							//prevent infinite loop
							break;
						}
						if(d.length >= 1){
							r = {};
							//
							if(titleName != null){
								r.type = titleName;
							}
							r.index = d.index;
							r.content = d[0];
							result.push(r);
						}
					}
				}
				while(d)
			}
		}
		return result;
	}
	
	/**
	 * 修饰字符串
	 * @param str 目标字符串 
	 * @param args 一个数组传入, 一个对象, 或者一个顺序参数列表
	 * 
	 * @example
	 *    replaceString("helloWor[0][1]", "l", "d");
	 *    replaceString("helloWor[0][1]", ["l", "d"]);
	 *    replaceString("helloWor[first][last]", {"first":"l", "last":"d"});
	 *    replaceString("he[0][0]oWorld", "l");
	 */
	public static function replaceString(str:String, ...args):String{
		var r:RegExp, provider:Object;
		if(args.length == 1 && typeof(args[0]) == "object" && !(args[0] is Array)){
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
	 * 修饰字符串并返回修饰字符串的起始和终止索引
	 */
	public static function replaceString2(str:String, ...args):Array{
		var r:RegExp, provider:Object;
		if(args.length == 1 && typeof(args[0]) == "object" && !(args[0] is Array)){
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
		var matchIndex:Array = [];
		var results:String;
		str = str.replace(r, function(match:String, ...t):String{
			results = String(provider[match.slice(1, match.length - 1)]);
			matchIndex.push(t[0], t[1], match, results);
			return results;
		});
		
		var formatAry:Array = [];
		var i:int = 0;
		formatAry.push({s:matchIndex[i], e:matchIndex[i] + String(matchIndex[i + 3]).length});
		
		var offset:int = 0;
		var addOffset:int = 0;
		
		i = 4;
		var sIndex:int = 0;
		var eIndex:int = 0;
		for(var len:int = matchIndex.length; i < len; i +=4){
			offset += String(matchIndex[i - 2]).length;
			addOffset += String(matchIndex[i - 1]).length;
			sIndex = matchIndex[i] - offset + addOffset;
			eIndex =  sIndex +  String(matchIndex[i + 3]).length;
			formatAry.push({s:sIndex, e:eIndex});	
		}
		formatAry.content = str;
		return formatAry;
	}
	
	/**
	 * 按照指定次数复制字符串	
 	 */ 
	public static function repeat(value:String, repeatCount:int):String{
		return new Array(repeatCount + 1).join(value);
	}
	
	/**
	 * 删除额外换行符
	 */ 	
	public static function removeExtraNewLine(str:String):String
	{
		str = str.split("\r\n").join("\n");
		return str;
	}
	
	private static const ENG_WORD:RegExp = /[a-z]+/gi;
	
	/**
	 * 检查指定字符是否为英文字符
	 */ 
	public static function isEngWord(word:String):Boolean
	{
		ENG_WORD.lastIndex = 0;
		if(ENG_WORD.test(word)){
			ENG_WORD.lastIndex = 0;
			var k:Array = word.match(ENG_WORD);
			if(k && k.length == 1 && k[0].length == word.length){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 替换指定的字符
	 * @param input
	 * @param replace
	 * @param replaceWith
	 * @return 
	 * 
	 */	
	public static function replace(str:String, replace:String, replaceWith:String):String
	{
		return str.split(replace).join(replaceWith);
	}
	
	/**
	 * 解码指定字符串中html的字符
	 * @param s
	 * @return 
	 * @see	https://github.com/as3/as3-utils
	 */	
	public static function htmlDecode(s:String):String
	{
		for(var item:* in HTML_DECODE){
			s = replace(s, String(item), String(HTML_DECODE[item]));
		}
		return s;
	}
	
	private static const HTML_DECODE:Object = {"&nbsp;":" ", 
							"&amp;":"&", 
							"&lt;":"<", 
							"&gt;":">",
							"&trade;":'™', 
							"&reg;":"®", 
							"&copy;":"©", 
							"&euro;":"€", 
							"&pound;":"£", 
							"&mdash;":"—",
							"&ndash;":"–", 
							"&hellip;":'…', 
							"&dagger;":"†", 
							"&middot;":'·', 
							"&micro;":"µ", 
							"&laquo;":"«",
							"&raquo;":"»", 
							"&bull;":"•", 
							"&deg;":"°", 
							"&ldquo":'"', 
							"&rsquo;":"'", 
							"&rdquo;":'"', 
							"&quot;":'"'};
	
	/**
	 * 剔除指定字符串起始位置的所有空白字符
	 * @param s
	 * @return 
	 * @see trim
	 */
	public static function trimLeft(s:String):String{
		return s.replace(/^\s+/g, "");
	}
	
	/**
	 * 剔除指定字符串结尾部分的所有空白字符
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
	 * 
	 *  移除字符串头部包含空行的字符, 但不替换空白字符
	 * @param	s
	 * @return
	 */
	public static function trimStartWrapline(s:String):String {
		return s.replace(/^\s*[\r\n]/, "");
	}
	
	/**
	 *  移除字符串尾部包含空行的字符, 但不替换空白字符
	 * @param	str
	 * @return
	 */
	public static function trimEndWrapline(str:String):String{
		return str.replace(/[\n\r]\s*$/, "");
	}
	
	private static var padHelperAry:Array = [];
	
	/**
	 * 在指定字符串起始位置添加填充字符
	 * @param	raw       原始字符串
	 * @param	padStr    填充字符
	 * @param	padCount  填充字符的数量
	 * @return
	 */
	public static function padLeft(raw:String, padStr:String, padCount:uint):String {
		padHelperAry.length = padCount + 1;
		return raw.replace(/^/, padHelperAry.join(padStr));
	}
	
	/**
	 * 在指定字符串结束位置添加填充字符
	 * @param	raw       原始字符串
	 * @param	padStr    填充字符
	 * @param	padCount  填充字符的数量
	 * @return
	 */
	public static function padRight(raw:String, padStr:String, padCount:uint):String {
		padHelperAry.length = padCount + 1;
		return raw.replace(/$/, padHelperAry.join(padStr)); 	
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
	 * 翻转指定字符串
	 * @param	str
	 * @return
	 */
	public static function reverse(str:String):String {
		//return str.split("").reverse().join(""); //执行速度稍慢
		var i:int = str.length, d:String = "";
		while(i--){
			d += str.charAt(i);
		}
		return d;
	}
	
	/**
	 * 移除指定字符串
	 * @param	str
	 * @param	deleteStr
	 * @param	regFlags gixsm
	 * @return
	 */
	public static function remove(str:String, deleteStr:String, regFlags:String = "g"):String {
		//@see http://blog.stevenlevithan.com/archives/javascript-match-nested
		var metaChar:RegExp = /[-[\]{}()*+?.\\^$|,]/g;
		if (metaChar.test(deleteStr)) {
			deleteStr = deleteStr.replace(metaChar, "\\$&");
		}
		return str.replace(new RegExp(deleteStr, regFlags), "");
	}
	
	/**
	 * 移除指定索引间的字符串
	 * @param	str
	 * @param	startIndex
	 * @param	endIndex
	 * @return
	 */
	public static function removeSlice(str:String, startIndex:int, endIndex:int):String {
		var removeStr:String = str.slice(startIndex, endIndex);
		return remove(str, removeStr, null);
	}
	
	/**
	 * 判断指定的字符串是否为数值类型字符串
	 * @param	str
	 * @return
	 */
	public static function isNum(str:String):Boolean {
		//parseFloat可以忽略字符串起始和结尾的字符
		//return str && parseFloat(str) != NaN; 
		return str && /^[-+]?\d*+(?:\.?\d+)?(?:(?i:e)[-+]?\d+)?$/.test(str);
	}
	
	/**
	 * 检查指定字符串是否包含数值字符串
	 * @param	str
	 * @return
	 */
	public static function hasNum(str:String):Boolean {
		return str && /[-+]?\d*(?:\.?\d+)(?:(?i:e)[-+]?\d+)?/.test(str);
	}

	/**
	 * 用于对包含数值类型的字符串的数组的排序方法
	 * @param	a
	 * @param	b
	 * 
	 * @example 
	 *	var r:Array = ["result1", "result111", "result9"];
	 *	r.sort(StringUtil.alphaNumericSort); //result1, result9, result111
	 *   
	 * @see 
	 * 	http://www.breaktrycatch.com/alphanumeric-sorting-in-as3/
	 *  该实现没有对数值是否包含小数点或者有前缀0做判断         
	 *  
	 *  由此参考了 http://www.davekoelle.com/alphanum.html 中js版本
	 *  同时参考了 http://my.opera.com/GreyWyvern/blog/show.dml/1671288 后继评论中
	 *  使用正则来生成数组的方法
	 * @return
	 */
	public static function alphaNumericSort(a:String, b:String):int {
		var reg:RegExp = /([-+]?\d*(?:\.?\d+)(?:(?i:e)[-+]?\d+)?)/;
		var ka:Array = a.split(reg);
		var kb:Array = b.split(reg);
		var s1:String, s2:String;
		var n1:Number, n2:Number;
		for (var i:int = 0; ((s1 = ka[i]) && (s2 = kb[i])); i ++) {
			if (s1 !== s2) {
				//使用parseFloat是考虑parseFloat可以解析诸如(5e2)的科学计数法
				n1 = parseFloat(s1);
				n2 = parseFloat(s2);
				if (isNaN(n1) || isNaN(n2)) {
					return s1 < s2 ? -1 : 1;
				}
				return n1 - n2;	
			}
		}
		return ka.length - kb.length;
	}
	
	/**
	 * 返回以起始字符为标识的嵌套结构, 将匹配的字符串以数组形式返回
	 * @param	str		目标字符串
	 * @param	start		起始标识字符串
	 * @param	end		结束标识字符串
	 * @param	useRegStyle  	是否使用RegExp格式约束起始和结束标识字符串
	 * @see 	http://blog.stevenlevithan.com/archives/javascript-match-nested
	 * 
	 * @return
	 */
	public static function matchRecursive(str:String, start:String, end:String, useRegStyle:Boolean = false):Array {
		if (!useRegStyle) {
			var metaCharacter:RegExp = /[^\w]/g;//TODO:
			start = start.replace(metaCharacter, "\\$&");
			end = end.replace(metaCharacter, "\\$&");
		}
		var result:Array = [];
		if (start != end) {
			var m:RegExp = new RegExp(start + "|" + end, "g");
			var s:RegExp = new RegExp(start);
			var o:int, c:int, d:Object;
			do {
				o = 0;
				while ((d = m.exec(str)) != null) {
					if (s.test(d[0])) {
						if (!o++) {
							c = m.lastIndex;
						}
					}
					else if (o) {
						if (!--o) {
							result.push(str.slice(c, d.index));
						}
					}
				}
			}
			while (o && ((m.lastIndex = c) > -1));
		}
		return result;
	}
	
	/**
	 * 编码html
	 * @param	str
	 * @see http://www.razorberry.com/blog/archives/2007/11/02/converting-html-entities-in-as3/
	 * @see http://stackoverflow.com/questions/1856726/how-do-you-encode-xml-safely-with-actionscript-3
	 * @return
	 */
	public static function escapeHtml(str:String):String {
		var t:XML = <xml/>;
		t.appendChild(str);
		return t.*[0].toXMLString();
	}
	
	/**
	 * 解码html
	 * @param	str
	 * @return
	 */
	public static function unescapeHtml(str:String):String{
		return XMLList(str).toString();
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
	
	
	private static const STYLE_HELP_ARY:Array = [];
	private static const STYLE_REG:RegExp = /{(.*?)}/g;
	
	/**
	 * 剔除字符串中含有成对的{}字符，并记录索引，可以为后继文本变色提供索引
	 * @param str
	 * @return 
	 */
	public static function styleString(str:String):Array
	{
		var reg:RegExp = STYLE_REG;
		var result:Array = STYLE_HELP_ARY;
		result.length = 0;
		if(reg.test(str)){
			reg.lastIndex = 0;
			var d:Object;
			var s:int = 0;
			while((d = reg.exec(str)) != null){
				s = str.indexOf(d[1], s);
				result.push([s, s + d[1].length]);
				s += 1;
			}
			var len:int = result.length;
			for(var i:int = 0; i < len; i ++){
				result[i][0] -= (1 + i * 2);
				result[i][1] -= (1 + i * 2);
			}
			result.content = str.replace(reg, "$1");
		}
		else{
			result.content = str;
		}
		return result;
	}	
}
}
