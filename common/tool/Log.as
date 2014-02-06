package common.tool
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.UncaughtErrorEvent;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;

/**
 * 输出所需日志到文本面板
 * 
 * @example 
 * Log.setStage(this);
 * Log.trace("game start");
 * 
 * @see http://www.trottercashion.com/2012/08/12/how-to-write-good-log-messages.html
 */
public class Log
{
	private static const WIDTH:int = 400;
	private static const HEIGHT:int = 300;
	private static const MAX_LEN:int = 5000;
	
	public static function setStage(documentClassInstance:Sprite):void{
		if (stage) {
			return;
		}
		stage = documentClassInstance.stage;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		//the loaderInfo's uncaughtErrorEvents need fp version 10.1 or later
		documentClassInstance.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, unCaughtErrorHandler);
		//stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, unCaughtErrorHandler);
	}
	
	/**
	 * @see adobe's UncaughtErrorEvent document
	 * When content is running in a debugger version of the runtime, 
	 * such as the debugger version of Flash Player or the AIR Debug Launcher (ADL), 
	 * an uncaught error dialog appears when an uncaught error happens. 
	 * For those runtime versions, the error dialog appears even when a listener is registered for the uncaughtError event. 
	 * To prevent the dialog from appearing in that situation, call the UncaughtErrorEvent object's preventDefault() method.
	 */
	private static function unCaughtErrorHandler(evt:UncaughtErrorEvent):void {
		if (evt.error is Error) {
			if (!Capabilities.isDebugger()) {
				trace(Error(evt.error).getStackTrace());
			}
		}
		else {
			evt.preventDefault();
			trace(evt.error);
		}
	}
	
	private static function handleKeyDown(evt:KeyboardEvent):void {
		if(evt.keyCode == Keyboard.A && evt.ctrlKey && evt.shiftKey){
			toStage(isShow = !isShow);
		}
	}
	
	private static function createBg():void {
		panel = new Sprite();
		panel.graphics.beginFill(0x333333, .4);
		panel.graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, 8, 8);
		panel.graphics.endFill();
		panel.buttonMode = true;
		panel.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownPanelBg);
	}
	
	private static function mouseDownPanelBg(evt:MouseEvent):void {
		panel.startDrag(false);
		panel.stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
	}
	
	private static function releaseHandler(evt:MouseEvent):void {
		panel.stopDrag();
		panel.stage.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
	}
	
	private static const LEFTMARGIN:int = 20;
	private static const TOPMARGIN:int = 20;
	
	private static function creatField():void {
		outputTxt = new TextField();
		outputTxt.background = true;
		outputTxt.backgroundColor = 0xD4D4D4;
		outputTxt.wordWrap = true;
		outputTxt.multiline = true;
		//outputTxt.autoSize = TextFieldAutoSize.LEFT;
		
		outputTxt.width = WIDTH - LEFTMARGIN;
		outputTxt.height = HEIGHT - TOPMARGIN;
		outputTxt.type = TextFieldType.INPUT;
		outputTxt.mouseWheelEnabled = true;
		outputTxt.x = (WIDTH - outputTxt.width) * .5;
		outputTxt.y = (HEIGHT - outputTxt.height) * .5;
		outputTxt.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownOutputHandler);
	}
	
	private static function mouseDownOutputHandler(evt:MouseEvent):void {
		evt.stopImmediatePropagation();
	}
	
	private static function createDragBar():void {
		var w:int = (WIDTH - outputTxt.width) * .5;
		
		var dragBg:Sprite = new Sprite();
		dragBg.graphics.beginFill(0x999999, .8);
		dragBg.graphics.drawRect(0, 0, w, HEIGHT - 20);
		dragBg.graphics.endFill();
		dragBg.name = "scrollBar";
		
		var thumb:Sprite = new Sprite();
		thumb.graphics.beginFill(0x666666, .6);
		thumb.graphics.drawRoundRect(0, 0, w, w, 4, 4);
		thumb.graphics.endFill();
		thumb.name = "scrollThumb";
		
		dragResource = new Sprite();
		dragResource.addChild(dragBg);
		dragResource.addChild(thumb);
	}
	
	private static var scroll:TextScroll;
	private static var dragResource:Sprite;
	private static var stage:Stage;
	private static var close:Sprite;
	private static var panel:Sprite;
	private static var outputTxt:TextField;
	
	private static function createCloseBtn():void {
		close = new Sprite();
		close.graphics.beginFill(0, 0);
		close.graphics.lineStyle(2);
		close.graphics.moveTo(0, 0);
		close.graphics.lineTo(6, 6);
		close.graphics.moveTo(6, 0);
		close.graphics.lineTo(0, 6);
		close.graphics.endFill();
		close.buttonMode = true;
		
		close.x = WIDTH - close.width;
		close.y = 2;
		close.addEventListener(MouseEvent.CLICK, createBtnCloseHandler);
	}
	
	private static function createBtnCloseHandler(evt:MouseEvent):void {
		if(panel.parent){
			panel.parent.removeChild(panel);
			isShow = false;
		}
	}
	
	init();
	private static function init():void{
		createBg();
		creatField();
		createDragBar();
		createCloseBtn();
		panel.addChild(outputTxt);
		panel.addChild(dragResource);
		panel.addChild(close);
	}

	private static var isShow:Boolean = false;
	
	private static function toStage(bol:Boolean):void{
		if (!panel.parent && bol) {
			if (!scroll) {
				scroll = new TextScroll(outputTxt, dragResource);
			}
			stage.addChild(panel);
			var centerPoint:Point = new Point((stage.stageWidth - panel.width) * .5, (stage.stageHeight - panel.height) * .5);;
			centerPoint = panel.parent.globalToLocal(centerPoint);
			panel.x = centerPoint.x;
			panel.y = centerPoint.y;
		}
		else if(panel.parent && !bol){
			stage.removeChild(panel);
		}
	}
	
	/**
	 * 输出所需信息至文本面板
	 * @param	...args
	 */
	public static function trace(...args):void{
		if(outputTxt){
			var s:String = outputTxt.text + args.join(" ");
			s = s.substr(-MAX_LEN);
			//outputTxt.appendText(s + "\n");
			outputTxt.text = s + "\n";
			outputTxt.scrollV = outputTxt.maxScrollV;
		}
	}
}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

