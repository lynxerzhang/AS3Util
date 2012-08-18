package utils
{
import fl.motion.AdjustColor;
import fl.motion.ColorMatrix;

import flash.display.DisplayObject;
import flash.geom.ColorTransform;

/**
 * need flash's fl package
 */ 
public class ColorUtil
{
	public function ColorUtil()
	{
	}
	
	/**
	 * set displayobject's color
	 */ 
	public static function setColor(dis:DisplayObject, hex:uint):void{
		var ctf:ColorTransform = dis.transform.colorTransform;
		ctf.color = hex;
		dis.transform.colorTransform = ctf;
	}
	
	/**
	 * 
	 */ 
	private static const colorMatrix:AdjustColor = new AdjustColor();
	
	//below advanced change color method depend on fl package, so I advised use gskinner's library
	/**
	 * change brightness (from -100 - 100)
	 */ 				
	public static function setBright(value:Number):Array{
		var v:Number = getGoodValue(-100, 100, value);
		colorMatrix.brightness = value;
		colorMatrix.contrast = 0;
		colorMatrix.hue = 0;
		colorMatrix.saturation = 0;
		return colorMatrix.CalculateFinalFlatArray();
	}
	
	/**
	 * change contrast (from -100 - 100)
	 */ 
	public static function setContrast(value:Number):Array{
		var v:Number = getGoodValue(-100, 100, value);
		colorMatrix.brightness = 0;
		colorMatrix.contrast = value;
		colorMatrix.hue = 0;
		colorMatrix.saturation = 0;
		return colorMatrix.CalculateFinalFlatArray();
	}
	
	/**
	 * change saturation (from -100 - 100)
	 */ 
	public static function setSaturation(value:Number):Array{
		var v:Number = getGoodValue(-100, 100, value);
		colorMatrix.brightness = 0;
		colorMatrix.saturation = value;
		colorMatrix.contrast = 0;
		colorMatrix.hue = 0;
		return colorMatrix.CalculateFinalFlatArray();
	}
	
	/**
	 * 
	 * chagne hue (from -180 - 180)
	 * and notice this value is angle, so we should convert this
	 * value to radian value
	 */ 
	public static function setHue(value:Number):Array{
		var v:Number = getGoodValue(-180, 180, value);
		colorMatrix.brightness = 0;
		colorMatrix.saturation = 0;
		colorMatrix.contrast = 0;
		colorMatrix.hue = v;
		return colorMatrix.CalculateFinalFlatArray();
	}
	
	/**
	 * get a correct range value
	 */ 
	private static function getGoodValue(min:Number, max:Number, value:Number):Number{
		return Math.min(Math.max(min, value), max);
	}
	
	/**
	 * set all advanced color
	 * 
	 * @param bright set bright
	 * @see setBright
	 * 
	 * @param contrast set contrast
	 * @see setContrast
	 * 
	 * @param sat set saturation
	 * @see setSaturation
	 * 
	 * @param hue set hue
	 * @see setHue
	 */ 
	public static function setAllAdColor(bright:Number = 0, contrast:Number = 0, sat:Number = 0, hue:Number = 0):Array{
		var bright:Number = getGoodValue(-100, 100, bright);
		var contrast:Number = getGoodValue(-100, 100, contrast);
		var sat:Number = getGoodValue(-100, 100, sat);
		var hue:Number = getGoodValue(-180, 180, hue);
		colorMatrix.brightness = bright;
		colorMatrix.contrast = contrast;
		colorMatrix.saturation = sat;
		colorMatrix.hue = hue;
		return colorMatrix.CalculateFinalFlatArray();
	}
}
}