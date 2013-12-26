package common.data
{
import common.data.Map;
import common.tool.Signal;

public class SignalMap extends Map
{
	public function SignalMap()
	{
		super();
	}
		
	/**
	 * 对添加入map对象中的键值提供通知
	 */
	public var added:Signal = new Signal();
	
	/**
	 * 对删除map对象中的键值提供通知
	 */
	public var removed:Signal = new Signal();
	
	/**
	 * 对清除map对象中的所有键值提供通知
	 */
	public var removeAlled:Signal = new Signal();
	
	/**
	 * 移除指定键
	 * @param key
	 * @return 
	 */
	override public function remove(key:*):*{
		var data:Object = super.remove(key);
		if(data){
			removed.dispatch(this, removed, data);
		}
		return data;
	}
	
	/**
	 * 添加指定键值
	 * @param key
	 * @param value
	 * @return 
	 */
	override public function add(key:*, value:*):Boolean{
		var isSuccess:Boolean = super.add(key, value);
		if(isSuccess){
			added.dispatch(this, added, key);
		}
		return isSuccess;
	}
	
	/**
	 * 销毁该map对象
	 */
	override public function dispose():void{
		super.dispose();
		this.added.removeAll();
		this.added = null;
		this.removed.removeAll();
		this.removed = null;
	}
	
	/**
	 * 清除所有键值对
	 */
	override public function removeAll():void{
		super.removeAll();
		removeAlled.dispatch(this, removeAlled, "removeAll"); 
	}
	
}
}