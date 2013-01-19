package tool
{
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

import tool.ListenerManager;
import tool.Signal;

import utils.DisplayObjectUtil;
import utils.SingletonVerify;


public class DragManager
{
	/**移动至目标显示对象上时触发该Signal**/
	public static var hitTargetSignal:Signal = new Signal();
	
	private static const dragContainer:Sprite = DisplayObjectUtil.createSprite();
	
	private static const listenerManager:ListenerManager = new ListenerManager();
	
	public static function removeSignalNotify():void{
		if(hitTargetSignal.getLen() > 0){
			hitTargetSignal.removeAll();
		}
	}
	
	/**
	 * 
	 * @param drag              拖动的对象
	 * @param target            释放的目标显示对象
	 * @param show              需要被拖动的对象
	 * @param checkCondition    附加判断条件方法
	 * @param showProp          对拖动显示对象追加属性
	 */ 
	public static function startDrag(drag:InteractiveObject, 
							  target:InteractiveObject,
							  show:DisplayObject = null,
							  checkCondition:Function = null, 
							  showProp:Object = null):void{
		stopDrag();
		var s:DisplayObject = DisplayObjectUtil.getBitmapSprite(show == null ? drag : show) as DisplayObject;
		if(showProp != null){
			for(var item:* in showProp){
				s[item] = showProp[item];
			}
		}
		var ds:Stage = drag.stage;
		if(ds){
			if(dragContainer && dragContainer.parent != ds){
				ds.addChild(dragContainer);
			}
			dragContainer.addChild(s);
			
			s.x = ds.stage.mouseX;
			s.y = ds.stage.mouseY;
			
			listenerManager.mapListener(ds, MouseEvent.MOUSE_MOVE, function(evt:MouseEvent):void{
				s.x = evt.stageX;
				s.y = evt.stageY;
			});
			
			listenerManager.mapListener(ds, MouseEvent.MOUSE_UP, function(evt:MouseEvent):void{
				var __target:DisplayObject = evt.target as DisplayObject;
				if(__target){
					if(__target == target || DisplayObjectUtil.checkIsParent(__target, target)){
						if(checkCondition != null){
							if(checkCondition(__target)){
								hitTargetSignal.dispatch(__target);
							}
						}
						else{
							hitTargetSignal.dispatch(__target);
						}
					}
				}
				stopDrag();
			});
		}
	}
	
	/**
	 * 停止对当前拖动对象的拖拽
	 */ 
	public static function stopDrag():void{
		if(dragContainer && dragContainer.parent){
			dragContainer.parent.removeChild(dragContainer);
			DisplayObjectUtil.removeAll(dragContainer, true);
		}
		listenerManager.removeAll();
	}
}
}