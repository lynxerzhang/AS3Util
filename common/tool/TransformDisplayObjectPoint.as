package common.tool 
{
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.flash_proxy;
import flash.utils.Proxy;

/**
 * 
 * 利用Proxy模拟"注册点"位置改变后的表现
 * 
 * @see
 *   http://zehfernando.com/2009/changing-a-movieclips-registration-point-painlessly/
 * 
 * @example
 *   var p:TransformDisplayObjectPoint = new TransformDisplayObjectPoint(_mc);
 *   p.registerPointX = -25;
 *   p.registerPointY = -75;
 *   p.scaleX = 2;
 *   p.scaleY = 2;
 *   p.x = 100;
 *   p.y = 100;
 */
dynamic public final class TransformDisplayObjectPoint extends Proxy
{
	private var display:DisplayObject;
	
	public function TransformDisplayObjectPoint(dis:DisplayObject) 
	{
		display = dis;
		prevX = display.x;
		prevY = display.y;
		
		if (display.stage) {
			attachStageHandler();
		}
		
		display.addEventListener(Event.ADDED_TO_STAGE, attachStageHandler);
		display.addEventListener(Event.REMOVED_FROM_STAGE, detachStageHandler);
	}
	
	private var prevX:Number = 0;
	private var prevY:Number = 0;
	
	private var registerX:Number = 0;
	private var registerY:Number = 0;
	
	private var prevRegisterX:Number = 0;
	private var prevRegisterY:Number = 0;
	
	private var updateSign:Boolean = false;
	private var onStage:Boolean = false;
	private var stageInstance:Stage;
	
	private function attachStageHandler(evt:Event = null):void {
		onStage = true;
		stageInstance = display.stage;
		updateSign = false;
		update();
	}
	
	private function detachStageHandler(evt:Event):void{
		onStage = false;
		stageInstance = null;
		updateSign = false;
	}
	
	private function update():void {
		if (onStage) {
			if (!updateSign) {
				updateSign = true;
				stageInstance.addEventListener(Event.RENDER, renderDisplay);
				stageInstance.invalidate();
			}
		}
	}
	
	//helper
	private static const HELPER_ZERO_POINT:Point = new Point(0, 0);
	private static const HELPER_TRANSFORM_POINT:Point = new Point(0, 0);
	
	private function renderDisplay(evt:Event):void {
		updateSign = false;
		stageInstance.removeEventListener(Event.RENDER, renderDisplay);
		HELPER_TRANSFORM_POINT.setTo(registerX, registerY);
		var t:Point = display.localToGlobal(HELPER_ZERO_POINT);
		var d:Point = display.localToGlobal(HELPER_TRANSFORM_POINT);
		display.x = prevX - (d.x - t.x);
		display.y = prevY - (d.y - t.y);
	}
	
	//特殊处理属性集合
	private static const OBSERVE_PROPERTY:Vector.<String> = new <String>["x", "y", "rotation", "scaleX", "scaleY"];
	
	flash_proxy override function setProperty(name:*, value:*):void{
		var n:String = name is QName ? QName(name).localName : name.toString();
		if (Object(display).hasOwnProperty(n)) {
			if (OBSERVE_PROPERTY.indexOf(n) > -1) {
				if (n == "x" || n == "y") {
					if (n == "x"){
						prevX = value;
					}
					if (n == "y") {
						prevY = value;
					}
				}
				else {
					display[n] = value;
				}
				update();
			}
			else {
				display[n] = value;
			}
		}
	}
	
	flash_proxy override function getProperty(name:*):*{
		var n:String = name is QName ? QName(name).localName : name.toString();
		/*if (OBSERVE_PROPERTY.indexOf(n) > -1) {
			return this[n];
		}*/
		if (n == "x") {
			return prevX;
		}
		if (n == "y") {
			return prevY;
		}
		if (Object(display).hasOwnProperty(n)) {
			return display[n];
		}
		return null;
	}
	
	flash_proxy override function callProperty(name:*, ...rest):*{
		var n:String = name is QName ? QName(name).localName : name.toString();
		if (rest.length == 0) {
			return display[n]();
		}
		else if (rest.length == 1) {
			return display[n](rest[0]);
		}
		else if (rest.length == 2) {
			return display[n](rest[0], rest[1]);
		}
		else if (rest.length == 3) {
			return display[n](rest[0], rest[1], rest[2]);
		}
		return display[n].apply(display, rest);
	}
	
	/**
	 * 执行销毁
	 */
	public function dispose():void {
		if (display) {
			display.removeEventListener(Event.ADDED_TO_STAGE, attachStageHandler);
			display.removeEventListener(Event.REMOVED_FROM_STAGE, detachStageHandler);
			display = null;
		}
		if (stageInstance) {
			stageInstance.removeEventListener(Event.RENDER, renderDisplay);
			stageInstance = null;
		}
	}
	
	/**
	 * 获取x轴注册点
	 */
	public function get registerPointX():Number{
		return registerX;
	}
	
	/**
	 * 设置x轴注册点
	 */
	public function set registerPointX(value:Number):void {
		registerX = value;
		if (prevRegisterX != registerX) {
			prevRegisterX = registerX;
			update();
		}
	}
	
	/**
	 * 获取y轴注册点
	 */
	public function get registerPointY():Number{
		return registerY;
	}
	
	/**
	 * 设置y轴注册点
	 */
	public function set registerPointY(value:Number):void{
		registerY = value;
		if (prevRegisterY != registerY) {
			prevRegisterY = registerY;
			update();
		}
	}
}

}