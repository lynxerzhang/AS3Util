package common.utils
{

public class DateUtil 
{	
	public static const HOUR_MILLISEC:uint = 60 * 60 * 1000;
	public static const MINUTE_MILLISEC:uint = 60 * 1000;
	public static const SECOND_MILLISEC:uint = 1000;
	public static const MILLISEC_PART:uint = 10;

	/**
	 * 将给定的毫秒数输出成形如00:00:00:00的时间修饰字符串
	 * @param	millisecond
	 * @return
	 */
	public static function formatTime(millisecond:Number):String {
		if (millisecond < 0) {
			millisecond = 0;
		}
		var hours:Number = int(millisecond / HOUR_MILLISEC);
		var minutes:Number = int(millisecond % HOUR_MILLISEC / MINUTE_MILLISEC);
		var sec:Number = int(millisecond % HOUR_MILLISEC % MINUTE_MILLISEC / SECOND_MILLISEC);
		var mis:Number = int(millisecond % HOUR_MILLISEC % MINUTE_MILLISEC % SECOND_MILLISEC / MILLISEC_PART);
		
		return padingZero(String(hours)) + ":" + 
				padingZero(String(minutes)) + ":" + 
				padingZero(String(sec)) + ":" + padingZero(String(mis));
	}
	
	private static function padingZero(str:String):String {
		return str.replace(/^\d{1}$/, "0$&");
	}
}
}