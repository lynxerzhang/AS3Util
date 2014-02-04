package common.utils
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventPhase;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.text.TextField;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class DisplayObjectUtil 
{	
	/**
	 * 清除指定容器中的所有显示对象
	 * @param d           指定显示对象     
	 * @param isRecursive 是否对其中的显示对象容器递归调用
	 */
	public static function removeAll(d:DisplayObjectContainer, isRecursive:Boolean = false):void {
		if(!d){
			return;
		}
		if(d is MovieClip){
			disposeMovieClip(MovieClip(d));
		}
		else if(d is Loader){
			disposeLoader(Loader(d));
			return;
		}
		var s:DisplayObject;
		var len:int = d.numChildren;
		while (--len > -1) {
			s = d.removeChildAt(len);
			if(s is SimpleButton){
				disposeSimpleButton(SimpleButton(s));
			}
			else if(s is Bitmap){
				disposeBitmap(Bitmap(s));
			}
			else if(s is Shape){
				disposeShape(Shape(s));
			}
			else if(s is DisplayObjectContainer){
				if(isRecursive){
					DisplayObjectUtil.removeAll(s as DisplayObjectContainer, isRecursive);
				}
			}
		}
	}
	
	private static function disposeMovieClip(mc:MovieClip):void{
		mc.stop();
		for(var item:* in mc){
			delete mc[item];//考虑可能存在动态赋值的属性或方法
		}
	}
	
	private static function disposeShape(s:Shape):void{
		s.graphics.clear();
	}
	
	private static function disposeBitmap(b:Bitmap):void{
		try{
			b.bitmapData.dispose();
			b.bitmapData = null;
		}
		catch(e:Error){
		}
	}
	
	private static function disposeSimpleButton(btn:SimpleButton):void{
		btn.upState = null;
		btn.downState = null;
		btn.overState = null;
		btn.hitTestState = null;
	}
	
	private static function disposeLoader(loader:Loader):void{
		try{
			loader.close();
		}
		catch(e:Error){
		}
		loader.unloadAndStop();
	}
	
	/**
	 * 设置子对象的可见性 
	 * @param d
	 * @param visible
	 */
	public static function setChildrenVisible(d:DisplayObjectContainer, visible:Boolean):void{
		var len:int = d.numChildren;
		while(--len > -1){
			d.getChildAt(len).visible = visible;
		}
	}

	/**
	 * 移除指定容器中的子对象
	 * @param container
	 */
	public static function removeChildren(container:DisplayObjectContainer):void {
		if (container["removeChildren"] != null) {
			container["removeChildren"]();
		}
		else {
			var len:int = container.numChildren;
			while(--len > -1){
				container.removeChildAt(len);
			}
		}
	}
	
	/**
	 * 获取指定显示对象的全局坐标
	 * @param d
	 * @return 
	 */
	public static function getStagePosition(d:DisplayObject):Point {
		if (d && d.parent) {
			return d.parent.localToGlobal(new Point(d.x, d.y));
		}
		return null;
	}
	
	/**
	 * 获取指定显示对象的注册点偏移量
	 * @param d
	 * @param scaleX
	 * @param scaleY
	 * @return 
	 */
	public static function getLeftTopPosition(d:DisplayObject, scaleX:Number = NaN, scaleY:Number = NaN):Point {
		if(!isNaN(scaleX)){
			d.scaleX = scaleX;
		}
		if(!isNaN(scaleY)){
			d.scaleY = scaleY;
		}
		var rect:Rectangle = d.getBounds(d);
		var m:Matrix = d.transform.matrix;
		var sX:Number = m.a;
		var sY:Number = m.d;
		var rx:Number, ry:Number;
		rx = sX >0 ? m.a * rect.left : m.a * rect.right;
		ry = sY >0 ? m.d * rect.top : m.d * rect.bottom;
		return new Point(-rx|0, -ry|0);
	}
	
	/**
	 * 检查指定显示对象是否在舞台上, 可以使用Stage属性是否为空为判断条件, 还有个方法是检测显示对象的loaderInfo属性是否为空
	 * 但是当一个loader加载了一个显示对象后, 就不要去检测被加载对象它的LoaderInfo属性, 
	 * 即使该loader对象不在舞台, 它的loaderInfo属性也不为空
	 * @param dis
	 * @return
	 */
	public static function isOnStage(dis:DisplayObject):Boolean {
		if(dis && dis.stage && dis.visible){
			var main:Rectangle = new Rectangle(0, 0, dis.stage.stageWidth, dis.stage.stageHeight);
			var p:Point = dis.parent.localToGlobal(new Point(dis.x, dis.y));
			var isOnStage:Boolean = main.containsPoint(p);
			if (!isOnStage) {
				var bounds:Rectangle = dis.getBounds(dis.parent);
				isOnStage = main.intersects(bounds);
			}
			return isOnStage;
		}
		return false;
	}
	
	/**
	 * 检查指定显示对象是否为指定容器的子级
	 * @param target
	 * @param checkWhetherParent
	 * @return 
	 */
	public static function checkIsParent(target:DisplayObject, checkWhetherParent:DisplayObject):Boolean{
		if(target && checkWhetherParent){
			if(checkWhetherParent is DisplayObjectContainer){
				if(DisplayObjectContainer(checkWhetherParent).contains(target)){
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * 检查指定显示对象是否拥有指定的类型, 该方法的编写主要是考虑某一个容器的事件监听为冒泡阶段的问题
	 * @param target
	 * @param parentType
	 * @return 
	 */
	public static function checkHasType(target:DisplayObject, parentType:Class):Boolean{
		if(target && parentType){
			var p:DisplayObject = target.parent;
			while(p){
				if(p is parentType){
					return true;
				}
				p = p.parent;
			}
		}
		return false;
	}
	
	/**
	 * 检查2个位图对象是否相同, 相同长宽, 相同的像素值
	 * @param bitmapA
	 * @param bitmapB
	 * @return 
	 */
	public static function checkBitmapDataIsEqual(bitmapA:BitmapData, bitmapB:BitmapData):Boolean{
		var data:Object = bitmapA.compare(bitmapB);
		if(data is Number){
			return Boolean(Number(data) == 0);
		}
		if(data as BitmapData){
			BitmapData(data).dispose();
		}
		return false;
	}

	/**
	 * 将指定显示对象的坐标居中于整个舞台
	 * @param disObj
	 * @param checkOnStage  对是否在舞台上的判断
	 */
	public static function centerInStage(disObj:DisplayObject, checkOnStage:Boolean = false):void{
		if(disObj){
			if(!disObj.stage && checkOnStage){
				disObj.addEventListener(Event.ADDED_TO_STAGE, function(evt:Event):void{
					disObj.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
					center();
				});
			}
			if(disObj.stage){
				center();
			}
			function center():void{
				var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(disObj);
				var c:Point = new Point();
				c.x = (disObj.stage.stageWidth - disObj.width) * .5 + topLeft.x;
				c.y = (disObj.stage.stageHeight - disObj.height) * .5 + topLeft.y;
				c = disObj.parent.globalToLocal(c);
				disObj.x = c.x;
				disObj.y = c.y;
			}
		}
	}
	
	/**
	 * 获取指定显示对象居中的Point对象, 该Point对象已执行坐标转换
	 * @param disObj
	 * @return 
	 */
	public static function getCenterStagePoint(disObj:DisplayObject):Point{
		if(!(disObj && disObj.stage)){
			return null;
		}
		var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(disObj);
		var c:Point = new Point();
		c.x = (disObj.stage.stageWidth - disObj.width) * .5 + topLeft.x;
		c.y = (disObj.stage.stageHeight - disObj.height) * .5 + topLeft.y;
		c = disObj.parent.globalToLocal(c);
		return c;
	}
	
	/**
	 * 将指定显示对象在其父级中居中显示, 需要注意的是如果子级的长宽大于父级, 那么父级的长宽其实就是子级的了
	 * @param disObj
	 * @param checkHasParent
	 */
	public static function centerParent(disObj:DisplayObject, checkHasParent:Boolean = false):void{
		if(disObj){
			if(!disObj.parent && checkHasParent){
				disObj.addEventListener(Event.ADDED, function(evt:Event):void{
					if(evt.eventPhase == EventPhase.AT_TARGET){
						//this maybe check whether at target phase or at bubble phase, 
						//the bubble phase mean disObj added some child
						//the target phase mean disObj been added to some parent
						disObj.removeEventListener(Event.ADDED, arguments.callee);
						center();
					}
				});
			}
			if(disObj.parent){
				center();
			}
			function center():void{
				var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(disObj);
				
				var c:Point = new Point();
				c.x = (disObj.parent.width - disObj.width) * .5 + topLeft.x;
				c.y = (disObj.parent.height - disObj.height) * .5 + topLeft.y;
				
				topLeft = DisplayObjectUtil.getLeftTopPosition(disObj.parent);
				c.x -= topLeft.x;
				c.y -= topLeft.y;
				disObj.x = c.x;
				disObj.y = c.y;
			}
		}
	}
	
	/**
	 * 将指定的显示对象居中至指定的另一个显示对象
	 * @param disObj
	 * @param refer
	 * @param posX
	 * @param posY
	 */
	public static function centerSpecfiedParent(disObj:DisplayObject, refer:DisplayObject, posX:Number = NaN, posY:Number = NaN):void{
		if(disObj && refer){			
			var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(refer);
			var t:Point = refer.parent.localToGlobal(new Point(isNaN(posX) ? refer.x : posX, isNaN(posY) ? refer.y : posY));
			t.x -= topLeft.x;
			t.y -= topLeft.y;
			topLeft = DisplayObjectUtil.getLeftTopPosition(disObj);
			t.x += (refer.width - disObj.width) * .5 + topLeft.x;
			t.y += (refer.height - disObj.height) * .5 + topLeft.y;
			t = disObj.parent.globalToLocal(t);
			disObj.x = t.x;
			disObj.y = t.y;
		}
	}
	
	/**
	 * 获取指定显示对象正好位于消失于舞台左侧的坐标点
	 * @param disObj
	 * @param checkOnStage
	 * @return 
	 */
	public static function getStageLeftHidePoint(disObj:DisplayObject, checkOnStage:Boolean = false):Point{
		if(!(disObj && disObj.stage)){
			return null;
		}
		//other case, you could test this case and to test with current use case's performance diff
		//var r:Rectangle = disObj.transform.pixelBounds;
		//var t:Point = disObj.parent.globalToLocal(new Point(0, 0));
		var m:Matrix = disObj.transform.concatenatedMatrix;
		m.invert();
		m.concat(disObj.transform.matrix);
		m.tx -= disObj.width;
		//this is minus topleft's registerPoint's position's offset
		var leftTop:Point = DisplayObjectUtil.getLeftTopPosition(disObj);
		m.tx -= leftTop.x;
		return new Point(m.tx, m.ty);
	}
	
	/**
	 * @param disObj
	 * @param checkOnStage
	 * @see getStageLeftHidePoint
	 * @return 
	 */
	public static function getStageRightHidePoint(disObj:DisplayObject, checkOnStage:Boolean = false):Point{
		if(!(disObj && disObj.stage)){
			return null;
		}
		var m:Matrix = disObj.transform.concatenatedMatrix;
		m.invert();
		m.concat(disObj.transform.matrix);
		m.tx += disObj.stage.stageWidth;
		//this is add topleft's registerPoint's position's offset
		var leftTop:Point = DisplayObjectUtil.getLeftTopPosition(disObj);
		m.tx += leftTop.x;
		return new Point(m.tx, m.ty);
	}
	
	/**
	 * 对指定影片剪辑及其子集影片剪辑调用指定方法
	 * @param mc
	 * @param rawMethodName
	 * @param args
	 * 
	 */
	public static function runMethodInMovie(mc:MovieClip, rawMethodName:String, ...args):void{
		if(!mc || !mc.hasOwnProperty(rawMethodName)){
			return;
		}
		var len:int = mc.numChildren;
		while(--len > -1){
			var d:MovieClip = mc.getChildAt(len) as MovieClip;
			if(d){
				d[rawMethodName].apply(d, args[0] is Array ? args[0] : args);
				runMethodInMovie(d, rawMethodName, args);
			}
		}
	}
	
	/**
	 * 获取真实的制定显示对象的长宽（不受是否在舞台, 或者ScrollRect属性的影响，或者scaleX, scaleY的设置）
	 * 
	 * 直接获取dis.transform.pixelBounds 获取的是经过设置过scaleX, scaleY的长宽, 
	 * 如不在舞台需要除以5以获取实际值(原因不明), getBounds目前测试是不受任何影响, 
	 * 包括了不在舞台的情况, 获得的均是原始值
	 * 
	 * @param dis        指定显示对象
	 * @return Rectangle 返回实际长宽的矩形对象
	 */ 
	public static function getActualSize(dis:DisplayObject):Rectangle{		
//		var rect:Rectangle = dis.transform.pixelBounds.clone();
//		if(!dis.stage){
//			//maybe a bug issue?? this version could work, 
//			//but why divide by five? maybe the "twips"???
//			rect.width /= 5;
//			rect.height /= 5; //
//		}
//		return rect;
		//TODO, 特例, pixelBounds无法返回文本的长宽, 只能返回对应坐标
		if(dis is TextField){
			return dis.getBounds(dis);
		}
		//如果dis的父级为Loader对象
		if(dis.parent is Loader){
			return new Rectangle(0, 0, dis.width, dis.height);
		}
		//solution two
		//inspiration from joe@usecake.com and senocular.com
		var currentTransform:Transform = dis.transform;
		var currentMatrix:Matrix = currentTransform.matrix;
		var globalMatrix:Matrix = currentTransform.concatenatedMatrix;
		globalMatrix.invert();
		globalMatrix.concat(currentMatrix);
		currentTransform.matrix = globalMatrix;
		var rect:Rectangle = currentTransform.pixelBounds;
		currentTransform.matrix = currentMatrix; //reset the position, scale and skew value
		return rect;
	}
	
	/**
	 * 将注册点调整至左上角位置, 将指定显示对象的注册点调整为左上角(top-left)以方便定位 (只是嵌套一层Sprite)
	 * @param resource 指定显示对象
	 * @return Sprite 返回包含指定显示对象的Sprite对象
	 */ 
	public static function handleResetTopLeftPos(resource:Sprite):Sprite{
		var s:Sprite = new Sprite();
		resource.parent.addChildAt(s, resource.parent.getChildIndex(resource));
		s.addChild(resource.parent.removeChild(resource));
		var leftTop:Point = DisplayObjectUtil.getLeftTopPosition(resource);
		var originX:Number = resource.x;
		var originY:Number = resource.y;
		resource.x = leftTop.x;
		resource.y = leftTop.y;
		s.x = -leftTop.x + originX;
		s.y = -leftTop.y + originY;
		return s;
	}
	
	
	/**
	 * @param dis 指定显示对象
	 * 设置了scrollRect, 又或者移除舞台，而后添加至舞台, 会导致可视长宽无法及时获得, 
	 * 需要延迟一帧才能获得 (移除舞台到添加至舞台, 添加至舞台到移除舞台，具体表现还不一致)
	 * 似乎也可以使用draw绘制当前可视范围, 但也需要注意当前显示对象如果为loader,可能会
	 * 导致安全报错
	 * getBounds 只对设置过的scrollRect 起作用, 对内部visible为false始终保持原始的该区域的值
	 */ 
	public static function invalidateRedraw(dis:DisplayObject):void{
		var area:Rectangle = dis.scrollRect;
		dis.scrollRect = null;
		__redraw(dis);
		dis.scrollRect = area;
		__redraw(dis);
	}

	private static function __redraw(d:DisplayObject):void{
		var bd:BitmapData = new BitmapData(1, 1, true, 0);
		bd.draw(d);
		bd.dispose();
	}
	
	/**
	 * 获取在指定长宽下的显示对象可拖拽的范围
	 * @param dis          指定显示对象
	 * @param areaWidth    可拖拽长
	 * @param areaHeight   可拖拽宽
	 * @return Rectangle 返回一个矩形
	 */ 
	public static function getDragRect(dis:DisplayObject, width:Number, height:Number):Rectangle{
		var bounds:Rectangle = dis.getBounds(dis);
		return new Rectangle(-bounds.x, -bounds.y, width - dis.width, height - dis.height);
	}
	
	/**
	 * 根据给定的显示对象获取实际显示的长宽
	 * @param dis
	 * @return 
	 * @example
	 * 绘制一个shape盖在_mc上, 这个shape的覆盖区域就是_mc的不透明矩形区域
	 *  var r:Rectangle = getDisplaySize(_mc);
	 *	var s:Shape = new Shape();
	 *	addChild(s);
	 *	s.graphics.beginFill(0, .4);
	 *	s.graphics.drawRect(r.x, r.y, r.width, r.height);
	 *	s.graphics.endFill();
	 *	s.x = _mc.x;
	 *	s.y = _mc.y;
	 */
	public static function getDisplaySize(dis:DisplayObject):Rectangle{
		var b:Rectangle = dis.getBounds(dis);
		var t:Matrix = dis.transform.matrix;
		var d:BitmapData = new BitmapData(b.width * t.a, b.height * t.d, true, 0);
		d.draw(dis, new Matrix(t.a, 0, 0, t.d, -b.x * t.a, -b.y * t.d));
		var r:Rectangle = d.getColorBoundsRect(0xFF000000, 0, false);
		d.dispose();
		r.x += b.x * t.a;
		r.y += b.y * t.d;
		return r;
	}
	
	/**
	 * @param	container   一个指定容器（Sprite 或者 Movieclip)
	 * @param	scale9Grids 设定的9slice 矩形对象
	 * @example 
	 *	var r:Rectangle = new Rectangle(23, 21, 44, 47);//9slice 尺寸
         *	convertBitmaptoScale9(_mc, r);//清除原始Bitmap信息，转而在该mc的graphics中绘制
	 * 需要注意的是该方法没有返回container中的位图的bitmapData对象, 如果这个bitmapData对象调用dispose
	 * 被销毁, 那么依靠beginBitmapFill进行绘图的显示对象中的图形会被清除
	 */
	public static function convertBitmaptoScale9(container:DisplayObjectContainer, scale9Grids:Rectangle):void{
		var b:Bitmap = container.removeChildAt(0) as Bitmap; //获取到的是Bitmap而不是Shape,就是因为在库中取了链接名
		var topDown:Array = [scale9Grids.top, scale9Grids.bottom, b.height];
		var leftRight:Array = [scale9Grids.left, scale9Grids.right, b.width];
		var g:Graphics = Sprite(container).graphics;
		var bd:BitmapData = b.bitmapData.clone();
		var topDownStepper:int = 0;
		var leftRightStepper:int = 0;
		for(var i:int = 0; i < 3; i ++){
			for(var j:int = 0; j < 3; j ++){
				g.beginBitmapFill(bd, null, true, true);
				g.drawRect(leftRightStepper, topDownStepper,
					leftRight[i] - leftRightStepper, topDown[j] - topDownStepper);
				g.endFill();
				topDownStepper = topDown[j];
			}
			leftRightStepper = leftRight[i];
			topDownStepper = 0;
		}
		container.scale9Grid = scale9Grids;
		b.bitmapData.dispose();
		b.bitmapData = null;
	}
	
	/**
	 * 复制指定显示对象
	 * @param	dis
	 * @return
	 */
	public static function copyDisplayObject(dis:DisplayObject):DisplayObject {
		var disCls:Class = getDefinitionByName(getQualifiedClassName(dis)) as Class;
		var copy:DisplayObject = new disCls() as DisplayObject;
		if (copy is Shape || (copy is Sprite && Sprite(dis).numChildren == 0) 
				|| (copy is MovieClip && MovieClip(dis).numChildren == 0 && MovieClip(dis).totalFrames == 1)) {
			Graphics(copy["graphics"]).copyFrom(Graphics(dis["graphics"]));
		}
		else {
			if (copy is MovieClip) {
				//TODO:only one frame
				var frame:MovieClip = dis as MovieClip;
				frame.gotoAndStop(1);
				MovieClip(copy).graphics.drawGraphicsData(frame.graphics.readGraphicsData(true));
			}
			else {
				if (copy is SimpleButton) {
					//TODO:每一帧都需要有显示对象填充
					var btn:SimpleButton = copy as SimpleButton;
					var templateBtn:SimpleButton = dis as SimpleButton;
					btn.upState = copyDisplayObject(templateBtn.upState);
					btn.overState = copyDisplayObject(templateBtn.overState);
					btn.downState = copyDisplayObject(templateBtn.downState);
					btn.hitTestState = copyDisplayObject(templateBtn.hitTestState);
				}
				else {
					Sprite(copy).graphics.drawGraphicsData(Sprite(dis).graphics.readGraphicsData(true));
				}
			}
		}
		copy.transform = dis.transform;
		copy.blendMode = dis.blendMode;
		copy.opaqueBackground = dis.opaqueBackground;
		copy.cacheAsBitmap = dis.cacheAsBitmap;
		copy.filters = dis.filters;
		return copy;
	}
	
	/**
	 * 检查指定显示对象是否为原生显示对象
	 * @param	dis
	 * @return
	 */
	public static function isRawDisplayObject(dis:DisplayObject):Boolean {
		var disCls:Class = getDefinitionByName(getQualifiedClassName(dis)) as Class;
		return disCls == Sprite || disCls == Shape || disCls == MovieClip || disCls == SimpleButton;
	}
}
}
