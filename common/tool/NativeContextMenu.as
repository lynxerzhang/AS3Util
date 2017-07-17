package common.tool
{
import flash.events.ContextMenuEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.Dictionary;

/**
 * 自定义右键菜单
 */
public class NativeContextMenu
{
	private var _contextMenu:ContextMenu;
	
	private static var __instance:NativeContextMenu;
	
	//单例
	public static function get instance():NativeContextMenu 
	{
		if(__instance == null){
			__instance = new NativeContextMenu();
		}
		return __instance;
	}
	
	public function NativeContextMenu()
	{
		_contextMenu = new ContextMenu();
		_contextMenu.hideBuiltInItems();
	}
	
	/**
	 * 清除默认右键菜单
	 */
	public function hideBuiltInItems():void
	{
		_contextMenu.hideBuiltInItems();
	}
	
	/**
	 * 添加自定义菜单并绑定回调
	 */
	public function addItem(label:String, func:Function = null):void
	{
		if(funDict[label]){
			return;
		}
		var item:ContextMenuItem = new ContextMenuItem(label);
		if(func != null){
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, func);
		}
		var len:int = _contextMenu.customItems.push(item);
		funDict[label] = {"item":item, "index":len - 1, "func":func};
	}
	
	private var funDict:Dictionary = new Dictionary();
	
	/**
	 * 移除指定自定义菜单
	 */
	public function removeItem(label:String):void
	{
		var itemData:Object = funDict[label];
		if(itemData){
			var item:ContextMenuItem = itemData.item;
			if(itemData.func){
				item.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemData.func);
			}
			_contextMenu.customItems.splice(itemData.index, 1);
			funDict[label] = undefined;
			delete funDict[label];
		}
	}
	
	/**
	 * 设置菜单是否可以点击
	 */
	public function setItemEnabled(label:String, enabled:Boolean):void
	{
		if(funDict[label]){
			var itemData:Object = funDict[label];
			if(itemData){
				var item:ContextMenuItem = itemData.item;
				item.enabled = enabled;
			}
		}
	}
	
	public function get contextMenu():ContextMenu 
	{ 
		return _contextMenu; 
	}
	
	public function set contextMenu(value:ContextMenu):void 
	{
		_contextMenu = value;
	}
}
}


