package common.tool
{

public class Delegate
{	
	/**
	 * 保持指定的args参数的作用域, 并返回保持该作用域的function实例
	 */ 
	public static function delegate(fun:Function, ...args):Function{
		return function(...rest):void{
			fun.apply(null, rest.concat(args));
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