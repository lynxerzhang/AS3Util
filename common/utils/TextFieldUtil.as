package common.utils
{
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class TextFieldUtil 
{
	/**
	 * 将指定的字符串均匀分配到指定的文本数组中的文本中
	 * @param	textAry  包含文本对象的数组
	 * @param	textStr  需要在文本中显示的字符串
	 */
	public static function doFlow(textAry:Array, textStr:String = null):void{
		var len:int = textAry.length;
		if (len == 0) {
			return;
		}
		if(!textStr){
			textStr = textAry[0].text;
		}
		
		var txt:TextField;
		var lastIndex:int = 0;
		var nextLineStartCharIndex:int = 0;
		
		for(var i:int = 0; i < len; i ++){
			txt = textAry[i];
			txt.wordWrap = true;
			txt.text = textStr.slice(lastIndex);
			txt.scrollV = 1;
			if(txt.bottomScrollV >= txt.numLines){
				txt.text = textStr.slice(lastIndex);
				lastIndex = textStr.length;
				continue;
			}
			else{
				nextLineStartCharIndex = txt.getLineOffset(txt.bottomScrollV);
			}
			txt.text = textStr.slice(lastIndex, lastIndex + nextLineStartCharIndex);
			lastIndex += nextLineStartCharIndex;
		}
	}
	
	/**
	 * 计算指定文本或字符串对象所包含的"段落"数目, 
	 * 这里的段落指的是字符串用\n分割造的空行分割
	 * @param	txtOrStr
	 * @return
	 */
	private static function getParagraphCount(txtOrStr:*):int{
		var str:String = txtOrStr is TextField ? TextField(txtOrStr).text : txtOrStr;
		return str.split(/[\n\r]{2}/g).length;
	}

	/**
	 * 获取指定文本的可显示行的数目
	 * 也可以将属性scrollV设置为1, 然后获取bottomScrollV的值
	 * @param	txt
	 * @return
	 */
	private static function getTextFieldShowLine(txt:TextField):int{
		return txt.numLines - txt.maxScrollV + 1;
	}

	/**
	 * 获取文本的可显示页面总数
	 * @param	txt
	 * @return
	 */
	private static function getTextFieldTotalPage(txt:TextField):int{
		var n:int = getTextFieldShowLine(txt);
		return Math.ceil(txt.numLines / n);
	}

	/**
	 * 获取指定文本中内容分页显示的字符串
	 * @param	txt
	 * @return
	 */
	public static function getTextFieldParagraphVectorList(txt:TextField):Vector.<String>{
		var c:int = getTextFieldTotalPage(txt);
		var n:int = getTextFieldShowLine(txt);
		
		var maxLine:int = txt.numLines;
		var vectList:Vector.<String> = new Vector.<String>();
		var str:String = txt.text;
		var t:int;
		var offset:int = 0;
		
		txt.scrollV = 1;
		for(var i:int = 0; i < c; i++){
			t = offset;
			if(txt.bottomScrollV >= txt.numLines){
				offset = str.length;
			}
			else{
				offset = txt.getLineOffset(txt.bottomScrollV);
			}
			vectList.push(str.slice(t, offset - 1));
			if(i < c - 1){
				txt.scrollV = Math.min(txt.scrollV + n, txt.maxScrollV);
			}
		}
		return vectList;
	}
	
	/**
	 * 动态创建可供TextField的htmlText属性使用的html文本
	 * @param	str            显示字符串
	 * @param	fontName       字体名
	 * @param	fontSize       字体大小
	 * @param	fontColor      字体颜色
	 * @param	underline      是否具有下划线
	 * @param	clickAble      是否可点击
	 * @example 
	 *		var t:TextField = new TextField();
	 *		//组合的xml文本含有空白字符，所以需要设置该属性，或者将生成的xml文本以换行符截断，消除两端空白
	 *		t.condenseWhite = true; 
	 *		t.border = true;
	 *		t.htmlText = TextFieldUtil.createHtmlText("dynamic create htmlText", "宋体", 12, 0xFF6600, false, true);
	 * @return
	 */
	public static function createHtmlText(str:String, fontName:String, 
											fontSize:int, fontColor:uint, 
											underline:Boolean = false, clickAble:Boolean = false):String {
		
		var fontXML:XML, alignXML:XML, underlineXML:XML, clickXML:XML;	
						
		fontXML = <font></font>;
		fontXML.@face = fontName;
		fontXML.@size = fontSize;
		fontXML.@color = "#" + String(fontColor.toString(16));
		
		alignXML = <p></p>;
		alignXML.@align = TextFormatAlign.LEFT//left
		
		if (underline) {
			underlineXML = <u></u>;
		}
		if (clickAble) {
			clickXML = <a></a>;
			clickXML.@href = "event:";
		}
		
		alignXML.appendChild(fontXML);
		var next:XML = fontXML;
		if (clickAble) {
			next.appendChild(clickXML);
			next = clickXML;
		}
		if (underline) {
			next.appendChild(underlineXML);
			next = underlineXML;
		}
		next.appendChild(String(str));
		
		var n:String = alignXML.toXMLString();
		
		clearXML(fontXML);
		fontXML = null;
		clearXML(alignXML);
		alignXML = null;
		clearXML(underlineXML);
		underlineXML = null;
		clearXML(clickXML);
		clickXML = null;
		clearXML(next);
		next = null;
		
		return n;
	}
	
	private static function clearXML(xml:XML):void {
		if (xml) {
			System.disposeXML(xml);
		}
	}
	
}
}