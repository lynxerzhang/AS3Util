package common.tool
{
/**
 * 
 */ 
public class SignalMap extends Map
{
	public function SignalMap()
	{
		super();
	}
		
	/**
	 * the added operation's signal
	 */ 
	public var added:Signal = new Signal();
	
	/**
	 * the removed operation's signal
	 */ 
	public var removed:Signal = new Signal();
	
	/**
	 * the removeAll operation's signal
	 */ 
	public var removeAlled:Signal = new Signal();
	
	/**
	 * remove
	 * @param key
	 */ 
	override public function remove(key:*):*{
		var data:Object = super.remove(key);
		if(data){
			removed.dispatch(this, removed, data);
		}
		return data;
	}
	
	/**
	 * add 
	 * @param key
	 * @param value
	 */ 	
	override public function add(key:*, value:*):Boolean{
		var isSuccess:Boolean = super.add(key, value);
		if(isSuccess){
			added.dispatch(this, added, key);
		}
		return isSuccess;
	}
	
	/**
	 * dispose this map
	 */ 
	override public function dispose():void{
		super.dispose();
		this.added.removeAll();
		this.added = null;
		this.removed.removeAll();
		this.removed = null;
	}
	
	/**
	 * remove all record
	 */ 
	override public function removeAll():void{
		super.removeAll();
		removeAlled.dispatch(this, removeAlled, "removeAll"); 
	}
	
}
}