/**
 * @see https://gist.github.com/lynxerzhang/3841225
 */
class TextScroll 
{
	private var txt:TextField;
	private var thumb:Sprite;
	private var dragBar:Sprite;
	private var group:Sprite;
	
	/**
	 * @param	t 
	 * @param	g contain a dragThumb and a dragBarBackGround
	 */
	public function TextScroll(t:TextField, g:Sprite):void {
		this.txt = t;
		this.group = g;
		this.thumb = this.group.getChildByName("scrollThumb") as Sprite; //the dragThumb
		this.dragBar = this.group.getChildByName("scrollBar") as Sprite; //the scrollBar 
		this.txt.background = true;
		//this.txt.backgroundColor = 0xFFFFFF;
		addTxtChange(this.txt);
		attachThumbBar(this.txt, this.group);
		thumbSizeUpdate(this.txt);
		this.thumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);	
	}
	
	private var downMouseY:Number = 0;
	
	private function mouseDownHandler(evt:MouseEvent):void{
		var yRatio:Number = thumb.transform.matrix.d;
		downMouseY = thumb.mouseY * yRatio;
		thumb.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		evt.stopImmediatePropagation();
	}
	
	private  function mouseUpHandler(evt:MouseEvent):void{
		thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		evt.stopImmediatePropagation();
	}

	private  function mouseMoveHandler(evt:MouseEvent):void{
		var yRatio:Number = this.dragBar.transform.matrix.d;
		var r:Number = this.dragBar.mouseY * yRatio - downMouseY;
		thumb.y = Math.max(0, Math.min(r, this.dragBar.height - thumb.height));
		var dr:Number = thumb.y / (this.dragBar.height - thumb.height);
		txt.scrollV = Math.round(dr * (txt.maxScrollV - 1) + 1);
		evt.stopImmediatePropagation();
	}
	
	private function attachThumbBar(t:TextField, thumbBarGroup:Sprite):void{
		thumbBarGroup.x = t.x + t.width;
		thumbBarGroup.y = t.y;
		this.dragBar.height = t.height;
	}
	
	private function thumbSizeUpdate(t:TextField):void{
		var max:int = t.numLines;
		var maxSv:int = t.maxScrollV;
		var ratio:Number = (max - maxSv + 1) / max;
		thumb.height = this.dragBar.height * ratio;
		if(txt.scrollV > txt.maxScrollV){
			txt.scrollV = txt.maxScrollV;
		}
		if (txt.scrollV < 1) {
			txt.scrollV = 1;
		}
		thumb.y = ((txt.scrollV - 1) / (txt.maxScrollV - 1)) * (this.dragBar.height - thumb.height);
	}

	private function addTxtChange(t:TextField):void{
		t.addEventListener(Event.CHANGE, textFieldChange);
		t.addEventListener(Event.SCROLL, textFieldScroll);
	}
	
	private function textFieldChange(evt:Event):void {
		var t:TextField = evt.currentTarget as TextField;
		thumbSizeUpdate(t);
	}
	
	private function textFieldScroll(evt:Event):void {
		var t:TextField = evt.currentTarget as TextField;
		thumbSizeUpdate(t);
	}
}

