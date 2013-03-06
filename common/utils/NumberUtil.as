package common.utils
{
import flash.utils.getQualifiedClassName;

public class NumberUtil
{
	public function NumberUtil()
	{
	}	
	
	/**
	 * get absolute value (only integer)
	 */ 
	public static function getAbsolute(value:int):int{
		return (value ^ value >> 31) - (value >> 31);
	}
	
	/**
	 * get the min num (only integer, fast than Math.min()) 
	 */ 
	public static function min(x:int, y:int):int{
		return y ^ ((x ^ y) & -(int(x < y)));
	}
	
	/**
	 * get the max num (only integer, fast than Math.max())
	 */ 
	public static function max(x:int, y:int):int{
		return x ^ ((x ^ y) & -(int(x < y)));
	}
	
	/**
	 * check num is whether even
	 */ 
	public static function isEven(num:int):Boolean{
		return (num & 1) == 0;
	}
	
	/**
	 * check the specfied number is power of two
	 */ 
	public static function isPowerOfTwo(num:int):Boolean{
		return num && !(num & (num - 1));
	}
	
	/**
	 * check whether two number has same sign
	 */ 
	public static function sameSign(a:Number, b:Number):Boolean{
		return ((a >> 31) ^ (b >> 31)) == 0;
	}
	
	public static const ator:Number = Math.PI / 180;
	
	public static const rtoa:Number = 180 / Math.PI;
	
	/**
	 * get a angle (0 - 360) to radian
	 */ 
	public static function angleToRadian(angle:Number):Number{
		return angle * ator;	
	}
	
	
	/**
	 * get a radian to angle
	 */ 
	public static function radianToAngle(radian:Number):Number{
		return radian * rtoa;
	}
	
	/**
	 * get a specfied fixed points number with ceil method
	 */ 
	public static function ceilFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.ceil(num * n) * fixedPoint).toFixed(getFrictionPoint(fixedPoint)));
	}
	
	/**
	 * get a specfied fixed points number with floor method
	 */ 
	public static function floorFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.floor(num * n) * fixedPoint).toFixed(getFrictionPoint(fixedPoint)));
	}
	
	/**
	 * get a specfied fixed points number with round method
	 */ 
	public static function roundFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.round(num * n) * fixedPoint).toFixed(getFrictionPoint(fixedPoint)));
	}
	
	private static function getFrictionPoint(ns:Number):int{
		var s:String = String(ns);
		return s.slice(s.lastIndexOf(".") + 1).length;
	}
	
	public static function getFrictionCount(ns:Number):int{
		return getFrictionPoint(ns);
	}
}
}