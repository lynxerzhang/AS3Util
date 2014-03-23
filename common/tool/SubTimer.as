package common.tool
{
import flash.utils.getTimer;

/**
 * 检测代码执行时间, 类似于flash原生的getTimer()方法检测
 * 但是SubTimer基于微秒
 * 
 * @example
 * 	//getTimer() version
 * 	var s:Number = getTimer();
 * 	//some code running
 * 	var e:Number = getTimer() - s;
 * 
 * 	//SubTimer version
 * 	var s:SubTimer = new SubTimer();
 * 	s.start();
 * 	//some code running
 * 	var e:Number = s.end();
 * 
 * @see http://jacksondunstan.com/articles/2348
 * @see http://guihaire.com/code/?p=791
 */
public class SubTimer
{
	public function SubTimer(calibrationMs:int = 10)
	{
		doCalibration(calibrationMs);
	}
	
	/**
	 * 执行校准
	 * @param    ms 毫秒数
	 * @return
	 */
	public function doCalibration(ms:int):Number {
		if (ms < 1) {
			ms = 1;
		}
		calibrationCount = 0;
		calibrationTimeMs = getTimer() + 1;
		while (getTimer() < calibrationTimeMs) {
		}
		calibrationTimeMs = getTimer() + ms;
		do {
			calibrationCount++;
		}while (getTimer() < calibrationTimeMs);
		perCountMs =  ms / calibrationCount;
		return perCountMs;
	}
	
	/**
	 * 开始检测
	 */
	public function start():void {
		startMs = getTimer() + 1;
		while (getTimer() < startMs) {
		}
	}
	
	/**
	 * 结束检测
	 * @return
	 */
	public function end():Number {
		calibrationCount = 0;
		calibrationTimeMs = getTimer() + 1;
		do {
			calibrationCount++;
		}
		while (getTimer() < calibrationTimeMs);
		return calibrationTimeMs - startMs - calibrationCount * perCountMs;
	}
	
	//每次计数耗费的毫秒数
	private var perCountMs:Number = 0;
	//开始检测毫秒数
	private var startMs:Number = 0;
	
	//校验毫秒数
	private var calibrationTimeMs:Number = 0;
	//毫秒差值计数
	private var calibrationCount:int = 0;
}
}