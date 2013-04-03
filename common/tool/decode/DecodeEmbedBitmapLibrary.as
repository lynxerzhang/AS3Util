package common.tool.decode
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * @see http://www.danstechden.com/2012/11/03/embed-images-as-binarydata-in-as3-to-reduce-swf-size/
 * 
 */
public class DecodeEmbedBitmapLibrary implements IDecodeBitmapAsset
{
	public static function create(asset:Class, complete:Function = null, progress:Function = null):DecodeEmbedBitmapLibrary {
		return new DecodeEmbedBitmapLibrary(asset, complete, progress);
	}
	
	public function DecodeEmbedBitmapLibrary(assetCls:Class, complete:Function = null, decodeProgress:Function = null) 
	{
		if (!isLegal(assetCls, IBitmapAsset)) {
			clear();
			throw new IllegalOperationError("assetCls must implements IBitmapAsset");
		}
		completeFun = complete;
		progressFun = decodeProgress;
		mainAsset = assetCls;
		preload();
	}
	
	private function clear():void {
		System.disposeXML(describeDetail);
		describeDetail = null;
	}
	
	private var mainAsset:Class;
	private function preload():void {
		var len:int = describeDetail.constant.*.length();
		if (len >= 1) {
			total = len;
			var byteAry:ByteArray;
			for each(var item:XML in describeDetail.constant) {
				byteAry = new mainAsset[item.@name] as ByteArray;
				if (byteAry) {
					bitmapDict[mainAsset[item.@name]] = true;
					clsNameMatchAry[waitLoadBytes.push(byteAry) - 1] = mainAsset[item.@name];
				}
				else {
					--total;
				}
			}
			if (waitLoadBytes.length != 0) {
				beginLoad();
			}
		}
	}
	
	private var waitLoadBytes:Array = [];
	private var clsNameMatchAry:Array = [];
	
	private function beginLoad():void {
		if (!loader) {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		}
		loader.loadBytes(waitLoadBytes[index++]);
	}
	
	private function loaderComplete(evt:Event):void {
		bitmapDict[clsNameMatchAry[index - 1]] = loader.content;
		if (progressFun != null) {
			progressFun();
		}
		if (index != total) {
			loader.loadBytes(waitLoadBytes[index++]);
		}
		else {
			if (completeFun != null) {
				completeFun();
			}
			clear();
		}
	}
	
	private var index:int;
	private var total:int;
	
	private var loader:Loader;
	private var describeDetail:XML;
	
	private var completeFun:Function;
	private var progressFun:Function;
	
	private var bitmapDict:Dictionary = new Dictionary(false);
	
	private function isLegal(cls:Class, interfaces:Class):Boolean {
		describeDetail = describeType(cls);
		var isImpl:Boolean = describeDetail.factory.implementsInterface.(@type == getQualifiedClassName(interfaces)).length() > 0;
		return isImpl;
	}
	
	public function get isComplete():Boolean {
		return index >= total;
	}
	
	public function get progress():int {
		return index / total;
	}
	
	public function getBitmap(cls:Class):Bitmap {
		if (cls in bitmapDict) {
			return new Bitmap(bitmapDict[cls].bitmapData.clone());
		}
		return null;
	}
	
	public function getBitmapData(cls:Class):BitmapData {
		var b:Bitmap = getBitmap(cls);
		if (b) {
			return b.bitmapData;
		}
		return null;
	}
	
	public function dispose():void {
		clear();
		if (loader) {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			loader.unloadAndStop();
			loader = null;
		}
		waitLoadBytes.length = 0;
		clsNameMatchAry.length = 0;
		completeFun = null;
		progressFun = null;
		for each(var item:* in bitmapDict) {
			if (item is Bitmap) {
				Bitmap(item).bitmapData.dispose();
				Bitmap(item).bitmapData = null;
			}
		}
		bitmapDict = null;
	}
}
}