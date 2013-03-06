package common.tick
{
import common.tool.Map;
import common.tool.SingletonVerify;

/**
 * ticker manager
 */ 
public class Ticker
{
	public function Ticker(){
		new SingletonVerify(this, Ticker);
	}
	
	public static var instance:Ticker = new Ticker();
	private var tickerMap:Map = new Map();
	
	/**
	 * add ticker
	 * 
	 * @param key the unique key associate with ticker
	 * @param seconds the seconds to countdown
	 * @param tickState this vector contains some 'Guard_value' and the ticker will be detect whether reach
	 */ 
	public function addTicker(key:String, seconds:Number, tickState:Vector.<int> = null):CountDown{
		if(!tickerMap.contains(key)){
			var t:CountDown = new CountDown(seconds, tickState);
			tickerMap.add(key, t);
		}
		return tickerMap.get(key);
	}
	
	/**
	 * get ticker from map with specified 'key'
	 */ 
	public function getTicker(key:String):CountDown{
		if(tickerMap.contains(key)){
			return tickerMap.get(key);
		}
		return null;
	}
	
	
	/**
	 * check whether has the ticker
	 * @param key the unique key associate with ticker
	 */ 
	public function hasTicker(key:String):Boolean{
		return tickerMap.contains(key);
	}
	
	/**
	 * slience the specified key reference countdown
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
	 * remove ticker you want
	 * @param key the unique key associate with ticker
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
	 * 删除指定值, 以值为索引进行删除操作, 将对应改值的各种键清除
	 * @param cd  倒计时 ticker
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