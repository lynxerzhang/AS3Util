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
	
	/**
	 * 创建一个和指定显示对象相同大小和注册点位置的Sprite对象
	 * @param d
	 * @return 
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
	 * 绘制扇形
	 * @param	percent    range(0 - 1) 对应0 - 360度的弧度表示
	 * @param	radius     半径
	 * @param	color      填充色
	 * @param	clockWise  是否顺时针绘制
	 * @return  返回sprite对象
	 * @see 	原始版本 http://www.senocular.com/flash/source/ 
	 */
	public static function createSector(percent:Number, radius:Number, color:uint, clockWise:Boolean = true):Sprite {
		var r:Sprite = new Sprite();
		var g:Graphics = r.graphics;
		var s:Number = -Math.PI * .5;
		var e:Number = percent * (Math.PI * 2) + s;
		var diff:Number = Math.abs(e - s);
		var drawCount:Number = ((diff / (Math.PI * .25)) >> 0) + 1;
		g.beginFill(color, 1);
		g.moveTo(0, 0);
		g.lineTo(Math.cos(s) * radius, Math.sin(s) * radius);
		var a:Number = diff / (drawCount * 2);
		if (!clockWise) {
			a = -a;
		}
		var controlRadius:Number = radius / Math.cos(a);
		var sa:Number = s, ea:Number = sa;
		for (var i:int = 0; i < drawCount; i ++) {
			sa = ea + a;
			ea = sa + a;
			g.curveTo(Math.cos(sa) * controlRadius, 
					  Math.sin(sa) * controlRadius, 
					  Math.cos(ea) * radius, 
					  Math.sin(ea) * radius);
		}
		g.lineTo(0, 0);
		g.endFill();
		return r;
	}
	
}
}