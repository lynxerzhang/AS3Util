package common.utils 
{
import flash.utils.Dictionary;

public class XMLUtil 
{
	public function XMLUtil() 
	{
		
	}
	
	/**
	 * 检查指定属性值是否属于指定的xml对象
	 * @param	attributeValue
	 * @param	details
	 * @return
	 */
	public static function isAttribute(attributeValue:String, details:XML):Boolean {
		var isFound:Boolean = false;
		var list:XMLList = details.attributes();
		var aname:String;
		for each(aname in list) {
			if (aname == attributeValue) {
				isFound = true;
				break;
			}
		}
		if (isFound) {
			return isFound;
		}
		list = details..*.attributes();
		for each(aname in list) {
			if (aname == attributeValue) {
				isFound = true;
				break;
			}
		}
		return isFound;
	}
	
	
	private static const DICT:Dictionary = new Dictionary();
	
	/**
	 * 解除xml对象的属性值对整个xml对象的引用依赖
	 * 
	 * TODO:
	 * 在FlashIDE中可以工作, 但是在FD中不起作用, 即使调用
	 * System.disposeXML也是如此。
	 * 
	 * @param	attributeValue
	 */
	public static function detachMaster(attributeValue:String):void {
		DICT[attributeValue] = true;
		delete DICT[attributeValue];
	}
	
	/**
	 * 如果xml中的属性值无法通过detachMaster方法解除引用, 可以用
	 * 该方法(使用slice重新分配一个字符串)
	 * 
	 * @see 	detachMaster
	 * @param	attributeValue
	 * @example
	 * var d:XML =  <roots d="firstAttr">
	 *		    <a c="secAttr">
	 *		        <c1 e="thirdAttr">
	 *			    <ff ct="forthAttr">firstNode</ff>
	 *			</c1>
	 *		    </a>
	 *		    <b>secNode</b>
	 *		    <c>thirdNode</c>
	 *		</roots>
	 *  var s:String = d.a.c1.ff.@ct;//获取属性值
	 *  trace(flash.sampler.getMasterString(s)); //将会输出整个xml对象
	 * @return
	 */
	public static function detachMaster2(attributeValue:String):String {
		return (attributeValue + "_").slice(0, attributeValue.length);
	}
}

}