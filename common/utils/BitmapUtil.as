package common.utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.display.Loader;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class BitmapUtil
{
	
	/**
	* 销毁指定容器中的位图对象
	* @param	d
	* @param	isRemove
	*/
	public static function removeBitmap(d:DisplayObjectContainer, isRemove:Boolean = false):void{
		if(!d){
			return;
		}
		var len:int = d.numChildren;
		var bp:Bitmap;
		while(--len > -1){
			var c:DisplayObject = d.getChildAt(len);
			if(c is Bitmap){
				bp = Bitmap(c);
				if(bp.bitmapData){
					bp.bitmapData.dispose();
					bp.bitmapData = null;
				}
				if (isRemove) {
					d.removeChildAt(len);
				}
			}
		}
	}

	/**
	* 获取指定显示对象的位图对象
	* @param	dis
	* @param	result
	* @return
	*/
	public static function getBitmap(dis:DisplayObject, result:Bitmap = null):Bitmap {
		var d:Bitmap = result;
		if (!d) {
			d = new Bitmap();
		}
		var bitmapData:BitmapData = getBitmapData(dis);
		d.bitmapData = bitmapData;
		return d;
	}

	/**
	* 获取指定显示对象的位图对象, 并包装以Sprite对象并返回
	* @param dis
	* @return 
	*/
	public static function getCopySprite(dis:DisplayObject):Sprite{
		if(!checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = DisplayObjectUtil.getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = DisplayObjectUtil.getLeftTopPosition(dis, HELP_POINT);
		var b:Rectangle = new Rectangle(0, 0, wh.width, wh.height);
		if (len > 0) {
			var tbd:BitmapData;
			var tRect:Rectangle;
			for(var i:int = 0; i < len; i ++){
				tbd = new BitmapData(wh.width, wh.height, true, 0);
				tRect = tbd.generateFilterRect(tbd.rect, dis.filters[i]);
				b = b.union(tRect);
				tbd.dispose();
			}
		}
		var sx:Number = dis.scaleX;
		var sy:Number = dis.scaleY;
		HELP_MATRIX.setTo(sx, 0, 0, sy, -b.x + p.x, -b.y + p.y);
		var dt:BitmapData = new BitmapData(b.width, b.height, true, 0);
		dt.draw(dis, HELP_MATRIX, c);
		var s:Sprite = new Sprite();
		var bt:Bitmap = new Bitmap(dt);
		s.addChild(bt);
		bt.x = b.x - p.x;
		bt.y = b.y - p.y;
		return s;
	}

	/**
	* 获取指定显示对象的位图数据对象
	* @param	dis
	* @return
	*/
	public static function getBitmapData(dis:DisplayObject):BitmapData{
		if(!checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = DisplayObjectUtil.getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = DisplayObjectUtil.getLeftTopPosition(dis, HELP_POINT);
		var b:Rectangle = new Rectangle(0, 0, wh.width, wh.height);
		if (len > 0) {
			var tbd:BitmapData;
			var tRect:Rectangle;
			for(var i:int = 0; i < len; i ++){
				tbd = new BitmapData(wh.width, wh.height, true, 0);
				tRect = tbd.generateFilterRect(tbd.rect, dis.filters[i]);
				b = b.union(tRect);
				tbd.dispose();
			}
		}
		var sx:Number = dis.scaleX;
		var sy:Number = dis.scaleY;
		HELP_MATRIX.setTo(sx, 0, 0, sy, -b.x + p.x, -b.y + p.y);
		var bitmapData:BitmapData = new BitmapData(b.width, b.height, true, 0);
		bitmapData.draw(dis, HELP_MATRIX, c);
		return bitmapData;
	}

	/**
	* 获取指定显示对象的不透明像素区域的位图数据对象
	* @param d 传入DisplayObject或BitmapData对象
	* @return 
	*/
	public static function getOpaqueBitmapData(d:IBitmapDrawable, dispose:Boolean = true):BitmapData {
		var bitmapData:BitmapData;
		if (d is DisplayObject) {
			var result:DisplayObject = DisplayObject(d);
			if(!checkDraw(result)){
				return null;
			}
			bitmapData = getBitmapData(result);
		}
		else {
			bitmapData = d as BitmapData;
		}
		if (!bitmapData) {
			return null;
		}
		var area:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		var c:BitmapData = new BitmapData(area.width, area.height, true, 0);
		c.copyPixels(bitmapData, area, HELP_ZERO_POINT);
		if (dispose) {
			bitmapData.dispose(); //will dispose
		}
		return c;
	}

	/**
	* 移除指定显示对象中的某种指定像素(首先会将该显示对象转为位图对象)
	* @param	d
	* @param	pixel
	* @param	needOpaque
	* @return
	*/
	public static function removePixel(d:DisplayObject, pixel:uint, needOpaque:Boolean = false):BitmapData{
		if(!checkDraw(d)){
			return null;
		}
		var bmpData:BitmapData = getBitmapData(d);
		//If ((pixelValue & mask) operation (threshold & mask)), then set the pixel to color;
		bmpData.threshold(bmpData, bmpData.rect, HELP_ZERO_POINT, "==", pixel, 0x00000000);
		if(needOpaque){
			var area:Rectangle = bmpData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var c:BitmapData = new BitmapData(area.width, area.height, true, 0);
			c.copyPixels(bmpData, area, HELP_ZERO_POINT);
			bmpData.dispose();
			bmpData = c;
		}
		return bmpData;
	}

	/**
	* 将指定显示对象绘制成一个指定长宽的位图数据对象
	* @param dis
	* @param range
	* @return 
	*/
	public static function sampling(dis:DisplayObject, range:Rectangle = null):BitmapData{
		if(!checkDraw(dis)){
			return null;
		}
		if(!range || ((range.width >= dis.width) && (range.height >= dis.height))){
			return getBitmapData(dis);
		}
		//var rect:Rectangle = dis.transform.pixelBounds;
		var rect:Rectangle = dis.getBounds(dis);
		var s:Number;
		if(range.width < dis.width){
			dis.width = range.width;
			dis.height = range.width * (rect.height / rect.width);
			s = range.width / rect.width;
		}
		if(range.height < dis.height){
			dis.height = range.height;
			dis.width = range.height * (rect.width / rect.height);
			s = range.height / rect.height;
		}
		var bd:BitmapData = new BitmapData(dis.width, dis.height, true, 0);
		var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(dis, HELP_POINT);
		HELP_MATRIX.setTo(s, 0, 0, s, topLeft.x, topLeft.y);
		bd.draw(dis, HELP_MATRIX);
		return bd;
	}

	/**
	* 合并透明通道的rgb位图数据对象
	* @param	r	rgb通道位图
	* @param	a	透明通道位图
	* @return
	*/
	public static function combinePng(r:BitmapData, a:BitmapData):BitmapData{
		var rgb:BitmapData = r.clone();
		var rect:Rectangle = rgb.rect;
		rgb.copyChannel(a, rect, HELP_ZERO_POINT, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		rgb.copyChannel(a, rect, HELP_ZERO_POINT, BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
		rgb.copyChannel(a, rect, HELP_ZERO_POINT, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
		return rgb;
	}

	/**
	* 获取指定位图对象的透明通道
	* @param data        指定位图数据
	* @return BitmapData 返回一个包含透明通道的位图数据结构
	*/ 
	public static function getAlphaChannel(data:BitmapData):BitmapData{
		var alp:BitmapData = new BitmapData(data.width, data.height, true, 0xFF000000);
		var rect:Rectangle = alp.rect;
		alp.copyChannel(data, rect, HELP_ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
		alp.copyChannel(data, rect, HELP_ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
		alp.copyChannel(data, rect, HELP_ZERO_POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
		return alp;
	}

	/**
	* 返回指定位图的指定通道位图对象
	* @param	raw
	* @param	channel
	* @return
	*/
	public static function copyBitmapChannel(raw:BitmapData, channel:uint):BitmapData{
		var d:BitmapData = new BitmapData(raw.width, raw.height, true, 0xFF000000);
		d.copyChannel(raw, d.rect, HELP_ZERO_POINT, channel, channel);
		return d;
	}

	/**
	* 检查指定显示对象在指定舞台坐标点下是否为透明像素 (如果是透明像素, 返回false)
	* @param dis
	* @param point
	* @return 
	*/
	public static function checkHitTest(dis:DisplayObject, point:Point):Boolean{
		if(!dis.parent){
			return false;
		}
		var bitmapData:BitmapData = getBitmapData(dis);//get the copy(the reg point is on the leftTop)
		var offset:Point = DisplayObjectUtil.getLeftTopPosition(dis, HELP_POINT);
		offset.x = -offset.x + dis.x; //get the display object's top left position(0, 0)
		offset.y = -offset.y + dis.y; 
		var p:Point = dis.parent.localToGlobal(offset); //get the global position value
		HELP_POINT.setTo(point.x - p.x, point.y - p.y);
		var transparent:Boolean = bitmapData.hitTest(HELP_ZERO_POINT, 0xFF, HELP_POINT);
		bitmapData.dispose();
		return transparent;
	}

	//HELPER
	private static const HELP_ZERO_POINT:Point = new Point(0, 0);
	private static const HELP_MATRIX:Matrix = new Matrix();
	private static const HELP_POINT:Point = new Point();

	//HELPER
	private static const CHECK_BMPD:BitmapData = new BitmapData(1, 1, true, 0);
	private static const CHECK_MATRIX:Matrix = new Matrix();
	private static const CHECK_POINT:Point = new Point();

	/**
	* 检查指定显示对象在指点鼠标点下是否为透明 (如果是透明像素, 返回true)
	* @param dis   指定显示对象
	* @param point 指定鼠标点Point对象, 为舞台全局坐标         
	*/ 
	public static function checkTransParent(dis:DisplayObject, point:Point):Boolean{
		if(!dis){
			return true;
		}
		CHECK_BMPD.fillRect(CHECK_BMPD.rect, 0);
		CHECK_POINT.x = point.x;
		CHECK_POINT.y = point.y;
		point = dis.globalToLocal(CHECK_POINT);
		CHECK_POINT.setTo(point.x, point.y);
		CHECK_MATRIX.tx = -CHECK_POINT.x|0;
		CHECK_MATRIX.ty = -CHECK_POINT.y|0;
		CHECK_BMPD.draw(dis, CHECK_MATRIX);
		return ((CHECK_BMPD.getPixel32(0, 0) >>> 24) & 0xFF) < 0x80;
	}


	/**
	* 获取指定容器在给定坐标下的显示对象数组集合 (返回的数组的排列顺序和显示列表顺序相同)
	* 
	* @param container  指定显示容器 (一般就传入stage实例即可)
	* @param px         指定x轴坐标 
	* @param py         指定y轴坐标
	*/ 
	public static function getObjectsUnderXY(container:DisplayObjectContainer, px:Number, py:Number):Array {
		HELP_POINT.setTo(px, py);
		var disAry:Array = container.getObjectsUnderPoint(HELP_POINT);
		var len:int = disAry.length;
		var dis:DisplayObject;
		for (var i:int = 0; i < len; i ++) {
			dis = disAry[i];
			if(!(dis is DisplayObjectContainer)){
				var c:DisplayObject = dis.parent as DisplayObject; //maybe a simpleButton
				if(c){
					disAry[i] = c;
				}
			}
		}
		return disAry;
	}

	/**
	* @see getDisObjectUnderPoint
	*/ 
	public static function getObjectUnderXY(container:DisplayObjectContainer, px:Number, py:Number):DisplayObject{
		HELP_POINT.setTo(px, py);
		return getDisObjectUnderPoint(container, HELP_POINT);
	}


	/**
	* 根据传入的自定义方法来过滤获取的显示对象列表
	* @param	c
	* @param	x
	* @param	y
	* @param	check
	* @return
	*/
	public static function filterObjectsUnderXY(c:DisplayObjectContainer, x:Number, y:Number, check:Function):Boolean{
		var d:Array = getObjectsUnderXY(c, x, y);
		return d.some(function(dis:DisplayObject, ...args):Boolean{
			return check(dis);
		});
	}

	/**
	* @inspired from the monsterDebugger opensource framework
	* should be note this method will return only a displayobject 
	* (note: the simplebutton's state resource, shape.parent should be SimpleButton, but actually is null)
	* 
	* @param container             一般建议传送舞台实例(非舞台实例貌似造成一些无法预估的问题, 而且已经排除是坐标转换造成的) 
	* @param p                     检测点 最好是舞台全局坐标(如不是方法内部会进行转换)
	* @param isMindMouseChildren   是否考虑检测容器mouseChildren属性
	* @param isMindTransParent     是否检测指定点下的透明度(不考虑显示层级)
	* 
	* @issue 
	* in adobe document
	*   Starting with Player version 11.2 / AIR version 3.2, the parent property of the 
	* states of a SimpleButton object will report null if queried.
	* 
	* 关于获取特殊显示对象如SimpleButton, 很奇怪, Flash IDE 一切正常, 但是在FB中, simpleButton
	* 中的shape.parent 为null.., 因此无法继续获取了改按钮了, 不确定是否是sdk版本的关系。
	* 
	* getObjectsUnderPoint 这个方法貌似在11.2以后不但是SimpleButton, 
	* 即便是一个buttonMode为true的模拟按钮行为的MovieClip也取不到,看来全局
	* 使用getObjectsUnderPoint取SimpleButton在11.2之后是不行了
	*/ 
	public static function getDisObjectUnderPoint(container:DisplayObjectContainer, 
											  p:Point, 
											  isMindMouseChildren:Boolean = false, 
											  isMindTransParent:Boolean = false,
											  isMindStageChild:Boolean = false):DisplayObject{
		if(!container || !p){
			return null;
		}
		if(container.areInaccessibleObjectsUnderPoint(p)){
			return container;
		}
		var c:Point = p.clone();
		if(!(container is Stage)){
			c = container.localToGlobal(c);
		}

		var disAry:Array = container.getObjectsUnderPoint(c);
		if((!disAry) || (disAry.length == 0)){
			return container;
		}

		if(isMindStageChild){
			//oops..如下判断是为了避免自定义鼠标形状被"错误"圈入其中, 如果sdk大于4.5,
			//则Mouse类有内置设置自定义鼠标形态方法, 就不需要如下的判断了...
			disAry = disAry.filter(function(item:DisplayObject, ...args):Boolean{
				return item.root != container.stage;
			});
		}

		if((!disAry) || (disAry.length == 0)){
			return container;
		}

		var backForWardIndex:int = 1;
		var found:DisplayObject = disAry[disAry.length - backForWardIndex];
		if(isMindTransParent){
			while(found && checkTransParent(found, c)){
				if(++backForWardIndex > disAry.length){
					break;
				}
				found = disAry[disAry.length - backForWardIndex];
			}
		}
		disAry.length = 0;

		if(!found){
			return container;
		}

		do{
			disAry.push(found);
			if(!found.parent){
				break;
			}
			found = found.parent;
		}while(found)
			
		var len:int = disAry.length;
		while(--len > -1){
			var _c:DisplayObject = disAry[len];
			if(_c is DisplayObjectContainer){
				found = _c;
				if(!((_c as DisplayObjectContainer).mouseChildren)){
					if(isMindMouseChildren){
						break;
					}
				}
			}
			else{
				if(_c is SimpleButton){
					found = _c;
				}
				break;
			}
		}
		return found;
	}

	private static function checkDraw(dis:DisplayObject):Boolean{
		if(dis.width <= 0 || dis.height <= 0){
			return false;
		}
		if(dis is Loader){
			return (dis as Loader).contentLoaderInfo.childAllowsParent;
		}
		return true;
	}
}
}