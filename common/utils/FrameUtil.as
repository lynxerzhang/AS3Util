package common.utils 
{
import flash.display.FrameLabel;
import flash.display.MovieClip;

public class FrameUtil 
{
	public function FrameUtil() 
	{
	}
	
	/**
	 * 添加指定帧的方法回调
	 * @param	mc
	 * @param	labelOrFrame
	 * @param	handler
	 * @return
	 */
	public static function addFrameScript(mc:MovieClip, labelOrFrame:*, handler:Function):Boolean {
		var frameIndex:int = -1;
		if (typeof labelOrFrame == "number") {
			frameIndex = int(labelOrFrame);
		}
		else {
			if (labelOrFrame is String) {
				frameIndex = getFrameByFrameName(mc, String(labelOrFrame));
			}
		}
		if (frameIndex != -1) {
			mc.addFrameScript(frameIndex - 1, handler);
		}
		return frameIndex != -1;
	}
	
	/**
	 * 添加指定帧的方法回调,同时可以为回调方法添加所需参数
	 * @param	mc
	 * @param	labelOrFrame
	 * @param	handler
	 * @param	...args
	 * @return
	 */
	public static function addFrameScriptArgsHandler(mc:MovieClip, labelOrFrame:*, handler:Function, ...args):Boolean {
		var frameIndex:int = -1;
		if (typeof labelOrFrame == "number") {
			frameIndex = int(labelOrFrame);
		}
		else {
			if (labelOrFrame is String) {
				frameIndex = getFrameByFrameName(mc, String(labelOrFrame));
			}
		}
		var d:Array;
		if (args.length == 1) {
			if (args[0] is Array) {
				d = args[0] as Array;
			}
			else {
				d = args;
			}
		}
		else {
			d = args;
		}
		var f:Function = function():void {
			handler.apply(null, d);
		}
		if (frameIndex != -1) {
			mc.addFrameScript(frameIndex - 1, f);
		}
		return frameIndex != -1;
	}
	
	/**
	 * 移除指定帧的方法回调
	 * @param	mc
	 * @param	labelOrFrame
	 */
	public static function removeFrameScript(mc:MovieClip, labelOrFrame:*):void {
		var frameIndex:int = -1;
		if (typeof labelOrFrame == "number") {
			frameIndex = int(labelOrFrame);
		}
		else {
			if (labelOrFrame is String) {
				frameIndex = getFrameByFrameName(mc, String(labelOrFrame));
			}
		}
		if (frameIndex != -1) {
			mc.addFrameScript(frameIndex - 1, null);
		}
	}
	
	/**
	 * 判断指定帧是否已经有代码段
	 * @param	mc
	 * @param	labelOrFrame
	 * @return
	 */
	public static function hasOriginalHandler(mc:MovieClip, labelOrFrame:*):Boolean {
		var frameIndex:int = -1;
		if (typeof labelOrFrame == "number") {
			frameIndex = int(labelOrFrame);
		}
		else {
			if (labelOrFrame is String) {
				frameIndex = getFrameByFrameName(mc, String(labelOrFrame));
			}
		}
		var fun:Function = mc["frame" + frameIndex];
		return fun != null;
	}
	
	/**
	 * 获取指定帧上原有的代码段
	 * @param	mc
	 * @param	labelOrFrame
	 * @return
	 */
	public static function getOriginalHandler(mc:MovieClip, labelOrFrame:*):Function {
		var frameIndex:int = -1;
		if (typeof labelOrFrame == "number") {
			frameIndex = int(labelOrFrame);
		}
		else {
			if (labelOrFrame is String) {
				frameIndex = getFrameByFrameName(mc, String(labelOrFrame));
			}
		}
		var fun:Function = mc["frame" + frameIndex];
		return fun;
	}
	
	private static function getFrameByFrameName(mc:MovieClip, frameLabel:String):int {
		var labels:Array = mc.currentLabels;
		var len:int = labels.length;
		var label:FrameLabel;
		var index:int = -1;
		for (var i:int = 0; i < len; i ++) {
			label = labels[i];
			if (label.name == frameLabel) {
				index = label.frame;
				break;
			}
		}
		return index;
	}
}
}