package common.utils
{
public class ColorUtil
{
	/**
	 * 转换为24位16进制数值
	 * @param	r
	 * @param	g
	 * @param	b
	 * @example trace(ColorUtil.to24Hex(255, 255, 0).toString(16)); //ffff00
	 * @return
	 */
	public static function to24Hex(r:int, g:int, b:int):uint {
		return r << 16 | g << 8 | b;
	}
	
	/**
	 * 转换为32位16进制数值
	 * @param	a
	 * @param	r
	 * @param	g
	 * @param	b
	 * @example trace(ColorUtil.to32Hex(255, 0, 255, 255).toString(16)); //ff00ffff
	 * @return
	 */
	public static function to32Hex(a:int, r:int, g:int, b:int):uint {
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	private static var rgb:Object = { };
	
	/**
	 * 将16进制数值转换为argb形式
	 * @param	hex
	 * @example trace(ColorUtil.toRGB(0xFF6600)); //a:0, r:255, g:102, b:0
	 * @return
	 */
	public static function toRGB(hex:uint):Object {
		rgb.a = hex >> 24 & 0xFF;
		rgb.r = hex >> 16 & 0xFF;
		rgb.g = hex >> 8 & 0xFF;
		rgb.b = hex & 0xFF;
		return rgb;
	}
	
	/**
	 * 将十进制数值转换为以16进制显示的字符串
	 * @param	hex
	 * @example trace(ColorUtil.toString(16737792)); //"0xff6600"
	 * @return
	 */
	public static function toString(hex:uint):String {
		return "0x" + hex.toString(16);
	}
	
	/**
	 * 将16进制字符串转换为十进制数值
	 * @param	str
	 * @example trace(ColorUtil.toHex("0xff6600")); //16737792
	 * @return
	 */
	public static function toHex(str:String):uint {
		return parseInt(str, 16);
	}
	
	/**
	 * 获取2种24位颜色值的指定比例色彩值
	 * @param	from
	 * @param	to
	 * @param	ratio
	 * @return
	 */
	public static function fadeHex24(from:uint, to:uint, ratio:Number):uint {
		var r:int = from >> 16 & 0xFF;
		var g:int = from >> 8 & 0xFF;
		var b:int = from & 0xFF;
		if (ratio < 0) {
			ratio = 0;
		}
		else if (ratio > 1) {
			ratio = 1;
		}
		var nr:int = r + ((to >> 16 & 0xFF) - r) * ratio;
		var ng:int = g + ((to >> 8 & 0xFF) - g) * ratio;
		var nb:int = b + ((to & 0xFF) - b) * ratio;
		return nr << 16 | ng << 8 | nb;
	}
	
	/**
	 * 获取2种32位颜色值的指定比例色彩值
	 * @param	from
	 * @param	to
	 * @param	ratio
	 * @return
	 */
	public static function fadeHex32(from:uint, to:uint, ratio:Number):uint {
		var a:int = from >> 24 & 0xFF;
		var r:int = from >> 16 & 0xFF;
		var g:int = from >> 8 & 0xFF;
		var b:int = from & 0xFF;
		if (ratio < 0) {
			ratio = 0;
		}
		else if (ratio > 1) {
			ratio = 1;
		}
		var na:int = a + ((to >> 24 & 0xFF) - a) * ratio;
		var nr:int = r + ((to >> 16 & 0xFF) - r) * ratio;
		var ng:int = g + ((to >> 8 & 0xFF) - g) * ratio;
		var nb:int = b + ((to & 0xFF) - b) * ratio;
		return na << 24 | nr << 16 | ng << 8 | nb;
	}
	
	/**
	 * 获取2种24位颜色值的插值色彩值对
	 * 
	 * @param	from
	 * @param	to
	 * @param	step
	 * @param	result
	 * 
	 * @see		http://www.pixelwit.com/blog/2008/05/color-fading-array/
	 * @return
	 */
	public static function getFadeHex24Step(from:uint, to:uint, step:int, 
					result:Vector.<uint> = null):Vector.<uint> {
		if (step < 1) {
			step = 1;
		}
		if (!result) {
			result = new Vector.<uint>();
		}
		result.length = ++step;
		
		var r:int = from >> 16 & 0xFF;
		var g:int = from >> 8 & 0xFF;
		var b:int = from & 0xFF;
		
		var nr:int = (to >> 16 & 0xFF) - r;
		var ng:int = (to >> 8 & 0xFF) - g;
		var nb:int = (to & 0xFF) - b;
		
		var ratio:Number = 0;
		for (var i:int = 0; i <= step; i ++) {
			ratio = i / step;
			result[i] = (r + nr * ratio) << 16 | (g + ng * ratio) << 8 | (b + nb * ratio);
		}
		return result;
	}
	
	/**
	 * 获取2种32位颜色值的插值色彩值对
	 * 
	 * @param	from
	 * @param	to
	 * @param	step
	 * @param	result
	 * 
	 * @see		http://www.pixelwit.com/blog/2008/05/color-fading-array/
	 * @return
	 */
	public static function getFadeHex32Step(from:uint, to:uint, step:int, 
					result:Vector.<uint> = null):Vector.<uint> {
		if (step < 1) {
			step = 1;
		}
		if (!result) {
			result = new Vector.<uint>();
		}
		result.length = ++step;
		
		var a:int = from >> 24 & 0xFF;
		var r:int = from >> 16 & 0xFF;
		var g:int = from >> 8 & 0xFF;
		var b:int = from & 0xFF;
		
		var na:int = (to >> 24 & 0xFF) - a;
		var nr:int = (to >> 16 & 0xFF) - r;
		var ng:int = (to >> 8 & 0xFF) - g;
		var nb:int = (to & 0xFF) - b;
		
		var ratio:Number = 0;
		for (var i:int = 0; i <= step; i ++) {
			ratio = i / step;
			result[i] = (a + na * ratio) << 24 | (r + nr * ratio) << 16 
					| (g + ng * ratio) << 8 | (b + nb * ratio);
		}
		return result;
	}
}
}