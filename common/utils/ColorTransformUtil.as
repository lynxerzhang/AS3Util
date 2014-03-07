package common.utils 
{
import flash.geom.ColorTransform;

/**
 * 等同于flash面板中Color Effect的各种色彩设置
 */
public class ColorTransformUtil 
{
	/**
	* 复制指定的colortransform对象, 可为bitmapData的draw方法指定colortransform参数
	* @param	cort
	* @param	copy
	* @return
	*/
	public static function copyColorTransform(cort:ColorTransform, result:ColorTransform = null):ColorTransform{
		if (!result) {
			result = new ColorTransform();
		}
		else {
			reset(result);
		}
		result.concat(cort);
		return result;
	}
	
	private static function reset(color:ColorTransform):void {
		color.alphaMultiplier = 1;
		color.redMultiplier = 1;
		color.greenMultiplier = 1;
		color.blueMultiplier = 1;
		color.alphaOffset = 0;
		color.redOffset = 0;
		color.greenOffset = 0;
		color.blueOffset = 0;
	}
	
	/**
	 * 设置alpha值
	 * @param	alpha	0 - 1
	 * @param	result
	 * @return
	 */
	public static function getAlpha(alpha:Number, result:ColorTransform = null):ColorTransform {
		if (!result) {
			result = new ColorTransform();
		}
		else {
			reset(result);
		}
		if (alpha < 0) {
			alpha = 0;
		}
		else if (alpha > 1) {
			alpha = 1;
		}
		result.alphaMultiplier = alpha;
		return result;
	}
	
	/**
	 * 设置brightness
	 * @param	bright	(-1 - 1)
	 * @param	result
	 * @return
	 */
	public static function getBrightness(bright:Number, result:ColorTransform = null):ColorTransform {
		if (!result) {
			result = new ColorTransform();
		}
		else {
			reset(result);
		}
		
		if (bright < -1) {
			bright = -1;
		}
		else if (bright > 1) {
			bright = 1;
		}
		
		if (bright < 0) {
			bright *= -1;
		}
		else {
			result.redOffset = bright * 0xFF;
			result.greenOffset = bright * 0xFF;
			result.blueOffset = bright * 0xFF;
			result.alphaOffset = 0;
		}
		var multiplier:Number = 1 - bright;
		result.redMultiplier = multiplier;
		result.greenMultiplier = multiplier;
		result.blueMultiplier = multiplier;
		result.alphaMultiplier = 1;
		return result;
	}
	
	/**
	 * 设置tint色彩值及强度
	 * @param	colorHex
	 * @param	tint	(0 - 1)
	 * @param	result
	 */
	public static function getTint(colorHex:uint, tint:Number, result:ColorTransform = null):ColorTransform {
		if (!result) {
			result = new ColorTransform();
		}
		else {
			reset(result);
		}
		
		if (tint < 0) {
			tint = 0;
		}
		else if (tint > 1) {
			tint = 1;
		}
		
		var red:int = colorHex >> 16 & 0xFF;
		var green:int = colorHex >> 8 & 0xFF;
		var blue:int = colorHex & 0xFF;
		
		var multiplier:Number = 1 - tint;
		result.redMultiplier = multiplier;
		result.greenMultiplier = multiplier;
		result.blueMultiplier = multiplier;
		
		result.redOffset = red * tint;
		result.greenOffset = green * tint;
		result.blueOffset = blue * tint;
		return result;
	}
	
}

}