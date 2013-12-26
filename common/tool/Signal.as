package common.tool
{
import common.data.Map;
import common.data.VectorMap;

public class Signal
{
	private var container:VectorMap;
	private var config:Map;
	
	public function Signal(){
		container = new VectorMap(Function);
		config = new Map();
	}
	
	/**
	 * 添加一个监听方法
	 * @param fun
	 * @param executeOnce 是否执行一次就删除
	 */
	public function addObserver(fun:Function, executeOnce:Boolean = false):void{
		if(containObserve(fun)){
			return;
		}
		if(executeOnce){
			config.add(fun, executeOnce);
		}
		container.add(fun);
	}
	
	/**
	 * 清除指定方法
	 * @param fun
	 */
	public function removeObserver(fun:Function):void{
		if(containObserve(fun)){
			container.remove(fun);
			config.remove(fun);
		}
	}
	
	/**
	 * 判断指定的方法是否存在于该Signal中
	 * @param fun
	 * @return 
	 */
	public function containObserve(fun:Function):Boolean{
		return container.contain(fun);
	}
	
	/**
	 * 获取该signal的监听者数量
	 * @return 
	 */
	public function getLen():int{
		return container.getLen();
	}
	
	/**
	 * 是否不存在监听者方法
	 * @return 
	 */
	public function isEmpty():Boolean{
		return getLen() == 0;
	}
	
	/**
	 * 清除所有的监听者方法
	 */
	public function removeAll():void{
		container.removeAll();
		config.removeAll();
	}
	
	/**
	 * 派送指定参数至当前的Signal的监听方法中
	 * @param args
	 */
	public function dispatch(...args):void{
		if(container.isEmpty()){
			return;
		}
		container.forEach(function(item:Function):void{
			item.apply(null, args);
			if(config.contains(item)){
				removeObserver(item);
			}
		});
	}
}
}
