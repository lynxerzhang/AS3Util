package common.display
{
import common.tool.IDispose;

public interface IMotionSync extends IDispose
{
	/**
	 * 每帧的更新通知
	 * @param	time
	 */
	function update(time:Number = NaN):void;
	
	/**
	 * 检查动画播放是否完毕
	 * @return
	 */
	function isComplete():Boolean;
}
}