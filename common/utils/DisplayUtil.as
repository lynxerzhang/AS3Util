package common.utils
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class DisplayUtil
{

	/**
	 * 创建指定长度的文本对象
	 * @param enabled
	 * @param w
	 * @return 
	 */
	public static function createTextField(enabled:Boolean = false, w:Number = NaN):TextField{
		var t:TextField = new TextField();
		t.autoSize = TextFieldAutoSize.LEFT;
		t.wordWrap = true;
		t.selectable = enabled;
		t.mouseEnabled = enabled;
		if(!isNaN(w)){
			t.width = w;
		}
		return t;
	}
	
	/**
	 * 创建一个Sprite对象
	 * @param name
	 * @param parent
	 * @return 
	 */
	public static function createSprite(name:String = null, parent:DisplayObjectContainer = null):Sprite{
		var s:Sprite = new Sprite();
		s.mouseChildren = s.mouseEnabled = false;
		s.focusRect = false;
		s.tabEnabled = false;
		s.tabChildren = false;
		if(name != null){
			s.name = name;
		}
		if(parent != null){
			parent.addChild(s);
		}
		return s;
	}
	
	private static const HELP_POINT:Point = new Point(0, 0);
	
	/**
	 * 创建一个和指定显示对象相同大小和注册点位置的Sprite对象
	 * @param d
	 * @return 
	 */
	public static function drawMold(d:DisplayObject):Sprite{
		var s:Sprite = new Sprite();
		var top:Point = DisplayObjectUtil.getLeftTopPosition(d, HELP_POINT);
		s.graphics.beginFill(0, 0);
		s.graphics.drawRect(-top.x, -top.y, d.width, d.height);
		s.graphics.endFill();
		return s;
	}
	
	/**
	 * 绘制扇形 (仅使用整体填充)
	 * @param	p	range(0 - 1) 对应0 - 360度的弧度表示
	 * @param	r	半径
	 * @param	c	填充色
	 * @param	cw	是否顺时针绘制
	 * @param	result	根据需要传入Sprite对象
	 * @see 	原始版本 http://www.senocular.com/flash/source/
	 * @return
	 */
	public static function createArcShape(p:Number, r:Number, c:uint, cw:Boolean = true, result:Sprite = null):Sprite {
		var rs:Sprite = result;
		if (!result) {
			rs = new Sprite();
		}
		var g:Graphics = rs.graphics;
		var s:Number = -Math.PI * .5;
		var e:Number = p * (Math.PI * 2) + s;
		var diff:Number = Math.abs(e - s);
		var drawCount:Number = ((diff / (Math.PI * .25)) >> 0) + 1;
		g.clear();
		g.beginFill(c, 1);
		g.moveTo(0, 0);
		g.lineTo(Math.cos(s) * r, Math.sin(s) * r);
		var a:Number = diff / (drawCount * 2);
		if (!cw) {
			a = -a;
		}
		var cR:Number = r / Math.cos(a); //controlRadius
		var sa:Number = s, ea:Number = sa;
		for (var i:int = 0; i < drawCount; i ++) {
			sa = ea + a;
			ea = sa + a;
			g.curveTo(Math.cos(sa) * cR, Math.sin(sa) * cR, Math.cos(ea) * r, Math.sin(ea) * r);
		}
		g.lineTo(0, 0);
		g.endFill();
		return rs;
	}
	
	/**
	 * 绘制弧形 (仅使用线条填充)
	 * @param	g		graphics对象
	 * @param	x		初始x坐标
	 * @param	y		初始y坐标
	 * @param	r		绘制半径
	 * @param	size	线条尺寸
	 * @param	c		色彩
	 * @param	af		起始角度
	 * @param	at		结束角度
	 */
	public static function drawArc(g:Graphics, x:Number, y:Number, r:Number, size:Number, c:uint, af:Number, at:Number):void{
		g.clear();
		g.lineStyle(size, c);

		var R:Number = Math.PI / 180;
		af = af * R;
		at = at * R + af;

		var diff:Number = Math.abs(at - af);
		var drawCount:Number = ((diff / (Math.PI * .25)) >> 0) + 1;
		g.moveTo(Math.cos(af) * r + x, Math.sin(af) * r + y);

		var a:Number = diff / (drawCount * 2);
		var cR:Number = r / Math.cos(a); //controlRadius
		var sa:Number = af, ea:Number = sa;

		for (var i:int = 0; i < drawCount; i ++) {
			sa = ea + a;
			ea = sa + a;
			g.curveTo(x + Math.cos(sa) * cR, y + Math.sin(sa) * cR, x + Math.cos(ea) * r, y + Math.sin(ea) * r);
		}
	}

	/**
	 * 绘制多边形 (仅使用整体填充)
	 * @param	g	graphics对象
	 * @param	x	初始x坐标
	 * @param	y	初始y坐标
	 * @param	r	半径
	 * @param	s	边长
	 * @param	c	填充颜色值
	 */
	public static function drawPolygon(g:Graphics, x:Number, y:Number, r:Number, s:Number, c:uint):void {
		g.clear();
		g.beginFill(c, 1);
		g.moveTo(x, y);
		if (s < 3) {
			s = 3;
		}
		var drawCount:int = s;
		var offset:Number = Math.PI * 2 / s;
		var a:Number = -Math.PI * .5;
		for (var i:int = 0; i <= drawCount; i ++) {
			g.lineTo(Math.cos(a) * r + x, Math.sin(a) * r + y);
			a += offset;
		}
		g.endFill();
	}
	
	private static function rangeAngle(angle:Number):Number {
		var a:Number = angle;
		a %= 360;
		if(a > 180){
			a -= 360;
		}
		else if(a < -180){
			a += 360;
		}
		return a;
	}
}
}