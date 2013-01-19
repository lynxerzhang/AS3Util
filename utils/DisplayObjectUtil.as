package utils
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventPhase;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;


public class DisplayObjectUtil 
{	
	/**
	 * remove all children in give the container
	 * 
	 * @param d  				 the displayObjectContainer
	 * @param isRecursive     recursive run the fun
	 */
	public static function removeAll(d:DisplayObjectContainer, isRecursive:Boolean = false):void {
		if(!d){
			return;
		}
		if(d is MovieClip){
			__disposeMovieClip(MovieClip(d));
		}
		else if(d is Loader){
			__disposeLoader(Loader(d));
			return;
		}
		var s:DisplayObject;
		var len:int = d.numChildren;
		while (--len > -1) {
			s = d.removeChildAt(len);
			if(s is SimpleButton){
				__disposeSimpleButton(SimpleButton(s));
			}
			else if(s is Bitmap){
				__disposeBitmap(Bitmap(s));
			}
			else if(s is Shape){
				__disposeShape(Shape(s));
			}
			else if(s is DisplayObjectContainer){
				if(isRecursive){
					DisplayObjectUtil.removeAll(s as DisplayObjectContainer, isRecursive);
				}
			}
		}
	}
	
	private static function __disposeMovieClip(mc:MovieClip):void{
		mc.stop();
		//maybe have some dynamic method in specfied mc instance
		for(var item:* in mc){
			mc[item] = undefined;
			delete mc[item];
		}
	}
	
	private static function __disposeShape(s:Shape):void{
		s.graphics.clear();
	}
	
	private static function __disposeBitmap(b:Bitmap):void{
		try{
			b.bitmapData.dispose();
			b.bitmapData = null;
		}
		catch(e:Error){
			//slience
		}
	}
	
	private static function __disposeSimpleButton(btn:SimpleButton):void{
		btn.upState = null;
		btn.downState = null;
		btn.overState = null;
		btn.hitTestState = null;
	}
	
	private static function __disposeLoader(loader:Loader):void{
		try{
			loader.close();
		}
		catch(e:Error){
			//slience
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
	 * just remove, no dispose or kill
	 */ 
	public static function removeChildren(container:DisplayObjectContainer):void{
		var len:int = container.numChildren;
		while(--len > -1){
			container.removeChildAt(len);
		}
	}
	
	/**
	 * remove and dispose the displayobject container's bitmap children
	 * 
	 * @param d  the displayObject container 
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
	 * add displayobject to top displaylist
	 * 
	 * @param d
	 */
	public static function addToTop(d:DisplayObject):void {
		if (d && d.parent) {
			d.parent.addChild(d);
		}
	}
	
	/**
	 * add displayobject to bottom displaylist
	 * 
	 * @param d
	 */
	public static function addToBottom(d:DisplayObject):void {
		if (d && d.parent) {
			d.parent.addChildAt(d, 0);
		}
	}
	
	/**
	 * get displayobject's position
	 * 
	 * @param d
	 * 
	 * @return point
	 */
	public static function getStagePosition(d:DisplayObject):Point {
		if (d && d.parent) {
			return d.parent.localToGlobal(new Point(d.x, d.y));
		}
		return null;
	}
	
	/**
	 * get the displayobject's topleft position
	 * the displayobject's scaleX scaleY maybe have problem
	 * @param d
	 * @return point
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
		var scaleX:Number = m.a;
		var scaleY:Number = m.d;
		var rx:Number, ry:Number;
		rx = scaleX >0 ? m.a * rect.left : m.a * rect.right;
		ry = scaleY >0 ? m.d * rect.top : m.d * rect.bottom;
		return new Point(-rx|0, -ry|0);
	}
	
	/**
	 * get bitmap with specfied dis's offset
	 * 
	 * @param d     the displayobject
	 * @return      the sprite wrap the bitmapdata
	 */ 
	public static function getBitmapSprite(d:DisplayObject, alignTopLeft:Boolean = false,  scaleX:Number = 1.0, scaleY:Number = 1.0, isSmooth:Boolean = false):Sprite{
		var offset:Point = getLeftTopPosition(d, scaleX, scaleY);
		var b:BitmapData = getBitmapData(d, scaleX, scaleY);
		var bitmap:Bitmap = new Bitmap(b);
		if(isSmooth){
			bitmap.smoothing = isSmooth;
		}
		var s:Sprite = new Sprite();
		s.addChild(bitmap);
		if(!alignTopLeft){
			bitmap.x = -offset.x;
			bitmap.y = -offset.y;
		}
		return s;
	}
	
	/**
	 * get a bitmap with dis
	 *
	 * @param dis   the displayobject
	 * @return      the bitmap
	 */ 
	public static function getBitmap(dis:DisplayObject):Bitmap{	
		var bitmapData:BitmapData = getBitmapData(dis);
		return new Bitmap(bitmapData);
	}
	
	/**
	 * get a specified displayobject's bitmapdata
	 * 
	 * @param d the displayobject you want to become a bitmapdata
	 * 
	 * @return the bitmapData
	 */ 
	public static function getBitmapData(d:DisplayObject, scaleX:Number = 1.0, scaleY:Number = 1.0):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!__checkDraw(d)){
			return null;
		}
		var offset:Point = getLeftTopPosition(d, scaleX, scaleY);
		var bitmapData:BitmapData = new BitmapData(d.width, d.height, true, 0);
		var mtx:Matrix = new Matrix(scaleX, 0, 0, scaleY, offset.x, offset.y);
		bitmapData.draw(d, mtx);
		return bitmapData;
	}
	
