package common.tool
{

public class Signal
{
	private var container:VectorMap;
	private var config:Map;
	
	public function Signal(){
		container = new VectorMap(Function);
		config = new Map();
	}
	
	/**
	 * add specific observe function
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
	 * remove specific observe function
	 */ 
	public function removeObserver(fun:Function):void{
		if(containObserve(fun)){
			container.remove(fun);
			config.remove(fun);
		}
	}
	
	/**
	 * check whether contain a observe function
	 */ 
	public function containObserve(fun:Function):Boolean{
		return container.contain(fun);
	}
	
	/**
	 * get len in this signal
	 */ 
	public function getLen():int{
		return container.getLen();
	}
	
	/**
	 * check this signal container is empty
	 */ 
	public function isEmpty():Boolean{
		return getLen() == 0;
	}
	
	/**
	 * remove all observer
	 */ 
	public function removeAll():void{
		container.removeAll();
		config.removeAll();
	}
	
	/**
	 * dispatch data to all observer
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
