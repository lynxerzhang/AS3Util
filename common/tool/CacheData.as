package common.tool 
{
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;

/**
 * 封装SharedObject调用
 */
public class CacheData 
{
	public function CacheData(name:String) 
	{
		dataCache = SharedObject.getLocal(name, "/");
		if (!dataCache.data.cache) {
			rawData = { };
			dataCache.data.cache = rawData;
			flush();
		}
		else {
			rawData = dataCache.data.cache;
		}
		//dataCache.addEventListener(NetStatusEvent.NET_STATUS, sharedObjectStateHandler);
	}
	
	private var dataCache:SharedObject;
	private var checkState:String;
	
	/*private function sharedObjectStateHandler(evt:NetStatusEvent):void{
		switch(evt.info.code) {
			case "SharedObject.Flush.Failed":
				//The "pending" status is resolved, but the SharedObject.flush() failed.
				break;
			case "SharedObject.Flush.Success":
				//The "pending" status is resolved and the SharedObject.flush() call succeeded.
				break;
		}
	}*/
	
	/**
	 * 置入指定键值
	 * @param	key
	 * @param	value
	 */
	public function put(key:String, value:*):void {
		if (rawData) {
			rawData[key] = value;
			flush();
		}
	}
	
	private var rawData:Object;
	
	/**
	 * 移除指定键
	 * @param	key
	 * @return
	 */
	public function remove(key:String):Boolean {
		if (contain(key)) {
			delete rawData[key];
			flush();
			return true;
		}
		return false;
	}
	
	/**
	 * 获取指定键值
	 * @param	key
	 * @return
	 */
	public function getValue(key:String):*{
		if (contain(key)) {
			return rawData[key];
		}
		return null;
	}
	
	/**
	 * 检查指定键是否存在
	 * @param	key
	 * @return
	 */
	public function contain(key:String):Boolean {
		if (rawData) {
			return rawData[key];
		}
		return false;
	}
	
	/**
	 * 销毁
	 */
	public function dispose():void {
		if (dataCache) {
			dataCache.clear();
			//dataCache.removeEventListener(NetStatusEvent.NET_STATUS, sharedObjectStateHandler);
		}
		dataCache = null;
		rawData = null;
	}
	
	private function flush():void {
		if (dataCache) {
			try {
				checkState = dataCache.flush(/*minDiskSpace*/);	
				if (checkState == SharedObjectFlushStatus.PENDING) {
					//check the stagesize is whether small than 215 * 138
				}
				else {
					if (checkState == SharedObjectFlushStatus.FLUSHED) {
						//save success
					}
					else {
						//maybe null
					}
				}
			}
			catch (e:Error) {
				//This error might occur if the user has permanently disallowed 
				//local information storage for objects from this domain. 
			}
		}
	}
}
}