package common.utils 
{

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
	
	
	
}

}