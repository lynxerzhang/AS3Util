package common.tool.decode
{
import flash.display.Bitmap;
import flash.display.BitmapData;

/**
 * 
 */
public interface IDecodeBitmapAsset 
{
	function get isComplete():Boolean;
	function get progress():int;
	function getBitmap(cls:Class):Bitmap;
	function getBitmapData(cls:Class):BitmapData;
}
}