package tool
{	
/** 
 * same Mechanism with utils.SingletonMap, but this style is easy to use
 * 
 * @param c Class you want to instantiated, be careful this class's constructor could not have parameter
 * 
 * @see SingletonMap
 */ 
public var SingleGet:Function = function(c:Class):*{
	return SingleRelyDict[c] != null ? SingleRelyDict[c] : SingleRelyDict[c] = new c();
}
}