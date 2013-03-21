package common.tool
{
	
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.utils.Dictionary;

/**
 * 该类仅封装了DisplayObjectContainer类的getChildByName方法
 */ 
public class GetResourceManager
{
	private var content:DisplayObjectContainer;
	
	public function GetResourceManager(main:DisplayObjectContainer)
	{
		this.content = main;
	}
	
	private static var dict:Dictionary = new Dictionary(false);
	
	/**
	 * 根据传入的现实对象容器获取对应的GetResourceManager对象
	 */ 
	public static function getManager(container:DisplayObjectContainer):GetResourceManager{
		return dict[container] == null ? dict[container] = new GetResourceManager(container) : dict[container];
	}
	
	/**
	 * 删除记录的DisplayObjectContainer对象
	 */ 
	public static function clear(container:DisplayObjectContainer):Boolean{
		dict[container] = undefined;
		return delete dict[container];
	}
	
	/**
	 * 获取文本对象
	 * @param name
	 * @param slience
	 * @param removing
	 * @return 
	 */
	public function getTextField(name:String, slience:Boolean = true, removing:Boolean = true):TextField{
		var t:TextField = this.content.getChildByName(name) as TextField;
		if(t){
			if(t.type == TextFieldType.DYNAMIC){
				t.mouseEnabled = !slience;
				t.selectable = !slience;
			}
			else if(t.type == TextFieldType.INPUT){
				t.tabEnabled = false;
			}
			if(removing){
				t.text = "";
			}
		}
		return t;
	}
	
	/**
	 * 获取一个影片剪辑
	 * @param name
	 * @param slience
	 * @return 
	 */
	public function getMovieClip(name:String, slience:Boolean = true):MovieClip{
		var t:MovieClip = this.content.getChildByName(name) as MovieClip;
		if(t){
			t.mouseEnabled = !slience;
			t.mouseChildren = !slience;
            t.tabEnabled = false;
			t.tabChildren = false;
			t.buttonMode = !slience;
		}
		if(t && t.totalFrames > 1){
			t.gotoAndStop(1);
		}
		return t;
	}
	
	/**
	 * 获取一个Sprite对象
	 * @param name
	 * @param slience
	 * @return 
	 */
	public function getSprite(name:String, slience:Boolean = true):Sprite{
		var t:Sprite = this.content.getChildByName(name) as Sprite;
		if(t){
			t.mouseEnabled = !slience;
			t.mouseChildren = !slience;
            t.tabEnabled = false;
			t.tabChildren = false;
            t.buttonMode = !slience;
		}
		return t;
	}
	
	/**
	 * 获取一个SimpleButton对象
	 * @param name
	 * @param slience
	 * @return 
	 */
	public function getSimpleButton(name:String, slience:Boolean = false):SimpleButton{
		var t:SimpleButton = this.content.getChildByName(name) as SimpleButton;
		if(t){
			t.mouseEnabled = !slience;
            t.tabEnabled = false;
		}
		return t;
	}
}
}
