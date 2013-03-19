package common.utils
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class DisplayUtil{

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
}
}