package common.display
{
import common.load.IDispose;

/**
 * 
 */ 
public interface IMotionSync extends IDispose
{
	//update method will run in every frame tick
	function update(time:Number = NaN):void;
	
	//check motion is should complete
	function isComplete():Boolean;
}
}