package tool
{
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
	
/**
 * 
 * inspired from as 3 entity system
 * 
 * TODO
 */ 
public class VectorMap
{
	/**
	 * 
	 */ 
	private static const VECTOR:String = getQualifiedClassName(Vector);
	
	/**
	 * 
	 */ 
	private var record:Dictionary = new Dictionary();
	
	/**
	 * 
	 */ 
	private var vector:*;
	
	/**
	 * @param type   the type you want to build
	 */ 
	public function VectorMap(type:Class)
	{
		var e:String = VECTOR　+ ".<" + getQualifiedClassName(type) + ">";
		var typeClass:Class = getDefinitionByName(e) as Class;
		vector = new typeClass();
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
		return this.vector[index];
	}
	
	/**
	 * get the raw vector
	 */ 
	public function getVector():*{
		return this.vector;
	}
}
}