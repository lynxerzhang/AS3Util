package common.tick
{
import flash.events.TimerEvent;
import flash.utils.Timer;
import common.tool.Signal;

public class CountDown
{
	/**
	 * 使用Timer对象进行倒计时计算
	 */
	private var timer:Timer;
	
	/**
	 * 倒计时秒数
	 */
	private var _seconds:Number;
	
	/**
	 * 倒计时完成后的signal通知
	 */
	public var completeSignal:Signal;
	
	/**
	 * 倒计时每秒的间隔的signal通知
	 */
	public var tickSignal:Signal;
	
	/**
	 * 倒计时指定通知秒数的signal通知
	 */
	public var stateSignal:Signal;
	
	/**
	 * 倒计时指定通知秒数
	 */
	private var stateVector:Vector.<int>;
	
	/**
	 * 记录倒计时的总秒数
	 */ 
	private var totalSeconds:Number;
	
	/**
	 * 获取当前的倒计时秒数
	 */
	public function get seconds():Number
	{
		return _seconds;
	}

	/**
	 * 
	 * @param	s      秒数
	 * @param	state  记录被通知的秒数数组
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
	 * 开始倒计时
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
	 * 检查倒计时是否开启
	 */ 
	public function isStart():Boolean{
		return this.timer.running;
	}
	
	/**
	 * 刷新倒计时秒数和监听指定秒数数组
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
	 * 暂停倒计时
	 */ 
	public function pauseTimer():void{
		this.timer.stop();
		this.timer.reset();
	}
	
	
	private function addTimerEvent(t:Timer):void{
		if(t){
			t.addEventListener(TimerEvent.TIMER, timerTickHandler);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, timerTickCompleteHandler);
		}
	}
	

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
	 * 清除
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


