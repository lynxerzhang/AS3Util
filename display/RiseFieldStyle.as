package display
{
/**
 * 
 *  自定义漂浮文字样式
 */ 
public class RiseFieldStyle
{
	
	/*字体色彩 hex*/
	public var fontColor:uint = RiseFieldArgu.WHITE;
	
	/*外发光色彩 hex*/
	public var glowColor:uint = RiseFieldArgu.GLOW_COLOR;
	
	/*字体尺寸*/
	public var fontSize:uint = RiseFieldArgu.FONT_SIZE;
	
	//----------------------------------
	/*步进值*/
	public var stepperRate:Number = RiseFieldArgu.STEPPER;
	
	/*透明度步进值*/
	public var alphaRate:Number = RiseFieldArgu.ALPHA;
	//----------------------------------
	
	//动画延迟时间(毫秒数)
	public var frozenTime:Number = RiseFieldArgu.FROZEN_TIME;
	
	public function RiseFieldStyle()
	{	
	}
	
	/*setFontColor 设置字体色彩*/
	public function setFontColor(color:uint):RiseFieldStyle{
		this.fontColor = color;
		return this;
	}
	
	/*setGlowColor 设置字体外发光滤镜色彩 */
	public function setGlowColor(color:uint):RiseFieldStyle{
		this.glowColor = color;
		return this;
	}
	
	/*setFontSize 设置字体尺寸*/
	public function setFontSize(size:uint):RiseFieldStyle{
		this.fontSize = size;
		return this;
	}
	
	/*setStepperRate 设置运动步进值*/
	public function setStepperRate(s:Number):RiseFieldStyle{
		this.stepperRate = s;
		return this;
	}
	
	/*setAlphaRate 设置透明度步进值*/
	public function setAlphaRate(s:Number):RiseFieldStyle{
		this.alphaRate = s;
		return this;
	}
	
	/*setFrozenTime 设置动画延迟时间*/
	public function setFrozenTime(s:Number):RiseFieldStyle{
		this.frozenTime = s;
		return this;
	}
}
}