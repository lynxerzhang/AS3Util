package common.utils 
{
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class SimpleButtonUtil 
{
	public function SimpleButtonUtil() 
	{
	}
	
	private static const weakMap:Dictionary = new Dictionary(true);
	
	/**
	 * 点击按钮导致父级面板移除出舞台, 再次加入舞台后, 按钮的状态可能会无法恢复至默认的up状态
	 * 这里暂时用人为修改按钮状态来保证状态的显示正常。 
	 * 其余方法可以重新new一个SimpleButton, 或者不移除父级面板, 而是单纯设置面板visible
	 * 由于该按钮内部会监听舞台事件, 可能造成回收问题, 故将该按钮添加至
	 * 键弱引用Dictionary保存
	 * @param	btn
	 */
	public static function retainState(btn:SimpleButton):void {
		weakMap[btn] = true;
		var overState:DisplayObject = btn.overState;
		btn.addEventListener(Event.REMOVED_FROM_STAGE, function(evt:Event):void {
			btn.overState = btn.upState;
		});
		btn.addEventListener(Event.ADDED_TO_STAGE, function(evt:Event):void {
			btn.addEventListener(MouseEvent.MOUSE_OVER, function(evt:MouseEvent):void {
				btn.overState = overState;
			});
		});
	}
}
}

