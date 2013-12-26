package common.display
{
import common.data.VectorMap;
import flash.display.Shape;
import flash.events.Event;
import flash.utils.getTimer;

import common.tool.SingletonVerify;

public class RiseFieldManager
{
	public function RiseFieldManager()
	{
		SingletonVerify.checkSingleton(this);
	}
	
	public static var instance:RiseFieldManager = new RiseFieldManager();
	
	/**
	 * 保存IMotionSync的VectorMap
	 */
	private var motionMap:VectorMap = new VectorMap(IMotionSync);
	
	/**
	 * tick
	 */
	private var ticker:Shape = new Shape();
	
	/**
	 * 记录播放至上一帧时的毫秒数
	 */
	private var prevTime:Number = 0;
	
	/**
	 * 每两帧之间的毫秒数
	 */
	private var milliseconds:Number = 0;
	
	/**
	 * 添加一个IMotionSync对象
	 */ 
	public function add(data:IMotionSync):void{
		motionMap.add(data);
		if(motionMap.getLen() > 0){
			if(!ticker.hasEventListener(Event.ENTER_FRAME)){
				prevTime = getTimer();
				ticker.addEventListener(Event.ENTER_FRAME, runMotion);
			}
		}
	}
	
	/**
	 * 帧循环
	 */ 
	private function runMotion(evt:Event):void{
		var c:Number = getTimer();
		milliseconds = (c - prevTime) * .001;
		var len:int = this.motionMap.getVector().length;
		while(--len > -1){
			var d:IMotionSync = this.motionMap.getContent(len);
			if(d){
				d.update(milliseconds);
				if(d.isComplete()){
					d.dispose();
					remove(d);
				}
			}
		}
		prevTime = c;
	}
	
	/**
	 * 删除一个IMotionSync对象
	 */ 
	public function remove(data:IMotionSync):void{
		this.motionMap.remove(data);
		if(this.motionMap.getLen() == 0){
			if(ticker.hasEventListener(Event.ENTER_FRAME)){
				ticker.removeEventListener(Event.ENTER_FRAME, runMotion);
			}
		}
	}
}
}