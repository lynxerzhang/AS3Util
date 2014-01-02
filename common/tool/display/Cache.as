package common.tool.display 
{
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class Cache 
{
	private static var cacheMap:Dictionary = new Dictionary(true);
	
	/**
	 * 返回以Bitmap绘制填充的Shape对象
	 * @param	sp
	 * 
	 * @example 
	 * //create shape cache
	 * var s:Sprite = new Sprite();
	 * s.addChild(Cache.cache(s));
	 * 
	 * //dispose shape cache
	 * Cache.dispose(s);
	 * @return
	 */
	public static function cache(sp:Sprite):Shape{
		var d:Shape = new Shape();
		var r:Rectangle = sp.getBounds(sp);			
		
		var c:BitmapData = new BitmapData(r.width, r.height, true, 0);
		c.draw(sp, new Matrix(1, 0, 0, 1, -r.x, -r.y));
		
		d.graphics.beginBitmapFill(c);
		d.graphics.drawRect(0, 0, r.width, r.height);
		d.graphics.endFill();
		d.x = r.x;
		d.y = r.y;
		
		cacheMap[sp] = c;
		return d;
	}
	
	/**
	 * 销毁Bitmap位图填充所依赖的位图对象
	 * @param	sp
	 */
	public static function dispose(sp:Sprite):void {
		if (cacheMap[sp]) {
			BitmapData(cacheMap[sp]).dispose();
			delete cacheMap[sp];
		}
	}
}

}