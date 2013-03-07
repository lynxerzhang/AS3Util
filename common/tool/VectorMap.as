package common.tool
{
import flash.display.MovieClip;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
	

public class VectorMap
{
	/**
	 * 
	 */ 
	protected static const VECTOR:String = getQualifiedClassName(Vector);
	
	/**
	 * 
	 */ 
	protected var record:Dictionary = new Dictionary();
	
	/**
	 * 
	 */ 
	protected var vector:*;
	
	/**
	 * @param type   the type you want to build
	 */ 
	public function VectorMap(type:Class)
	{
		var e:String = VECTOR　+ ".<" + getQualifiedClassName(type) + ">";
		var typeClass:Class = getDefinitionByName(e) as Class;
		vector = new typeClass();
		objectType = type;
	}
	
	private var objectType:Class;
	public function getType():Class{
		return objectType;
	}
	
	/**
	 * check this map whether contain specfied item
	 */ 
	public function contain(item:*):Boolean{
		return Boolean(item in record);
	}
	
	/**
	 * get the vector's length
	 */ 
	public function getLen():int{
		return vector.length;
	}
	
	/**
	 * remove all vectorMap's item
	 */ 
	public function removeAll():void{
		vector.length = 0;
		record = new Dictionary();
	}
	
	/**
	 * check the vector's length is whether zero
	 */ 
	public function isEmpty():Boolean{
		return vector.length == 0;
	}
	
	/**
	 * add specfied item in map
	 */ 
	public function add(item:*):void{
		if(contain(item)){
			remove(item);
		}
		record[item] = vector.push(item) - 1;
	}
	
        /**
	 * add specfied items in map
         */ 
	public function addAll(...args):void{
		var len:int = args.length, i:int;
		for(i = 0; i < len; i ++){
			add(args[i]);
		}
	}

	/**
	 * remove specfied item from map
	 */ 
	public function remove(item:*):void{
		if(contain(item)){
			var c:* = vector.pop();
			if(c != item){
				var p:int = record[item];
				vector[p] = c;
				record[c] = p;
			}
			record[item] = undefined;
			delete record[item];
		}
	}
	
	/**
	 * get the specfied item's index
	 */ 
	public function getIndex(item:*):int{
		if(contain(item)){
			return record[item];
		}
		return -1;
	}
	
	/**
	 * get the content with the specfied index
	 * no check the 
	 */ 
	public function getContent(index:int):*{
		var value:*;
		try{
			value = this.vector[index];
		}
		catch(e:RangeError){
			
		}
		return value;
	}
	
	/**
	 * get the raw vector
	 */ 
	public function getVector():*{
		return this.vector;
	}
	
	/**
	 * execute with every VectorMap's content
	 */ 
	public function forEach(execute:Function):void{
		if(getLen() > 0){
			var c:* = this.vector.concat();
			c.forEach(function(item:*, ...args):void{
				execute(item);
			});
		}
	}
	
	/**
	 * TODO
	 */ 
	public function map(listenerName:String, ...args):void{
		if(getLen() > 0){
			var c:* = this.vector.concat();
			c.forEach(function(item:*, ...args):void{
				if(Object(item).hasOwnProperty(listenerName)){
					item[listenerName].apply(item, args);
				}
			});
		}
	}
}
}
