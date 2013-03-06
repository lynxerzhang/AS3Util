package common.display
{
/**
 * 
 */ 
public class RiseFieldArgu
{
	public function RiseFieldArgu()
	{
	}
	
	//white  文本字体色彩（白色）
	public static const WHITE:uint = 0xFFFFFF;
	
	//black            (黑色)  
	public static const BLACK:uint = 0x000000;
	
	//glow filter's color (外发光滤镜色彩)
	public static const GLOW_COLOR:uint = 0xD69A39;
	
	//font size           (文本字体尺寸)
	public static const FONT_SIZE:uint = 16;
	
	//the motion's stepper value (you could use getTimer to test and modify this value to get a good experience)
	//
	public static const STEPPER:Number = 30;
	
	//same with STEPPER
	//
	public static const ALPHA:Number = .6;
	
	//起始冻结时间
	public static const FROZEN_TIME:Number = NaN;
	
}
}