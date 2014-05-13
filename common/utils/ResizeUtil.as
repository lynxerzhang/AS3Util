package common.utils
{
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.geom.Rectangle;

public class ResizeUtil
{
	public function ResizeUtil()
	{
	}
	
	/**
	 * 缩放制定的显示对象
	 * @param dis		制定显示对象
	 * @param width		长度范围
	 * @param height	高度范围
	 * @return 			返回缩放值
	 */	
	public static function resizeDisplayObject(dis:DisplayObject, width:Number = NaN, height:Number = NaN):Number
	{
		var s:Number = 1;
		if(width != width || height != height){
			//just a isNaN check
			return s;
		}
		var actualSize:Rectangle = DisplayObjectUtil.getActualSize(dis);
		if(width >= actualSize.width && height >= actualSize.height){
			return s;
		}
		//var rect:Rectangle = dis.transform.pixelBounds;
		var rect:Rectangle = dis.getBounds(dis);
		var isInWidthChange:Boolean = false;
		if(width < actualSize.width){
			dis.width = width;
			dis.height = width * (rect.height / rect.width);
			s = width / rect.width;
			isInWidthChange = true;
		}
		var heightCheckValue:Number = isInWidthChange ? dis.height : actualSize.height;
		if(height < heightCheckValue){
			dis.height = height;
			dis.width = height * (rect.width / rect.height);
			s = height / rect.height;
		}
		if(dis is Bitmap){
			Bitmap(dis).smoothing = true;
			Bitmap(dis).pixelSnapping = PixelSnapping.AUTO;
		}
		return s;
	}
	
	/**
	 * 按比例缩放指定长宽
	 * @param width		
	 * @param height
	 * @param targetWidth
	 * @param targetHeight
	 * @return 
	 */	
	public static function resize(width:Number, height:Number, targetWidth:Number, targetHeight:Number):Number
	{
		var s:Number = 1;
		if(targetWidth >= width && targetHeight >= height){
			return s;
		}
		var ratio:Number = width / height;
		var w:Number = targetWidth;
		var h:Number = targetHeight;
		if (ratio >= 1) {
			h = targetWidth / ratio;
			if (h > targetHeight) {
				h = targetHeight;
				w = h * ratio;
			}
		}else {
			w = targetHeight * ratio;
			if (w > targetWidth) {
				w = targetWidth;
				h = w / ratio;
			}
		}
		return s;
	}
}
}