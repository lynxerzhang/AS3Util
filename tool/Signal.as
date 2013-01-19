package tool
{

public class Signal
{
	private var container:VectorMap;
	
	public function Signal(){
		container = new VectorMap(Function);
	}
	
	/**
	 * add specific observe function
	 */ 
	public function addObserver(fun:Function):void{
		if(containObserve(fun)){
			return;
		}
		container.add(fun);
	}
	
	/**
	 * remove specific observe function
	 */ 
	public function removeObserver(fun:Function):void{
		if(containObserve(fun)){
			container.remove(fun);
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
		});
	}
}
}
