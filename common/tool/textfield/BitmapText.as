package common.tool.textfield
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;


/**
 * @see http://ticore.blogspot.com 
 * 原作者最初的版本将bitmapData的尺寸放大几倍，再将bitmap的scale压小, 
 * 同时在执行draw时会多执行几次，每次的draw偏移量会有些不同，
 * 同时会添加BlurFilter来进行模糊,来消除锯齿.
 * @example
 * 
 *  var t:TextFormat = new TextFormat();
 *  t.size = 30;
 *  t.bold = true;
 *  
 *  var b:BitmapText = new BitmapText();
 *  addChild(b); //需要先添加至舞台
 * 
 *  b.setTextProperty("defaultTextFormat", t); //设置TextFormat
 *  b.setTextProperty("setTextFormat", t);
 *  b.setTextProperty("text", "just a test for Bitmaptext" + "\n" + "version 1.00"); //设置显示文本
 *  b.rotation = 45;  //整体旋转45度
 */ 
public class BitmapText extends Sprite 
{
	public function BitmapText():void {
		init();
	}
	
	private function init():void {
		text = new TextField();
		text.autoSize = TextFieldAutoSize.LEFT;
		text.mouseEnabled = false;
		//text.wordWrap = true;
		text.visible = false;
		
		textBitmap = new Bitmap();
		textBitmap.smoothing = true;
		this.addChild(textBitmap);
		
		this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
	}
	
	private var textBitmap:Bitmap;
	private var textBitmapData:BitmapData;
	
	/**
	 * 设置文本的属性或者调用方法
	 * @param	name    属性或方法名
	 * @param	...args 参数
	 */
	public function setTextProperty(name:String, ...args):void {
		if (Object(text).hasOwnProperty(name)) {
			if (text[name] is Function) {
				text[name].apply(null, args);
			}
			else {
				text[name] = args[0];
			}
			invalidate();
		}
	}
	
	/**
	 * 返回原始文本的属性或方法
	 * @param	name
	 * @return  
	 * 
	 * @example 
	 *  var format:TextFormat = new TextFormat();
	 *	format.color = 0xFF6600;
	 *	b.getTextProperty("setTextFormat")(format);
	 * 
	 *  trace(b.getTextProperty("text")); 
	 */
	public function getTextProperty(name:String):*{
		if (Object(text).hasOwnProperty(name)) {
			var ns:* = text[name];
			if (ns is Function) {
				return function(...args):void {
					ns.apply(null, args);
					invalidate();
				}
			}
			return ns;
		}
		return null;
	}
	
	private function removeFromStageHandler(e:Event):void {
		onStage = false;
		rendering = false;
		this.removeEventListener(Event.RENDER, renderTextFieldDrawHandler);
	}
	
	/**
	 * 销毁
	 */
	public function dispose():void {
		this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		this.removeEventListener(Event.RENDER, renderTextFieldDrawHandler);
		if (textBitmap) {
			if (textBitmap.parent) {
				textBitmap.parent.removeChild(textBitmap);
			}
			if (textBitmap.bitmapData) {
				textBitmap.bitmapData.dispose();
				textBitmap.bitmapData = null;
			}
			textBitmap = null;
		}
	}
	
	/**
	 * 重绘
	 */
	public function validate():void{
		drawTextField();
	}
	
	private var text:TextField;
	private var rendering:Boolean = false;
	private var onStage:Boolean = false;
	
	private function addToStageHandler(evt:Event):void {
		onStage = true;
		this.addEventListener(Event.RENDER, renderTextFieldDrawHandler);
	}
	
	private function renderTextFieldDrawHandler(evt:Event):void {
		drawTextField();
	}
	
	private function drawTextField():void {
		rendering = false;
		if (textBitmapData) {
			textBitmapData.dispose();
			textBitmapData = null;
		}
		textBitmapData = new BitmapData(text.width + 4, text.height + 4, true, 0);
		textBitmapData.draw(text, null, null, null, null, true);
		textBitmapData.applyFilter(textBitmapData, textBitmapData.rect, new Point(0, 0), new BlurFilter(1, 1, 2));
		textBitmap.bitmapData = textBitmapData;
		textBitmap.smoothing = true;
	}
	
	private function invalidate():void {
		if (rendering) {
			return;
		}
		if (onStage) {
			rendering = true;
			stage.invalidate();
		}
	}
}
}
