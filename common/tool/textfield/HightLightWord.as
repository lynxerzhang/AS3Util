package common.tool.textfield 
{
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;

/**
 * 高亮指定字符
 * 
 * Martin Raedlinger 有个类似的实现com.formatlos.as3.lib.text.highlight.TextHighlighter
 * 但是只能对非滚动的文本高亮
 * 
 * @example
 * var hightd:HightLightWord = new HightLightWord(200, 200, 0xFF6600, .2);
 * //文本需要先添加至舞台, 不然文本内部初始化的属性等获取会有问题, 
 * //也可以使用BitmapData的draw强制重绘, 或者监听监听至舞台事件，或者纯粹延迟帧
 * addChild(hightd); 
 * 
 * hightd.setText("HightLightWord, hello highlight");
 * hightd.highLightWord("hello");
 */
public class HightLightWord extends Sprite
{
	private var wordRenderShape:Shape;
	private var wordTxt:TextField;
	private var wordColor:uint;
	private var wordAlpha:Number;
	
	/**
	 * 
	 * @param	width  文本长度
	 * @param	height 文本高度
	 * @param	color  高亮色彩
	 * @param	alpha  高亮透明度
	 */
	public function HightLightWord(width:Number, height:Number, color:uint, alpha:Number) 
	{
		wordColor = color;
		wordAlpha = alpha;
		
		wordRenderShape = new Shape();
		wordTxt = new TextField();
		wordTxt.wordWrap = true;
		wordTxt.addEventListener(Event.SCROLL, scrollHandler);
		wordTxt.width = width;
		wordTxt.height = height;
		wordTxt.border = true;
		wordTxt.background = true;
		
		addChild(wordTxt);
		addChild(wordRenderShape);
	}
	
	/**
	 * 设置文本内容
	 * @param	txtStr
	 */
	public function setText(txtStr:String):void {
		wordTxt.text = txtStr;
	}
	
	/**
	 * 获取文本内容
	 * @return
	 */
	public function getText():String {
		return wordTxt.text;
	}
	
	private var lastRegExp:RegExp;
	private var lastResult:Object;
	
	/**
	 * 高亮所需的字符, 支持正则和字符串结构, 反复调用只会保留最近生成的正则表达式
	 * 
	 * 
	 * @example
	 * showHightLight(/\w+/g);
	 * showHightLight("highLightTest");
	 * showHightLight("highLight", "Test", "yeah!");
	 * 
	 * @param	...args
	 */
	public function highLightWord(...args):void {
		if(args.length == 1){
			if(args[0] is RegExp){
				lastRegExp = args[0] as RegExp;
			}
			else{
				lastRegExp = new RegExp(String(args[0]), "g");
			}
		}
		else{
			var argLen:int = args.length;
			var argStr:String = "";
			var argAry:Array = [];
			for(var i:int = 0; i < argLen; i ++){
				argAry.push(String(args[i]));
			}
			lastRegExp = new RegExp(argAry.join("|"), "g");
		}
		var str:String = wordTxt.text;
		if(str.length > 0){
			if (lastRegExp.test(str)) {
				doDrawWord(str);
			}
		}
	}
	
	/**
	 * 清除所有的高亮选择
	 */
	public function clear():void {
		wordRenderShape.graphics.clear();
	}
	
	/**
	 * 清除监听
	 */
	public function dispose():void {
		clear();
		wordTxt.removeEventListener(Event.SCROLL, scrollHandler);
	}
	
	private function scrollHandler(evt:Event):void {
		var str:String = wordTxt.text;
		clear();
		doDrawWord(str);
	}

	private function wordRender(color:uint, alpha:Number, rect:Rectangle, needClear:Boolean = false):void{
		var g:Graphics = wordRenderShape.graphics;
		if(needClear){
			g.clear();
		}
		g.beginFill(color, alpha);
		g.drawRect(rect.x, rect.y, rect.width, rect.height);
		g.endFill();
	}
	
	private function doDrawWord(str:String):void {
		if(lastRegExp){
			lastRegExp.lastIndex = 0;
			lastResult = lastRegExp.exec(str);
			do {
				if (lastResult) {
					drawChar(lastResult.index, lastResult.index + lastResult.toString().length - 1);
					if(lastResult.index == lastRegExp.lastIndex){
						//lastRegExp.lastIndex += 1;
						//如果lastIndex一旦和index属性相同, 则会导致无限制循环
						break;
					}
				}
			}while (lastResult && (lastResult = lastRegExp.exec(str)));
		}
	}
	
	private function drawChar(startIndex:int, endIndex:int):void{
		var str:String = wordTxt.text;
		
		if(startIndex < 0){
			startIndex = 0;
		}
		if(endIndex > str.length - 1){
			endIndex = str.length - 1;
		}
		if (startIndex > endIndex) {
			var temp:int = startIndex;
			startIndex = endIndex;
			endIndex = temp;
		}
		
		var currentScrollRow:int = wordTxt.scrollV;
		var maxScrollRow:int = wordTxt.maxScrollV;
		var currentMaxScrollRow:int = wordTxt.bottomScrollV;
		
		var startLine:int = wordTxt.getLineIndexOfChar(startIndex);
		var endLine:int = wordTxt.getLineIndexOfChar(endIndex);
	
		if ((startLine + 1 >= currentScrollRow) && (endLine + 1 <= currentMaxScrollRow) ||
				(startLine + 1 < currentScrollRow) && ((endLine + 1 <= currentMaxScrollRow) && (endLine + 1 >= currentScrollRow)) ||
					(startLine + 1 >= currentScrollRow) && (startLine + 1 <= currentMaxScrollRow && (endLine + 1 > currentMaxScrollRow)) ||
						(startLine + 1 < currentScrollRow) && (endLine + 1 > currentMaxScrollRow))
		{
			
			if (startIndex == endIndex) {
				//单个字符
				var charRect:Rectangle = wordTxt.getCharBoundaries(startIndex);
				if(charRect){
					wordRender(wordColor, wordAlpha, charRect);
				}
			}
			else {
				var startCharRect:Rectangle;
				var endCharRect:Rectangle;
				
				if (startLine == endLine) {
					//单行中的匹配
					startCharRect = wordTxt.getCharBoundaries(startIndex);
					endCharRect = wordTxt.getCharBoundaries(endIndex);
					//需要对返回的矩形做为空判断, 因为可能这个字符是\n换行符或\r回车符
					if(startCharRect != null && endCharRect != null){
						startCharRect.width = (endCharRect.x - startCharRect.x) + endCharRect.width;
						wordRender(wordColor, wordAlpha, startCharRect);
					}
				}
				else {
					//跨行匹配
					var t:int = startLine; //起始行
					var d:int = startIndex; //起始字符
					var sumLineLength:int;
					
					var s:int = wordTxt.getLineIndexOfChar(d);
					if((s + 1) < currentScrollRow){
						d = wordTxt.getLineOffset(currentScrollRow - 1);
						sumLineLength = d;
					}
					else{
						if(t != 0){
							sumLineLength = wordTxt.getLineOffset(t);
						}
					}
					
					if (t < currentScrollRow - 1) {
						t = currentScrollRow - 1;
					}
					
					var lineLength:int;
					while ((t <= endLine) && (t + 1 >= currentScrollRow && t + 1 <= currentMaxScrollRow)) {
						startCharRect = wordTxt.getCharBoundaries(d);
						if (t == endLine) {
							endCharRect = wordTxt.getCharBoundaries(endIndex); 
						}
						else {
							lineLength = wordTxt.getLineLength(t);
							sumLineLength += lineLength;
							endCharRect = wordTxt.getCharBoundaries((sumLineLength - 1)); 
						}
						
						if(startCharRect && endCharRect){
							startCharRect.width = (endCharRect.x - startCharRect.x) + endCharRect.width;
							wordRender(wordColor, wordAlpha, startCharRect);
						}
						
						t++;
						if(t <= endLine){
							d = wordTxt.getLineOffset(t);
						}
					}
				}
			}
		}
	}
}
}

