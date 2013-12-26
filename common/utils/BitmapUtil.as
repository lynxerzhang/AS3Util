package common.utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
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
	 * @param d
	 */
	public static function removeForBitmap(d:DisplayObjectContainer):void{
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
			}
		}
	}
	
	/**
	 * 获取指定显示对象的位图对象
	 * @param dis
	 * @return 
	 */
	public static function getBitmap(dis:DisplayObject):Bitmap{	
		var bitmapData:BitmapData = getBitmapData(dis);
		return new Bitmap(bitmapData);
	}
	
	/**
	 * 获取指定显示对象的位图数据对象
	 * @param dis
	 * @param sx
	 * @param sy
	 * @see getBitmapData (这里将ColorTransform, filters 计算在内) 
	 * @return 
	 */
	public static function getCopy(dis:DisplayObject, sx:Number = 1.0, sy:Number = 1.0):BitmapData{
		if(dis.width <= 0 || dis.height <= 0){
			return null;
		}
		if(!checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = DisplayObjectUtil.getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = DisplayObjectUtil.getLeftTopPosition(dis, sx, sy);
		var b:Rectangle = new Rectangle(0, 0, wh.width, wh.height);
		if(len > 0){
			for(var i:int = 0; i < len; i ++){
				var temp:BitmapData = new BitmapData(wh.width, wh.height, true, 0);
				var tempRect:Rectangle = temp.generateFilterRect(temp.rect, dis.filters[i]);
				b = b.union(tempRect);
				temp.dispose();
			}
		}
		var mt:Matrix = new Matrix(sx, 0, 0, sy, -b.x + p.x, -b.y + p.y);
		var dt:BitmapData = new BitmapData(b.width, b.height, true, 0);
		dt.draw(dis, mt, c);
		return dt;
	}
	
	/**
	 * 获取指定显示对象的位图对象, 并包装以Sprite对象并返回
	 * @param dis
	 * @param sx
	 * @param sy
	 * @return 
	 */
	public static function getCopySprite(dis:DisplayObject, sx:Number = 1.0, sy:Number = 1.0):Sprite{
		if(dis.width <= 0 || dis.height <= 0){
			return null;
		}
		if(!checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = DisplayObjectUtil.getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = DisplayObjectUtil.getLeftTopPosition(dis, sx, sy);
		var b:Rectangle = new Rectangle(0, 0, wh.width, wh.height);
		if(len > 0){
			for(var i:int = 0; i < len; i ++){
				var temp:BitmapData = new BitmapData(wh.width, wh.height, true, 0);
				var tempRect:Rectangle = temp.generateFilterRect(temp.rect, dis.filters[i]);
				b = b.union(tempRect);
				temp.dispose();
			}
		}
		var mt:Matrix = new Matrix(sx, 0, 0, sy, -b.x + p.x, -b.y + p.y);
		var dt:BitmapData = new BitmapData(b.width, b.height, true, 0);
		dt.draw(dis, mt, c);
		var s:Sprite = new Sprite();
		var bt:Bitmap = new Bitmap(dt);
		s.addChild(bt);
		bt.x = b.x - p.x;
		bt.y = b.y - p.y;
		return s;
	}
	
	/**
	 * 获取指定显示对象的位图数据对象
	 * @param d
	 * @param scaleX
	 * @param scaleY
	 * @return 
	 */
	public static function getBitmapData(d:DisplayObject, scaleX:Number = 1.0, scaleY:Number = 1.0):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!checkDraw(d)){
			return null;
		}
		var offset:Point = DisplayObjectUtil.getLeftTopPosition(d, scaleX, scaleY);
		var bitmapData:BitmapData = new BitmapData(d.width, d.height, true, 0);
		var mtx:Matrix = new Matrix(scaleX, 0, 0, scaleY, offset.x, offset.y);
		bitmapData.draw(d, mtx);
		return bitmapData;
	}
	
	/**
	 * 获取指定显示对象的不透明像素区域的位图数据对象
	 * @param d
	 * @return 
	 */
	public static function getOpaqueDisObj(d:DisplayObject):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!checkDraw(d)){
			return null;
		}
		var bitmapData:BitmapData = getBitmapData(d);
		var unTransparentArea:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
		c.copyPixels(bitmapData, unTransparentArea.clone(), new Point(0, 0));
		bitmapData.dispose();
		return c;
	}
	
	/**
	 * @param bitmapData
	 * @see getOpaqueDisObj
	 * @return 
	 */
	public static function getOpaqueBitmapData(bitmapData:BitmapData):BitmapData{
		var unTransparentArea:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
		c.copyPixels(bitmapData, unTransparentArea.clone(), new Point(0, 0));
		bitmapData.dispose();
		return c;
	}
	
	/**
	 * 移除指定显示对象中的某种指定像素(首先会将该显示对象转为位图对象)
	 * @param d
	 * @param pixel
	 * @param opaque
	 * @return 
	 */
	public static function removePixel(d:DisplayObject, pixel:uint, opaque:Boolean = false):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!checkDraw(d)){
			return null;
		}
		var bmpData:BitmapData = getBitmapData(d);
		bmpData.threshold(bmpData, bmpData.rect, new Point(0, 0), "==", pixel, 0x00000000);
		if(opaque){
			var unTransparentArea:Rectangle = bmpData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
			c.copyPixels(bmpData, unTransparentArea.clone(), new Point(0, 0));
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
		if((dis.width == 0) || (dis.height == 0)){
			return null;
		}
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
		var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(dis);
		bd.draw(dis, new Matrix(s, 0, 0, s, topLeft.x, topLeft.y));
		return bd;
	}
	
	/**
	 * inspired from showbox (a air game develop tool) and grantskiner's js tool
	 * 将美术资源的png转换为2块jpg格式(原rgb, alpha, 缩小整体文件大小, 加载2张图片后再使用copyChannel方法合并为透明图片)
	 * @param rgbBd    rgb通道
	 * @param alphaBd  透明通道
	 * @return BitmapData 返回一个合并了透明通道的rgb位图数据对象
	 */ 
	public static function combinePng(rgbBd:BitmapData, alphaBd:BitmapData):BitmapData{
		var rgbCom:BitmapData = rgbBd.clone();
		var alp:BitmapData = alphaBd.clone();
		rgbCom.copyChannel(alp, rgbCom.rect, new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		rgbCom.copyChannel(alp, rgbCom.rect, new Point(0, 0), BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
		rgbCom.copyChannel(alp, rgbCom.rect, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
		return rgbCom;
	}
	
	/**
	 * 获取指定位图对象的透明通道
	 * @param data        指定位图数据
	 * @return BitmapData 返回一个包含透明通道的位图数据结构
	 */ 
	public static function getAlphaChannel(data:BitmapData):BitmapData{
		var alp:BitmapData = new BitmapData(data.width, data.height, true, 0);
		alp.fillRect(alp.rect, 0xFF000000);
		alp.copyChannel(data, alp.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
		alp.copyChannel(data, alp.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
		alp.copyChannel(data, alp.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
		return alp;
	}
	
	/**
	 * 返回指定位图的指定通道位图对象
	 * @param raw     原始位图数据
	 * @param channel 所希望得到的通道数据
	 * @see BitmapDataChannel
	 * @see BitmapData's copyChannel method
	 * @return BitmapData 返回一个新的位图数据结构
	 */ 
	public static function copyBitmapChannel(raw:BitmapData, channel:uint):BitmapData{
		var d:BitmapData = new BitmapData(raw.width, raw.height, true, 0xFF000000);
		d.copyChannel(raw, d.rect, new Point(0, 0), channel, channel);
		return d;
	}
	
	/**
	 * 检查指定显示对象在指定舞台坐标点下是否为透明像素
	 * @param dis
	 * @param point
	 * @return 
	 */
	public static function checkUnderPointTransParent(dis:DisplayObject, point:Point):Boolean{
		if(!dis.parent){
			return false;
		}
		var bitmapData:BitmapData = getBitmapData(dis);//get the copy(the reg point is on the leftTop)
		var offset:Point = DisplayObjectUtil.getLeftTopPosition(dis);
		offset.x = -offset.x + dis.x; //get the display object's top left position(0, 0)
		offset.y = -offset.y + dis.y; 
		var p:Point = dis.parent.localToGlobal(offset); //get the global position value
		var isTransParent:Boolean = bitmapData.hitTest(new Point(0, 0), 0xFF, new Point(point.x - p.x, point.y - p.y));
		bitmapData.dispose();
		return isTransParent;
	}
	
	/**
	 * 将以下三种类型变量常量提出, 是为了避免每帧创建所带来的内存浪费
	 */ 
	private static const checkTransParent:BitmapData = new BitmapData(1, 1, true, 0);
	private static const checkMatrix:Matrix = new Matrix();
	private static var checkPoint:Point = new Point();
	
	/**
	 * 检查指定显示对象在指点鼠标点下是否为透明
	 * @param dis   指定显示对象
	 * @param point 指定鼠标点Point对象, 为舞台全局坐标         
	 */ 
	public static function checkPointIsTransParent(dis:DisplayObject, point:Point):Boolean{
		if(!dis){
			return true;
		}
		checkTransParent.fillRect(checkTransParent.rect, 0);
		checkPoint.x = point.x;
		checkPoint.y = point.y;
		checkPoint = dis.globalToLocal(checkPoint);
		checkMatrix.tx = -checkPoint.x|0;
		checkMatrix.ty = -checkPoint.y|0;
		checkTransParent.draw(dis, checkMatrix);
		return ((checkTransParent.getPixel32(0, 0) >>> 24) & 0xFF) < 0x80;
	}
	
	/**
	 * @see getDisObjectUnderPoint
	 */ 
	public static function getDisObjectUnderXY(container:DisplayObjectContainer, px:Number, py:Number):DisplayObject{
		return getDisObjectUnderPoint(container, new Point(px, py));
	}
	
	/**
	 * 
	 * 获取指定容器在给定坐标下的显示对象数组集合
	 * 
	 * @param container  指定显示容器
	 * @param px         指定x轴坐标 
	 * @param py         指定y轴坐标
	 */ 
	public static function getUnderXYObjects(container:DisplayObjectContainer, px:Number, py:Number):Array{
		var disAry:Array = container.getObjectsUnderPoint(new Point(px, py));
		disAry.forEach(function(dis:DisplayObject, ...args):void{
			if(!(dis is DisplayObjectContainer)){
				var c:DisplayObject = dis.parent as DisplayObject; //maybe a simpleButton
				if(c){
					(args[1] as Array)[int(args[0])] = c;
				}
			}
		});
		return disAry;
	}
	
	/**
	 * 检查是否有指定的显示对象包含在当前鼠标坐标下
	 * 
	 * @param container    指定显示容器
	 * @param px           指定显示容器的x轴坐标
	 * @param py           指定显示容器的y轴坐标
	 * @param customCheck  检测方法, 需要自己根据实际需求提供
	 */ 
	public static function hasSpecfiedObj(container:DisplayObjectContainer, px:Number, py:Number, customCheck:Function):Boolean{
		var c:Array = getUnderXYObjects(container, px, py);
		return c.some(function(dis:DisplayObject, ...args):Boolean{
			return customCheck(dis);
		});
	}
	
	/**
	 * 
	 * @inspired from the monsterDebugger opensource framework
	 * 
	 * should be note that this will return only a displayobject 
	 * 
	 * （the simplebutton's internal resource, 
	 * 
	 * e.g (shape.parent is SimpleButton, this parent is not a DisplayObjectContainer)）
	 * 
	 * @param container             一般建议传送舞台实例(非舞台实例貌似造成一些无法预估的问题, 而且已经排除是坐标转换造成的) 
	 * @param p                     检测点 最好是舞台全局坐标(如不是方法内部会进行转换)
	 * @param isMindMouseChildren   是否考虑检测容器mouseChildren属性
	 * @param isMindTransParent     是否检测指定点下的透明度(不考虑显示层级)
	 * 
	 * 
	 * 关于获取特殊显示对象如SimpleButton, 很奇怪, Flash IDE 一切正常, 但是在FB中, simpleButton
	 * 中的shape.parent 为null.., 因此无法继续获取了改按钮了, 不确定是否是sdk版本的关系。
	 * 
	 * @issue 
	 * 
	 * in adobe document
	 *   Starting with Player version 11.2 / AIR version 3.2, the parent property of the 
	 * states of a SimpleButton object will report null if queried.
	 * 
	 *   getObjectsUnderPoint 这个方法貌似在11.2以后不但是SimpleButton, 
	 * 即便是一个buttonMode为true的模拟按钮行为的MovieClip也取不到,看来全局
	 * 使用getObjectsUnderPoint取SimpleButton在11.2之后是不行了
	 * 
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
			while(found && checkPointIsTransParent(found, c)){
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
		if(dis is Loader){
			return (dis as Loader).contentLoaderInfo.childAllowsParent;
		}
		return true;
	}
}
}