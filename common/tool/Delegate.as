package common.tool
{

public class Delegate
{	

	/**
	 * 和delegate方法相同, 但是强制指定函数执行作用域(避免this引用问题)
	 */ 
	public static function bindable(scope:*, fun:Function, ...args):Function{
		return function(...rest):void{
			fun.apply(scope, rest.concat(args));
		}
	}

	/**
	 * 保持指定的args参数的作用域, 并返回保持该作用域的function实例
	 */ 
	public static function delegate(fun:Function, ...args):Function{
		return function(...rest):void{
			fun.apply(null, rest.concat(args));
		}
	}
	
	/**
	 * delegate call
	 */
	public static function delegateCall(fun:Function, ...args):Function{
		return function(...rest):void{
			fun.call(null, rest.concat(args));
		}
	}
	
	/**
	 * 类似于bindable, 但是可以自由组合所需参数
	 * @param	s		可以为作用域, 也可为方法本身
	 * @param	m		可为参数, 方法, 或者方法名
	 * @param	...args	参数集合
	 * @example
	 * 			Delegate.invoke(test, ["tracetestInvoke"])();
	 * 			Delegate.invoke(test, "tracetestInvoke")();
	 * 			Delegate.invoke(this, "test", "tracetestInvoke")();
	 * @return
	 */
	public static function invoke(s:*, m:* = null, ...args):Function {
		var fun:Function;
		if (typeof s == "function") {
			fun = s;
			s = null;
			if (!(m is Array)) {
				args = m != null ? [m].concat(args) : [];
			}
			else {
				args = m;
			}
		}
		else {
			if (s != null) {
				if (m is String) {
					//该方法作用域需要为public
					fun = s[m];
				}
			}
			if (!fun) {
				fun = m;
			}
			if (args && args.length > 0) {
				if (args[0] is Array) {
					args = args[0];
				}
			}
		}
		return function(...rest):void {
			fun.apply(s, rest.concat(args));
		}
	}
	
	/**
	 * 返回保持多重参数的function对象
	 * @example
	 * 与数组的map方法配合使用
	 */ 
	public static function multiMap(f:Function):Function{
		return function(item:*, ...funArgs):void{
			f.apply(null, [item].concat(funArgs));
		}
	}
	
	/**
	 * 仅返回function对象 
	 * @example
	 * 与数组的map方法配合使用
	 */ 
	public static function map(f:Function):Function{
		return function(item:*, ...funArgs):void{
			f(item);
		}
	}
}

}