	/**
	 * TODO
	 * @see getBitmapData (这里将ColorTransform, filters 计算在内)
	 */ 
	public static function getCopy(dis:DisplayObject, sx:Number = 1.0, sy:Number = 1.0):BitmapData{
		if(dis.width <= 0 || dis.height <= 0){
			return null;
		}
		if(!__checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = getLeftTopPosition(dis, sx, sy);
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
	 * TODO
	 * @see getSprite (这里将ColorTransform, filters 计算在内)
	 */ 
	public static function getCopySprite(dis:DisplayObject, sx:Number = 1.0, sy:Number = 1.0):Sprite{
		if(dis.width <= 0 || dis.height <= 0){
			return null;
		}
		if(!__checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = getLeftTopPosition(dis, sx, sy);
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
	 * get real bitmapdata (remove transparent area - (in as3 is rectangle))
	 * 
	 * @param d   the displayobject
	 * @return    the bitmapdata
	 */ 
	public static function getOpaqueDisObj(d:DisplayObject):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!__checkDraw(d)){
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
	 * get real bitmapData with specfied bitmapData
	 * 
	 * @param bitmapData  the bitmapData
	 * @return            the bitmapData
	 */ 
	public static function getOpaqueBitmapData(bitmapData:BitmapData):BitmapData{
		var unTransparentArea:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
		c.copyPixels(bitmapData, unTransparentArea.clone(), new Point(0, 0));
		bitmapData.dispose();
		return c;
	}	
	
	/**
	 * generated a colorful bitmap's background
	 *
	 * @param color bg color
	 * @param alpha bg alpha
	 * @param preW bg width
	 * @param preH bg height
	 * @return
	 */
	public static function generateSingleColorBG(color:uint, alpha:Number, preW:Number, preH:Number):Bitmap {
		var s:Shape = new Shape();
		s.graphics.beginFill(color, alpha);
		s.graphics.drawRect(0, 0, 1, 1);
		s.graphics.endFill();
		var b:BitmapData = new BitmapData(1, 1, true, 0);
		b.draw(s);
		var bitmap:Bitmap = new Bitmap(b);
		bitmap.width = preW;
		bitmap.height = preH;
		return bitmap;
	}
	
	/**
	 * @see generateSingleColorBG
	 * @return
	 * 
	 * create a no mouse 
	 */
	public static function generateNoMouseActiveColorBG(color:uint, alpha:Number, prew:Number, preH:Number):Sprite {
		var b:Bitmap = generateSingleColorBG(color, alpha, prew, preH);
		//because this sprite's mouseEnabled is active, so under this sprite's DisplayObject hasn't recieve mouse event
		var s:Sprite = new Sprite();
		s.addChild(b);
		return s;
	}
	
	/**
	 * check the dis whether on the stage
	 * could use 'stage' property to check is whether on the stage, 
	 * and other way is check this displayobject's loaderInfo property is whether 'null'
	 * but when use Loader to load a displayobject, be careful do not check loaded object's 'loaderInfo'
	 * 
	 * the loaded object do not add to stage, but this 'loaderInfo' property is not 'Null'
	 * 
	 * @param dis
	 * @return
	 */
	public static function isOnStage(dis:DisplayObject):Boolean {
		if(dis && dis.stage && dis.visible){
			var main:Rectangle = new Rectangle(0, 0, dis.stage.stageWidth, dis.stage.stageHeight);
			var p:Point = dis.parent.localToGlobal(new Point(dis.x, dis.y));
			return main.containsPoint(p);
		}
		return false;
	}
	
	
	/**
	 * create a specified width's TextField
	 * @param w
	 * @return
	 */
	public static function createSpecWidthTextField(enabled:Boolean = false, w:Number = NaN):TextField {
		var t:TextField = new TextField();
		t.autoSize = TextFieldAutoSize.LEFT;
		t.wordWrap = true; 
		t.selectable = enabled;
		t.mouseEnabled = enabled;
		if (!isNaN(w)) {
			t.width = w;
		}
		return t;
	}
	
	/**
	 * create a raw textField
	 */ 
	public static function createTextField(enabled:Boolean = false):TextField{
		var t:TextField = new TextField();
		t.autoSize = TextFieldAutoSize.LEFT;
		t.selectable = enabled;
		t.mouseEnabled = enabled;
		return t;
	}
	
	/**
	 * check target's parent is whether is checkWhetherParent
	 */ 
	public static function checkIsParent(target:DisplayObject, checkWhetherParent:DisplayObject):Boolean{
		if(target && checkWhetherParent){
			var p:DisplayObject = target.parent;
			while(p){
				if(p == checkWhetherParent){
					return true;
				}
				p = p.parent;
			}
		}
		return false;
	}
	
	/**
	 * @param target        the target
	 * @param parentType    the parent Type class
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
	 * create a mouseDisabled Sprite container
	 * 
	 * @param name the name you want add to sprite
	 * @param parent if the parent exist, the parent will add the sprite
	 */ 
	public static function createSprite(name:String = null, parent:DisplayObjectContainer = null):Sprite{
		var s:Sprite = new Sprite();
		s.mouseChildren = s.mouseEnabled = false;
		s.focusRect = false;
		if(name != null){
			s.name = name;
		}
		if(parent != null){
			parent.addChild(s);
		}
		return s;
	}
	
	/**
	 * check whether the two bitmapData is same (the same width, the same height, and the same pixel everything)
	 * please read the BitmapData's method 'compare' for more details
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
	 * remove specified color
	 * 
	 * @param d           the displayobject to convert a bitmapData
	 * @param removeColor the color you want to remove
	 * @param isReal      is remove transparent's area
	 * 
	 * TODO
	 * 
	 * in some case, you could use (bitmapData.floodFill, even 'getPixel' and 'setPixel' combine with 'lock' and 'unlock' method)
	 */ 
	public static function removeSpecfiedColor(d:DisplayObject, removeColor:uint, isReal:Boolean = false):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(d is Loader){
			if(!((d as Loader).contentLoaderInfo.childAllowsParent)){
				return null;
			}
		}
		var bmpData:BitmapData = getBitmapData(d);
		bmpData.threshold(bmpData, bmpData.rect, new Point(0, 0), "==", removeColor, 0x00000000);
		if(isReal){
			var unTransparentArea:Rectangle = bmpData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
			c.copyPixels(bmpData, unTransparentArea.clone(), new Point(0, 0));
			bmpData.dispose();
			bmpData = c;
		}
		return bmpData;
	}
	
	/**
	 * @param d 	the displayobject
	 * 
	 * get the specfied displayobject's mold
	 */ 
	public static function drawMold(d:DisplayObject):Sprite{
		var s:Sprite = new Sprite();
		var top:Point = DisplayObjectUtil.getLeftTopPosition(d);
		s.graphics.beginFill(0, 0);
		s.graphics.drawRect(-top.x, -top.y, d.width, d.height);
		s.graphics.endFill();
		return s;
	}
	
	/**
	 * center specfied disObj in stage
	 * 
	 * @see centerInParent
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
	 * get disObj centerInStage's point, this point has been covert coordinate
	 * so just use it to disobject's x, y property
	 */ 
	public static function getCenterInStagePoint(disObj:DisplayObject):Point{
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
	 * center specfied disObj in it's parent
	 * 
	 * if disObj's position exceed it's parent coordinate range, this method maybe has a issue
	 * because disObj.parent.width is not only his raw width, but also contain 
	 * it's child's coordinate range
	 */ 
	public static function centerInParent(disObj:DisplayObject, checkHasParent:Boolean = false):void{
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
	 * 
	 * center in specfied refer
	 * 
	 * @param disObj           displayobject
	 * @param refer            reference displayobject
	 * 
	 */ 
	public static function centerInSpecfiedParent(disObj:DisplayObject, refer:DisplayObject, posX:Number = NaN, posY:Number = NaN):void{
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
	 * TODO
	 * get vanishing point in stage's left part
	 */ 
	public static function getLeftStageHidePoint(disObj:DisplayObject, checkOnStage:Boolean = false):Point{
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
	 * TODO
	 * get vanishing point in stage's right part
	 */ 
	public static function getRightStageHidePoint(disObj:DisplayObject, checkOnStage:Boolean = false):Point{
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
	 * @param mc 				 the movieclip
	 * @param rawMethodName  the movieclip's method 
	 * 对指定影片剪辑及其子集影片剪辑调用指定方法
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
	
	
	/**
	 * sampling specfied disObj to bitmapData
	 * 
	 * @param dis   display object which you want to sample
	 * @param range sample's range
	 */ 
	public static function sampling(dis:DisplayObject, range:Rectangle = null):BitmapData{
		if((dis.width == 0) || (dis.height == 0)){
			return null;
		}
		if(!__checkDraw(dis)){
			return null;
		}
		if(!range || ((range.width >= dis.width) && (range.height >= dis.height))){
			return DisplayObjectUtil.getBitmapData(dis);
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
	
	private static function __checkDraw(dis:DisplayObject):Boolean{
		if(dis is Loader){
			return (dis as Loader).contentLoaderInfo.childAllowsParent;
		}
		return true;
	}

	/**
	 * @param dis     the dis to check    the dis for check is whether hitTest itself  
	 * @param point   the specfied point  the stage point
	 * @see checkPointIsTransParent
	 */ 
	public static function checkUnderPointTransParent(dis:DisplayObject, point:Point):Boolean{
		if(!dis.parent){
			return false;
		}
		var bitmapData:BitmapData = DisplayObjectUtil.getBitmapData(dis);//get the copy(the reg point is on the leftTop)
		var offset:Point = DisplayObjectUtil.getLeftTopPosition(dis);
		offset.x = -offset.x + dis.x; //get the display object's top left position(0, 0)
		offset.y = -offset.y + dis.y; 
		var p:Point = dis.parent.localToGlobal(offset); //get the global position value
		var isTransParent:Boolean = bitmapData.hitTest(new Point(0, 0), 0xFF, new Point(point.x - p.x, point.y - p.y));
		bitmapData.dispose();
		return isTransParent;
	}
	
	
	/**
	 * 将以下三种类型变量常量提出, 是为了避免每帧创建所带来的内存浪费, 如下方法
	 * 目前应用在FarmField中的ENTER_FRAME中
	 */ 
	private static const checkTransParent:BitmapData = new BitmapData(1, 1, true, 0);
	private static const checkMatrix:Matrix = new Matrix();
	private static var checkPoint:Point = new Point();
	/**
	 * @param dis
	 * @param point
	 */ 
	public static function checkPointIsTransParent(dis:DisplayObject, point:Point, alphaThreshold:uint = 0xFF):Boolean{
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
		return ((checkTransParent.getPixel32(0, 0) >> 24) & alphaThreshold) == 0;
	}
	

	/**
	 * @see adobe's documention (DisplayObjectContainer's getObjectsUnderPoint' method)
	 * 
	 * @see getDisObjectUnderPoint
	 */ 
	public static function getDisObjectUnderXY(container:DisplayObjectContainer, px:Number, py:Number):DisplayObject{
		return DisplayObjectUtil.getDisObjectUnderPoint(container, new Point(px, py));
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
		var c:Array = DisplayObjectUtil.getUnderXYObjects(container, px, py);
		return c.some(function(dis:DisplayObject, ...args):Boolean{
			return customCheck(dis);
		});
	}
	
	/**
	 * 获取真实的制定显示对象的长宽（不受是否在舞台, 或者ScrollRect属性的影响，或者scaleX, scaleY的设置）
	 * 
	 * 直接获取dis.transform.pixelBounds 获取的是经过设置过scaleX, scaleY的长宽, 
	 * 如不在舞台需要除以5以获取实际值(原因不明), getBounds目前测试是不受任何影响, 
	 * 包括了不在舞台的情况, 获得的均是原始值
	 * 
	 * @param dis 
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
	 * 
	 * @param resource 指定需要将注册点调整至左上角位置的显示对象
	 * 将指定显示对象的注册点调整为左上角(top-left)以方便定位 (只是嵌套一层Sprite)
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
	 * inspired from showbox (a air game develop tool) and grantskiner's js tool
	 * TODO
	 * 将美术资源的png转换为2块jpg格式(原rgb, alpha, 缩小整体文件大小, 加载2张图片后再使用copyChannel方法合并为透明图片)
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
	 * @param raw
	 * @param channel
	 */ 
	public static function copyBitmapChannel(raw:BitmapData, channel:uint):BitmapData{
		var d:BitmapData = new BitmapData(raw.width, raw.height, true, 0xFF000000);
		d.copyChannel(raw, d.rect, new Point(0, 0), channel, channel);
		return d;
	}
	
	/**
	 * TODO
	 * @param dis
	 * @param point
	 */ 
	public static function getStagePoint(dis:DisplayObject, point:Point):Point{
		var p:Point = dis.localToGlobal(point.clone());
		return dis.globalToLocal(p);
	}
	
	/**
	 * TODO hack method to redraw specfied displayobject immediately
	 * 
	 * 设置了scrollRect, 又或者移除舞台，而后添加至舞台, 会导致可视长宽无法及时获得, 
	 * 需要延迟一帧才能获得 (移除舞台到添加至舞台, 添加至舞台到移除舞台，具体表现还不一致)
	 * 似乎也可以使用draw绘制当前可视范围, 但也需要注意当前显示对象如果为loader,可能会
	 * 导致安全报错
	 * 
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
	 * 获取指定的显示对象和指定长宽返回可拖拽区域
	 * @param dis
	 * @param areaWidth
	 * @param areaHeight
	 * 
	 * @see 
	 */ 
	public static function getWHDragLimitRect(dis:DisplayObject, areaWidth:Number, areaHeight:Number):Rectangle{
		var bounds:Rectangle = dis.getBounds(dis);
		return new Rectangle(-bounds.x, -bounds.y, areaWidth - dis.width, areaHeight - dis.height);
	}
	
}
}