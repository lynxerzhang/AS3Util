package common.utils
{
public class AssertUtil
{
	private static const PACKAGE:String = "package";
	private static const CLASS:String = "class";
	private static const METHOD:String = "method";
	private static const CODELINE:String = "codeline";
	
	public static const NO_STACK_TRACE:String = "noStackTrace";
	
	/**
	 * 摘取代码stacktrace报错信息中关于代码位置的信息
	 * @param	str
	 * @example 
	 *    try{
	 *       some code
	 *    }
	 * 	  catch(e:Error){
	 * 		trace(AssertUtil.pluckStackTrace(e.getStackTrace()));
	 * 	  }
	 * @return
	 */
	public static function pluckStackTrace(str:String):String {
		if (str == null) {
			return NO_STACK_TRACE;
		}
		var reg:RegExp = /\s+at\s+(?:(?P<package>[^:]+)::)?(?P<class>\w+)\$?\/(?P<method>\w+)\(\)(?:\[.*?(?P<codeline>\d+)\])?/;
		var isDebugSWF:Boolean = str.search(/.as:[0-9]+]$/m) != -1;
		if (isDebugSWF) {
			//TODO
		}
		var d:Object = reg.exec(str);
		if (!d) {
			return NO_STACK_TRACE;
		}
		return d[PACKAGE] + "," + d[CLASS] + "," + d[METHOD] + "," + d[CODELINE];
	}
}
}