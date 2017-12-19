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
	
	/**
	 * 获取指定TextLine的长度 （如果文本中含有空白字符，那么textwidth和width属性都会舍去这个空白字符）
	 */
	public static function getTextLineWidth(textLine:TextLine):Number
	{
		var width:Number = 0;
		if(textLine.atomCount != 0){
			var endIndex:int = textLine.atomCount - 1;
			var bounds:Rectangle = textLine.getAtomBounds(endIndex);
			width = bounds.right;
		}
		return width;
	}
	
	/**
	 * 获取指定字符串长度
	 * var anchor:String = "🐲🐲💩💩💩❤️❤️";
	 * trace(getLength(anchor)); //7
	 */
	public static function getLength(str:String):int 
	{
		var textBlock:TextBlock = new TextBlock();
		var fontDescription:FontDescription = new FontDescription();
		var format:ElementFormat = new ElementFormat(fontDescription, 12);
		var textElement:TextElement = new TextElement(str, format);
		textBlock.content = textElement;
		var textLine:TextLine = textBlock.createTextLine();
		textBlock.releaseLineCreationData();
		return textLine.atomCount;
	}
}
}
