package tool
{
import flash.sampler.getSize;
/**
 * TODO
 * 
 * this is a simple observe pattern
 * 
 * but I think richardLord's Signal is wonderful (as3 flint system's author, it's inspired from robertpenner's Signal) 
 * 
 */ 
public class Signal
{
	private var container:VectorMap;
	
	public function Signal(){
		container = new VectorMap(Function);
	}
	
	/**
	 * add specific observe function
	 */ 
	public function addObserver(fun:Function):Boolean{
		if(containObserve(fun)){
			return false;
		}
		container.add(fun);
		return true;
	}
	
	/**
	 * remove specific observe function
	 */ 
	public function removeObserver(fun:Function):Boolean{
		if(containObserve(fun)){
			container.remove(fun);
			return true;
		}
		return false;
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
		if(container){
			return container.getLen();
		}
		return -1;
	}
	
	/**
	 * remove all observer
	 */ 
	public function removeAll():void{
		if(container){
			container.removeAll();
		}
	}
	
	/**
	 * dispatch data to all observer
	 */ 
	public function dispatch(...args):void{
		if(container.isEmpty()){
			return;
		}
		var c:Vector.<Function> = container.getVector() as Vector.<Function>;
		if(c && c.length > 0){
			c = c.concat();
			c.forEach(function(item:Function, ...d):void{
				item.apply(null, args);
			});
		}
	}
}
}