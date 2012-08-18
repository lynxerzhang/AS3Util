package utils
{
import flash.display.Bitmap;
import flash.display.BitmapData;
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
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Dictionary;

/**
 * 
 */
public class DisplayObjectUtil 
{	
	/**
	 * remove all children in give the container
	 * 
	 * @param d  			  the displayObjectContainer
	 * @param isRecursive     recursive run the fun
	 */
	public static function removeAll(d:DisplayObjectContainer, isRecursive:Boolean = false):void {
		if(!d){
			return;
		}
		var len:int = d.numChildren;
		if(d is MovieClip){
			(d as MovieClip).stop();
		}
		while (--len > -1) {
			var s:DisplayObject = d.removeChildAt(len);
			if(s is SimpleButton){
				var btn:SimpleButton = s as SimpleButton;
				btn.upState = null;
				btn.downState = null;
				btn.overState = null;
				btn.hitTestState = null;
			}
			else if(s is Bitmap){
				var bitmap:Bitmap = s as Bitmap;
				try{
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
				}
				catch(e:Error){
					
				}
			}
			else if(s is Shape){
				(s as Shape).graphics.clear();
			}
			else if(s is DisplayObjectContainer){
				if(isRecursive){
					DisplayObjectUtil.removeAll(s as DisplayObjectContainer, isRecursive);
				}
			}
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
		while(--len > -1){
			var c:DisplayObject = d.getChildAt(len);
			if(c is Bitmap){
				try{
					(c as Bitmap).bitmapData.dispose();
					(c as Bitmap).bitmapData = null;
				}
				catch(e:Error){
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
	 *
	 * @param d
	 * 
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
		/**
		 * the displayobject's scaleX scaleY maybe have problem
		 */
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
	public static function getBitmapSprite(d:DisplayObject, alignTopLeft:Boolean = false,  scaleX:Number = 1.0, scaleY:Number = 1.0):Sprite{
		var offset:Point = getLeftTopPosition(d, scaleX, scaleY);
		var b:BitmapData = getBitmapData(d, scaleX, scaleY);
		var bitmap:Bitmap = new Bitmap(b);
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
		if(d is Loader){
			if(!((d as Loader).contentLoaderInfo.childAllowsParent)){
				return null;
			}
		}
		var offset:Point = getLeftTopPosition(d, scaleX, scaleY);
		var bitmapData:BitmapData = new BitmapData(d.width, d.height, true, 0);
		var mtx:Matrix = new Matrix(scaleX, 0, 0, scaleY, offset.x, offset.y);
		bitmapData.draw(d, mtx);
		return bitmapData;
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
		if(d is Loader){
			if(!((d as Loader).contentLoaderInfo.childAllowsParent)){
				return null;
			}
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
	public static function createSpecWidthTextField(w:Number = NaN):TextField {
		var t:TextField = new TextField();
		t.autoSize = TextFieldAutoSize.LEFT;
		//be careful set this property, when w is NaN, this property maybe set false
		//(let's text is show in single line)
		t.wordWrap = true; 
		t.selectable = false;
		t.mouseEnabled = false;
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
	public static function centerInSpecfiedParent(disObj:DisplayObject, refer:DisplayObject):void{
		if(disObj && refer){			
			var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(refer);
			
			var t:Point = refer.parent.localToGlobal(new Point(refer.x, refer.y));
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
	 * create a sprite, and internal to draw every pixel with check the specfied bitmapdata
	 * 
	 * @param bitmapData         this argument should be a 'real' bitmapData(then I couldn't to check you specfied the 
	 *                  		bitmapData is whether a 'real' bitmapdata)
	 * 
	 * @param isAutoDispose      when operation is end, whether dispose this argument
	 * 
	 * @see getRealBitmapData
	 */
	public static function getRealSpriteFromBitmapData(bitmapData:BitmapData, isAutoDispose:Boolean = false):Sprite{
		var s:Sprite = new Sprite();
		var w:int = bitmapData.width;
		var h:int = bitmapData.height;
		
		//simple test use getTimer(), (width-159 heigth-140) bitmapData use 21 millseconds
		bitmapData.lock();
		for(var i:int = 0; i < w; i ++){
			for(var j:int = 0; j < h; j ++){
				var pixel:uint = bitmapData.getPixel32(i, j);
				var alpha:int = (pixel >> 24) & 0xFF;
				if(alpha != 0){
					s.graphics.beginFill(pixel & 0xFFFFFF, alpha / 0xFF);
					s.graphics.drawRect(i, j, 1, 1);
					s.graphics.endFill();
				}
			}
		}
		bitmapData.unlock();
		if(isAutoDispose){
			bitmapData.dispose();
		}
		return s;
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
	 * in adobe document
	 *   Starting with Player version 11.2 / AIR version 3.2, the parent property of the 
	 * states of a SimpleButton object will report null if queried.
	 * 
	 *   getObjectsUnderPoint 这个方法貌似在11.2以后不但是SimpleButton, 
	 * 即便是一个buttonMode为true的模拟按钮行为的MovieClip也取不到,看来全局
	 * 取SimpleButton在11.2之后是不行了
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
		if(dis is Loader){
			if(!((dis as Loader).contentLoaderInfo.childAllowsParent)){
				return null;
			}
		}
		if(!range || ((range.width >= dis.width) && (range.height >= dis.height))){
			return DisplayObjectUtil.getBitmapData(dis);
		}
		var rect:Rectangle = dis.transform.pixelBounds;
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
	 * get the specfied displayobject's range (return a rectangle)
	 * 
	 * @dis		the dis is which want to get it's range    
	 * @refer   the refer is which the dis's coordinate reference
	 */ 
	public static function getRange(dis:DisplayObject, refer:DisplayObject):Rectangle{
		var rect:Rectangle = dis.transform.pixelBounds;//return in global coordinate
		if(dis != refer){
			var p:Point = new Point(rect.x, rect.y);
			p = refer.globalToLocal(p);
			rect.x = p.x;
			rect.y = p.y;
		}
		return rect;
	}
	
	/**
	 * 
	 * @param dis     the dis to check    the dis for check is whether hitTest itself  
	 * @param point   the specfied point  the stage point
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
	
}
}