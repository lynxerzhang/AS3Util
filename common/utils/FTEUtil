package common.utils
{
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;

public class FTEUtil
{
	public function FTEUtil()
	{
		//flash text engine
	}
	
	/**
	 * 创建一个单行的TextLine
	 */	
	public static function createSingleTextLine(str:String, color:uint = 0x000000, size:int = 12,
								width:Number = NaN, font:FontDescription = null):TextLine
	{
		if(!font){
			font = new FontDescription("Microsoft YaHei, _sans");
		}
		var format:ElementFormat = new ElementFormat(font);
		format.color = color;
		format.fontSize = size;
		var textblock:TextBlock = new TextBlock(new TextElement(str, format));
		if(width != width){
			width = 1000000;
		}
		var textLine:TextLine = textblock.createTextLine(null, width);
		textblock.releaseLineCreationData();
		return textLine;
	}
}
}
