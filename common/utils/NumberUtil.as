package common.utils
{
import flash.utils.getQualifiedClassName;

public class NumberUtil
{
	/**
	 * 获取指定整形的绝对值
	 * @param value
	 * @return 
	 */
	public static function getAbsolute(value:int):int{
		return (value ^ value >> 31) - (value >> 31);
	}
	
	/**
	 * 获取2个整形数值中的最小值
	 * @param x
	 * @param y
	 * @return 
	 */
	public static function minInt(x:int, y:int):int{
		return y ^ ((x ^ y) & ((x - y) >> 31));
	}
	
	/**
	 * 获取2个整形数值中的最大值
	 * @param x
	 * @param y
	 * @return 
	 */
	public static function maxInt(x:int, y:int):int{
		return x ^ ((x ^ y) & ((x - y) >> 31));
	}
	
	/**
	 * 返回最小值 略快于Math.min
	 * @param	x
	 * @param	y
	 * @return
	 */
	public static function minNum(x:Number, y:Number):Number {
		return (x - y) * int((x - y) < 0) + y;
	}
	
	/**
	 * 返回最大值 略快于Math.max
	 * @param	x
	 * @param	y
	 * @return
	 */
	public static function maxNum(x:Number, y:Number):Number {
		return (x - y) * int((x - y) > 0) + y;
	}
	
	/**
	 * 获取指定整形数值是否为偶数
	 * @param num
	 * @return 
	 */
	public static function isEven(num:int):Boolean{
		return (num & 1) == 0;
	}
	
	/**
	 * 检查指定数值是否为2的倍数
	 * @param num
	 * @return 
	 */
	public static function isPowerOfTwo(num:int):Boolean{
		return num && !(num & (num - 1));
	}
	
	/**
	 * 检查2个整形数值的符号是否相同
	 * @param a
	 * @param b
	 * @return 
	 */
	public static function sameSignInt(a:int, b:int):Boolean{
		return Boolean((a ^ b) >> 31 == 0);
	}
	
	/**
	 * 检查指定数值对象是否为NaN类型
	 * @return
	 */
	public static function isNaN(val:Number):Boolean {
		return val != val;
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
	 * 将指定数值完成指定位数的ceil转换
	 * @param num
	 * @param fixedPoint
	 * @return 
	 */
	public static function ceilFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.ceil(num * n) * fixedPoint).toFixed(getFrictionCount(fixedPoint)));
	}
	
	/**
	 * 将指定数值完成指定位数的floor转换
	 * @param num
	 * @param fixedPoint
	 * @return 
	 * 
	 */
	public static function floorFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.floor(num * n) * fixedPoint).toFixed(getFrictionCount(fixedPoint)));
	}
	
	/**
	 * 将指定数值完成指定位数的round转换
	 * @param num
	 * @param fixedPoint
	 * @return 
	 */
	public static function roundFixedPoints(num:Number, fixedPoint:Number = .01):Number{
		if(getQualifiedClassName(num) == "int"){
			return num;
		}
		var n:int = 1 / fixedPoint;
		return Number((Math.round(num * n) * fixedPoint).toFixed(getFrictionCount(fixedPoint)));
	}
	
	/**
	 * 
	 * @param ns
	 * @return 
	 */
	private static function getFrictionCount(ns:Number):int{
		var s:String = String(ns);
		return s.slice(s.lastIndexOf(".") + 1).length;
	}
}
}