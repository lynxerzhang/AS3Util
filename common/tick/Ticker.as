package common.tick
{
import common.tool.Map;
import common.tool.SingletonVerify;

public class Ticker
{
	public function Ticker(){
		if(instance) SingletonVerify.singletonErrorHandle(this);
	}
	
	public static var instance:Ticker = new Ticker();
	private var tickerMap:Map = new Map();
	
	/**
	 * 创建倒计时
	 * @param	key       标识
	 * @param	seconds   期望倒计时秒数
	 * @param	tickState 期望接受通知的倒计时秒数数组
	 * @return
	 */
	public function addTicker(key:String, seconds:Number, tickState:Vector.<int> = null):CountDown{
		if(!tickerMap.contains(key)){
			var t:CountDown = new CountDown(seconds, tickState);
			tickerMap.add(key, t);
		}
		return tickerMap.get(key);
	}
	
	/**
	 * 获取指定标识的倒计时对象
	 * @param	key
	 * @return
	 */
	public function getTicker(key:String):CountDown{
		if(tickerMap.contains(key)){
			return tickerMap.get(key);
		}
		return null;
	}
	
	/**
	 * 检查是否存在指定标识的倒计时对象
	 * @param	key
	 * @return
	 */
	public function hasTicker(key:String):Boolean{
		return tickerMap.contains(key);
	}
	
	/**
	 * 暂停指定标识的倒计时对象
	 * @param	key
	 * @return
	 */
	public function slienceTicker(key:String):Boolean{
		if(tickerMap.contains(key)){
			var t:CountDown = tickerMap.get(key);
			if(t){
				t.pauseTimer();
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 暂停并销毁指定标识的倒计时对象
	 * @param	key
	 * @return
	 */
	public function removeAndDisposeTicker(key:String):Boolean{
		if(tickerMap.contains(key)){
			var t:CountDown = tickerMap.get(key);
			if(t){
				t.dispose();
			}
			return tickerMap.remove(key);
		}
		return false;
	}
	
	/**
	 * 删除指定倒计时对象, 以值为索引进行删除操作, 将对应改值的各种键清除
	 * @param cd
	 */ 
	public function removeAndDisposeTicker2(cd:CountDown):Boolean{
		if(cd){
			if(cd){
				cd.dispose();
			}
			tickerMap.removeValue(cd);
			return true;
		}
		return false;
	}
}
}