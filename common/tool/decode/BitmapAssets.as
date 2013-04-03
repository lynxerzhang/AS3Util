package common.tool.decode
{
/**
 * @example
 */
public class BitmapAssets implements IBitmapAsset
{
	public function BitmapAssets() 
	{
	}
	
	[Embed(source="pic/1.png", mimeType = "application/octet-stream")]
	public static const RESOURCE_1:Class;
	
	[Embed(source="pic/2.png", mimeType = "application/octet-stream")]
	public static const RESOURCE_2:Class;
	
	[Embed(source="pic/3.png", mimeType = "application/octet-stream")]
	public static const RESOURCE_3:Class;
}
}