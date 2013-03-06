package common.display
{
import flash.display.Shape;
import flash.events.Event;
import flash.utils.getTimer;

import common.tool.VectorMap;

import common.tool.SingletonVerify;

/**
 * TODO
 */ 
internal class RiseFieldManager
{
	public function RiseFieldManager()
	{
		if(instance){
			SingletonVerify.singletonErrorHandle(this);
		}
	}
	
	//
	public static var instance:RiseFieldManager = new RiseFieldManager();
	
	//
	private var motionMap:VectorMap = new VectorMap(IMotionSync);
	
	//singleton's signal in every frame
	private var ticker:Shape = new Shape();
	
	//
	private var prevTime:Number = 0;
	
	//record current frame's milliseconds
	private var milliseconds:Number = 0;
	
	/**
	 * add a IMotionSync data
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
	 * execute in every frame (if has some stuff)
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
	 * remove a specfied IMotionSync data
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