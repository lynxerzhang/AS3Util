package common.utils
{
import flash.text.TextField;
import flash.text.TextFormat;

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
}
}