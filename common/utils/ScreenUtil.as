package common.utils
{
import flash.system.Capabilities;

/**
 * @see http://www.adobe.com/devnet/flash/articles/authoring_for_multiple_screen_sizes.html
 */
public class ScreenUtil
{
	private static const INIT_DPI:int = Capabilities.screenDPI;
	
	public static var dpi:int = INIT_DPI;
	
	/**
	 * 以英寸单位换算至像素单位
	 * @param	inch
	 * @return
	 */
	public static function inchToPixels(inch:Number):int {
		return Math.round(inch * dpi);
	}
	
	public static const InchToCM:Number = 2.54; //英寸至厘米的换算
	
	/**
	 * 以厘米单位换算至像素单位
	 * @param	cm
	 * @return
	 */
	public static function cmToPixels(cm:Number):int {
		return Math.round(cm / InchToCM * dpi);
	}
	
	/**
	 * 以毫米单位换算至像素单位
	 * @param	mm
	 * @return
	 */
	public static function mmToPixels(mm:Number):int {
		return cmToPixels(mm * .1);
	}
	
	/**
	 * 重置dpi的设置
	 */
	public static function reset():void {
		dpi = INIT_DPI;
	}
}
}


