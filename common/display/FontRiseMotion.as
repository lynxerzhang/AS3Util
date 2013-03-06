package common.display
{

import flash.display.DisplayObject;
import flash.display.Sprite;

import common.utils.DisplayObjectUtil;
import common.tool.SingletonVerify;

/**
 * 
 */ 
public class FontRiseMotion
{
	public function FontRiseMotion()
	{
		if(instance){
			SingletonVerify.singletonErrorHandle(this);
		}
	}
	
	private static var instance:FontRiseMotion = new FontRiseMotion();
	
	/**
	 * 
	 */ 
	public static var container:Sprite; // you should set the container (in stage)
	
	/**
	 * 
	 */ 
	public static function show(str:String, referDis:DisplayObject = null, style:RiseFieldStyle = null):void{
		instance.show(str, referDis, style);
	}

	/**
	 * current version use the init style
	 * @see Motion
	 * 
	 * @param str       需要显示的字符串
	 * @param referDis  参照物  (可以是任何的现实对象, 如果不指定(默认), 则以舞台为基准剧中对齐)
	 */ 
	public function show(str:String, referDis:DisplayObject = null, style:RiseFieldStyle = null):void{
		var d:RiseField = new RiseField(str, style);
		container.addChild(d.content);
		
		if(!referDis){
			DisplayObjectUtil.centerInStage(d.content, true);
		}
		else{
			DisplayObjectUtil.centerInSpecfiedParent(d.content, referDis);
		}
		
		RiseFieldManager.instance.add(d);
	}
}
}




