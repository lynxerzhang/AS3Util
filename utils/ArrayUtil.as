package utils
{
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * 
 */ 
public class ArrayUtil
{
	public function ArrayUtil()
	{
	}
	
	/**
	 * return a unique element's array
	 *
	 * @param ary
	 * @return
	 */
	public static function getUnique(ary:Array):Array {
		var result:Array = [];
		var len:int = ary.length;
		for (var i:int = 0; i < len; i ++) {
			if(result.lastIndexOf(ary[i]) == -1){
				result.push(ary[i]);
			}
		}
		return result;
	}
	
	/**
	 * check two array has same value
	 */ 
	public static function checkSame(aryA:Array, aryB:Array):Boolean{
		if(!(aryA && aryB)){
			return false;
		}
		if(aryA.length != aryB.length){
			return false;
		}
		var len:int = aryA.length;
		for(var i:int = 0; i < len; i ++){
			if(aryA[i] !== aryB[i]){
				return false;
			}
		}
		return true;
	}
	
	/**
	 *
	 * @param o
	 * @return
	 */
	public static function toArray(o:Object):Array {
		var ary:Array = [];
		for (var item:* in o) {
			ary[ary.length] = item;
		}
		return ary;
	}
	
	
	/**
	 * covert array to vector
	 * 
	 * @param ary the ary 
	 */ 
	public static function toVector(ary:Array):*{
		if((!ary) || (ary && ary.length == 0)){
			return null;
		}
		var type:Class = getDefinitionByName(getQualifiedClassName(ary[0])) as Class;
		var vector:String = getQualifiedClassName(Vector);
		var combine:String = vector　+ ".<" + getQualifiedClassName(type) + ">";
		var typeClass:Class = getDefinitionByName(combine) as Class;
		var t:* = new typeClass();
		var len:int = ary.length;
		for(var i:int = 0; i < len; i ++){
			t.push(ary[i]);
		}
		return t;
	}
	
	/**
	 * deepclone
	 * @param source
	 * @return
	 */
    public static function deepClone(source:Array):Array{
		var myBA:ByteArray = new ByteArray(); 
		myBA.writeObject(source); 
		myBA.position = 0; 
		return myBA.readObject() as Array; 
	}
}
}