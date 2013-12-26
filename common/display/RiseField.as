package common.display
{
import common.utils.BitmapUtil;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import common.utils.DisplayObjectUtil;

public class RiseField implements IMotionSync
{
	/**
	 * 字体颜色
	 */
	private var fontColor:uint = RiseFieldArgu.WHITE;
	
	/**
	 * 字体大小
	 */
	private var fontSize:uint = RiseFieldArgu.FONT_SIZE;
	
	/**
	 * 外发光滤镜
	 */
	private var glow:GlowFilter = new GlowFilter(RiseFieldArgu.GLOW_COLOR, 1.0, 2, 2, 1024);
	
	/**
	 * 显示文本
	 */
	private var showTxt:TextField;
	
	/**
	 * 包含文本的容器
	 */
	private var showTxtSprite:Sprite;
	
	/**
	 * 样式
	 */
	private var txtStyle:RiseFieldStyle;
	
	/**
	 * 是否延迟播放动画
	 */
	private var isDelay:Boolean;
	
	/**
	 * 如果延迟,则延迟的毫秒数
	 */
	private var delayTime:Number;
	
	/**
	 * 记录setTimeout返回数值标识
	 */
	private var timeOutId:Number;
	

	public function RiseField(str:String, style:RiseFieldStyle = null):void{
		this.txtStyle = style;
		if(this.txtStyle != null){
			var t:Number = this.txtStyle.frozenTime;
			if(!isNaN(t)){
				this.delayTime = t;
			}
			this.isDelay = !isNaN(t);
		}
		else{
			this.delayTime = NaN;
			this.isDelay = false;
		}
		this.showTxt = this.generateText(str);
		this.showTxtSprite = BitmapUtil.getCopySprite(this.showTxt);
	}
	
	/**
	 * 获取显示容器
	 */ 
	public function get content():Sprite{
		return this.showTxtSprite;
	}
	
	private function generateText(str:String):TextField{
		var t:TextField = new TextField();
		t.mouseEnabled = false;
		t.autoSize = TextFieldAutoSize.LEFT;
		t.text = str;
		
		var format:TextFormat = new TextFormat();
		format.align = TextFormatAlign.CENTER;
		format.size = this.txtStyle != null ? this.txtStyle.fontSize : fontSize;
		format.color = this.txtStyle != null ? this.txtStyle.fontColor : fontColor;
		format.bold = true;
		
		t.defaultTextFormat = format;
		t.setTextFormat(format);
		
		if(this.txtStyle != null){
			glow.color = this.txtStyle.glowColor;
		}
		t.filters = [glow];
		return t;
	}
	
	/**
	 * 销毁
	 */ 
	public function dispose():void{
		DisplayObjectUtil.removeAll(this.showTxtSprite, true);
		if(this.showTxtSprite && this.showTxtSprite.parent){
			this.showTxtSprite.parent.removeChild(this.showTxtSprite);
			this.showTxtSprite = null;
		}
		this.showTxt = null;
	}
	
	/**
	 * 更新动画
	 */ 
	public function update(time:Number = NaN):void{
		if(this.isDelay && !isNaN(this.delayTime)){
			if(!isNaN(this.timeOutId)){
				return;
			}
			this.timeOutId = setTimeout(function():void{
				clearTimeout(timeOutId);
				timeOutId = NaN;
				isDelay = false;
				delayTime = NaN;
			}, this.delayTime);
			return;
		}
		if (isNaN(time)) {
			time = 0.04;
		}
		this.showTxtSprite.y -= time * (this.txtStyle != null ? this.txtStyle.stepperRate : RiseFieldArgu.STEPPER);
		this.showTxtSprite.alpha -= time * (this.txtStyle != null ? this.txtStyle.alphaRate : RiseFieldArgu.ALPHA);
	}
	
	/**
	 * 判定动画播放是否结束
	 * @return
	 */
	public function isComplete():Boolean{
		return this.showTxtSprite.alpha <= 0;
	}
}
}