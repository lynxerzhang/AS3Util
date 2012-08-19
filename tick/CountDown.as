package tick
{
import flash.events.TimerEvent;
import flash.utils.Timer;
import tool.Signal;

/**
 * 
 * the countDown implement with a native as3 timer
 */ 
public class CountDown
{
	/**
	 * the core ticker realized
	 */ 
	private var timer:Timer;
	
	private var _seconds:Number;
	
	/**
	 * complete Signal (maintain related observe)
	 */ 
	public var completeSignal:Signal;
	
	/**
	 * tick Signal (maintain related observe)
	 */ 
	public var tickSignal:Signal;
	
	
	/**
	 * state Signal (maintain related observe)
	 */ 
	public var stateSignal:Signal;
	
	/**
	 * state's ary (contains some report points in ticker run)
	 */ 
	private var stateVector:Vector.<int>;
	
	/**
	 * record the total seconds to countdown 
	 */ 
	private var totalSeconds:Number;
	
	/**
	 * this countdown time value (base in seconds)
	 */
	public function get seconds():Number
	{
		return _seconds;
	}

	/**
	 * construct method
	 * 
	 * @param s this is countdown base number, it's type is (seconds)
	 */ 
	public function CountDown(s:Number, state:Vector.<int> = null):void{
		if(!isNaN(s)){
			timer = new Timer(1000, 0);
			this.totalSeconds = this._seconds = s;
			this.stateVector = state;
			completeSignal = new Signal();
			tickSignal = new Signal();
			stateSignal = new Signal();
			addTimerEvent(timer);
		}	
	}
	
	/**
	 * start the tick
	 */ 
	public function start():void{
		this.timer.start();
		tickSignal.dispatch();
		checkDispatchStateReach();
	}
	
	private function checkDispatchStateReach():void{
		if(stateSignal){
			var t:Number = this.totalSeconds - this.seconds;
			if(this.stateVector && this.stateVector.indexOf(t) != -1){
				//here we told stateSignal the current seconds, 
				//helping the client to judge
				this.stateSignal.dispatch(t);
			}
		}
	}
	
	/**
	 * check this timer is whether start
	 */ 
	public function isStart():Boolean{
		return this.timer.running;
	}
	
	/**
	 * refresh timer
	 */ 
	public function refreshTimer(s:Number, state:Vector.<int> = null):void{
		this.timer.stop();
		this.timer.reset();
		this.totalSeconds = s;
		this._seconds = s;
		if(this.stateVector){
			this.stateVector.length = 0;
		}
		this.stateVector = state;
		start();
	}
	
	/**
	 * pause timer
	 */ 
	public function pauseTimer():void{
		this.timer.stop();
		this.timer.reset();
	}
	
	/**
	 * add this timer event
	 */ 
	private function addTimerEvent(t:Timer):void{
		if(t){
			t.addEventListener(TimerEvent.TIMER, timerTickHandler);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, timerTickCompleteHandler);
		}
	}
	
	/**
	 * every second tick and notify observe
	 */ 
	private function timerTickHandler(evt:TimerEvent):void{
		this._seconds --;
		this.tickSignal.dispatch();
		checkDispatchStateReach();
		if(this.seconds == 0){
			completeSignal.dispatch();
		}
	}
	
	/**
	 * ticker is complete his task and notify observe to judge what next operation is 
	 */ 
	private function timerTickCompleteHandler(evt:TimerEvent):void{
		
	}
	
	/**
	 * remove related timer 
	 */
	private function removeTimerEvent(t:Timer):void{
		if(t){
			t.removeEventListener(TimerEvent.TIMER, timerTickHandler);
			t.removeEventListener(TimerEvent.TIMER_COMPLETE, timerTickCompleteHandler);
		}
	}
	
	/**
	 * dispose all active object wait for gc
	 */ 
	public function dispose():void{
		if(this.timer){
			this.timer.stop();
			removeTimerEvent(this.timer);
			this.timer = null;
		}
		if(tickSignal){
			tickSignal.removeAll();
			tickSignal = null;
		}
		if(completeSignal){
			completeSignal.removeAll();
			completeSignal = null;
		}
		if(stateSignal){
			stateSignal.removeAll();
			stateSignal = null;
		}
		if(this.stateVector){
			this.stateVector.length = 0;
			this.stateVector = null;
		}
		this._seconds = NaN;
		this.totalSeconds = NaN;
	}
}
}


