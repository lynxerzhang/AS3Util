package common.display
{
import flash.display.DisplayObject;
import flash.display.Sprite;

import common.utils.DisplayObjectUtil;
import common.tool.SingletonVerify;

public class FontRiseMotion
{
	public function FontRiseMotion()
	{
		SingletonVerify.checkSingleton(this);
	}
	
	private static var instance:FontRiseMotion = new FontRiseMotion();
	
	/**
	 * 动画播放的容器
	 */
	public static var container:Sprite;
	
	/**
	 * 播放一个字体飘升动画 
	 * @param	str         显示的文字
	 * @param	referDis    参照显示对象
	 * @param	style       设置色彩大小的style对象
	 */
	public static function show(str:String, referDis:DisplayObject = null, style:RiseFieldStyle = null):void{
		instance.show(str, referDis, style);
	}

	/**
	 * @param str       需要显示的字符串
	 * @param referDis  参照物  (可以是任何的现实对象, 如果不指定(默认), 则以舞台为基准剧中对齐)
	 * @param style     设置飘升字体的样式
	 */ 
	public function show(str:String, referDis:DisplayObject = null, style:RiseFieldStyle = null):void{
		var d:RiseField = new RiseField(str, style);
		container.addChild(d.content);
		if(!referDis){
			DisplayObjectUtil.centerInStage(d.content, true);
		}
		else{
			DisplayObjectUtil.centerSpecfiedParent(d.content, referDis);
		}
		RiseFieldManager.instance.add(d);
	}
}
}