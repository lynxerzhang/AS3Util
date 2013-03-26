package common.data
{
/**
 * 
 * @seehttp://lab.polygonal.de/?page_id=179
 * fork from Michael Baczynski's AS3 Data Structures framework
 * @example
 *  var t:BitVector = new BitVector(32); //共存储32个位
 *  t.setBit(0, 1);
 *  t.setBit(1, 0);
 *  t.setBit(32, 1); //设置位时, 和数组一样, 设置位从0开始, 因此该位设置无效。
 *  trace(t.getBit(0)); //1
 *  trace(t.getBit(1)); //0
 *  trace(t.getBit(32)); //0
 *  trace(t.bitCount); //32
 *  trace(t.cellCount); //1
 */
public class BitVector 
{
	public function BitVector(bits:uint):void {
		resize(bits);
	}
	
	public function resize(bits:uint):void {
		if (desireBits == bits) {
			return;
		}
		cellCounts = bits % maxBits == 0 ? bits / maxBits : ((bits / maxBits)|0) + 1;
		if (desireCellCounts > cellCounts) {
			//TODO
			container.splice(desireCellCounts - cellCounts, cellCounts);
		}
		desireBits = bits;
		desireCellCounts = cellCounts;
	}
	
	private var desireBits:uint;
	private var cellCounts:uint;
	private var desireCellCounts:uint;
	private var container:Array = [];//使用数组，而不是Vector.<uint>, 考虑到Vector无法动态为其元素赋值
	
	public function get cellCount():uint {
		return cellCounts;
	}
	
	public function get bitCount():uint {
		return cellCounts * maxBits;
	}
	
	public function clear():void {
		var len:int = container.length;
		for (var i:int = 0; i < len; i ++) {
			container[i] = unSet;
		}
	}
	
	public function setAll():void {
		var len:int = container.length;
		for (var i:int = 0; i < len; i ++) {
			container[i] = allSet;
		}
	}
	
	public function getBit(b:uint):uint {
		//maxBits 从31改为32, 因此右移位时需要使用无符号右移
		return ((container[(b / maxBits)|0]) & (1 << b % maxBits)) >>> b; 
	}
	
	public function setBit(b:uint, bits:uint):void {
		if (b < 0 || b >= desireBits) {
			//增加指定位设置的判断
			return;
		}
		bits == 1 ? container[(b / maxBits)|0] |= (1 << b % maxBits) : container[(b / maxBits)|0] &= ~(1 << b % maxBits);
	}
	
	private const maxBits:uint = 32;
	private const allSet:uint = uint.MAX_VALUE;
	private const unSet:uint = 0;
	
	public function hasSet():Boolean{
		for(var i:int = 0 ; i < desireBits; i ++){
			if(getBit(i) == 1){
				return true;
			}
		}
		return false;
	}
}
}