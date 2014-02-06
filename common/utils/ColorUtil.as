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
	
}
}