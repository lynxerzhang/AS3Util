package common.tool
{
	
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * 
 * just encapsulate displayObjectContainer's getChildByName method and offer some custom behavior
 * e.g.(mouseEnabled set)
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
	 * get a GetResourceManager instance
	 */ 
	public static function getManager(container:DisplayObjectContainer):GetResourceManager{
		return dict[container] == null ? dict[container] = new GetResourceManager(container) : dict[container];
	}
	
	/**
	 * delete specfied container's related getResourceManager
	 */ 
	public static function clear(container:DisplayObjectContainer):Boolean{
		dict[container] = undefined;
		return delete dict[container];
	}
	
	/**
	 * get a internal textfield
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
	 * get a internal movieclip
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
	 * get a internal sprite
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
	 * get a simplebutton
	 */ 
	public function getSimpleButton(name:String, slience:Boolean = false):SimpleButton{
		var t:SimpleButton = this.content.getChildByName(name) as SimpleButton;
		if(t){
			t.mouseEnabled = !slience;
                        t.tabEnabled = false;
		}
		return t;
	}
	
	/**
	 * create a non-interactive's sprite
	 * 
	 * @param parent   the sprite's parent
	 * @param name     the sprite's name, add a name for debug purpose
	 */ 
	public static function createSprite(parent:DisplayObjectContainer = null, name:String = null):Sprite{
		var s:Sprite = new Sprite();
		if(name != null && name.length > 0){
			s.name = name;
		}
		if(parent){
			parent.addChild(s);
		}
		s.mouseChildren = s.mouseEnabled = false;
                s.tabEnabled = false;
		s.tabChildren = false;
		return s;
	}
}
}
