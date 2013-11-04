package common.utils 
{
	/**
	 * 可用于判定是否2个VO对象的地址值是否相同, 由于大量的VO对象不做缓存, 
	 * 所有有时候可以用此方法来判断VO对象是否相同
	 * 
	 * @example
	 * var s:Sprite  = new Sprite();
     * trace(getID(s)); //@2d529a1
	 * 
	 * get object's memory address
	 * @see http://stackoverflow.com/questions/1343282/how-can-i-get-an-instances-memory-location-in-actionscript
	 * @param	data
	 * @return
	 */
	public function getID(data:Object):String
	{
		try {
			FakeClass(data);
		}
		catch (e:Error) {
			var k:Array = String(e).match(/@\w+(?=\s+)/);
			if (!k) {
				return "cannot get data's address, maybe this is a primitive value";
			}
			else {
				if (k.length == 1) {
					return k[0];
				}
				else {
					return "cannot get data's address, maybe this is a instance method";
				}
			}
		}
		return "cannot get data's address, maybe this is a null or undefined value";
	}
}

internal class FakeClass {
}
