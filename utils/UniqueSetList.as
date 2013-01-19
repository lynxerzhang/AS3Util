package utils
{
import tool.Signal;

/**
 * 保持存储对象的唯一性
 */ 
public class UniqueSetList
{
	/**
	 * TODO (变为Vector对象)
	 * @param ary  存储的数组对象
	 * @param prop 其中保存的对象的属性名
	 */ 
	public function UniqueSetList(prop:String, ary:Array = null)
	{
		dataProp = prop;
		list = ary == null ? [] : ary;
	}
	
	private var dataProp:String;
	private var list:Array;
	private var addS:Signal = new Signal();
	private var removeS:Signal = new Signal();
	
	/**
	 * 获取追加的新对象的监听信号
	 */ 
	public function get add():Signal{
		return addS;
	}
	
	/**
	 * 获取删除的新对象的监听信号
	 */ 
	public function get remove():Signal{
		return removeS;
	}
	
	/**
	 * 添加一个指定对象进入当前列表中
	 */ 
	public function addItem(data:Object, slience:Boolean = false):void{
		var index:int = ArrayUtil.obtainIndex(list, data, dataProp);
		if(index == -1){
			list.push(data);
			if(!slience){
				add.dispatch(data);
			}
		}
		else{
			list.splice(index, 1, data);
		}
	}

	/**
	 * 添加包含指定对象的数组至当前列表中
	 */ 
	public function addItems(ary:Array):void{
		ary = ArrayUtil.removeSameElement(ary, dataProp);
		ary.forEach(function(data:Object, ...args):void{
			addItem(data);
		});
	}
	
	/**
	 * 将指定的对象存至对应列表的指定索引位置
	 */ 
	public function addItemAt(data:Object, index:int):void{
		var i:int = ArrayUtil.obtainIndex(list, data, dataProp);		
		if(i == -1){
			list.splice(index, 0, data);
			add.dispatch(data);
		}
		else{
			if(i == index){
				list.splice(i, 1, data);
			}
			else{
				list.splice(i, 1);
				list.splice(index, 0, data);
			}
		}
	}
	
	/**
	 * 删除指定对象
	 */ 
	public function removeItem(data:Object, slience:Boolean = false):Object{
		var i:int = ArrayUtil.obtainIndex(list, data, dataProp);
		if(i != -1){
			var b:Object = list.splice(i, 1)[0];
			if(!slience){
				remove.dispatch(b);
			}
			return b;
		}
		return null;
	}
	
	/**
	 * 删除指定的数组中的指定对象
	 */ 
	public function removeItems(ary:Array):void{
		ary = ArrayUtil.removeSameElement(ary, dataProp);
		ary.forEach(function(data:Object, ...args):void{
			removeItem(data);
		});
	}
	
	/**
	 * 清除指定位置的对象
	 */ 
	public function removeItemAt(index:int):Object{
		if(index < 0 || index >= list.length){
			return null;
		}
		var data:Object = list.splice(index, 1)[0];
		remove.dispatch(data);
		return data;
	}
	
	/**
	 * 判断列表是否为空
	 */ 
	public function isEmpty():Boolean{
		return list.length == 0;
	}
	
	/**
	 * 清除所有列表中含有的对象
	 */ 
	public function removeAll(disposeFun:Function = null):void{
		if(disposeFun != null){
			list.forEach(function(data:Object, ...args):void{
				disposeFun(data);
			});
		}
		list.length = 0;
	}
	
	/**
	 * 清除引用
	 */ 
	public function dispose(disposeFun:Function = null):void{
		removeAll(disposeFun);
		add.removeAll();
		remove.removeAll();
	}
}
}