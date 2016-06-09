package view;
import js.html.Element;

class TimerUnitViewController
{
	var element:Element;
	public var bgView:TimerCircle;
	var textCases:Array<String>;
	var textPattern:String;
	
	var lastValue:Float = -1;

	public function new(element:Element, textCases:Array<String>, maxValue:Float) 
	{
		this.maxValue = maxValue;
		textPattern = element.innerHTML;
		
		this.textCases = textCases;
		this.bgView = new TimerCircle(element);
		this.element = element;
		
		timerCirclesSize = untyped __js__("getTimerCircleSizeRatio()");
	}
	
	public function update(value:Float):Void
	{
		var newFlooredValue:Float = Math.ffloor(value);
		if (lastValue != newFlooredValue)
		{
			element.innerHTML = StringTools.replace(StringTools.replace(textPattern, "{0}", Std.string(newFlooredValue)), "{1}", declOfNum(Std.int(value), textCases));
			lastValue = newFlooredValue;
		}
		
		bgView.size = element.offsetHeight * timerCirclesSize;
		bgView.value = value/maxValue;
	}
	
	var maxValue:Float;
	private var cases:Array<Int> = [2, 0, 1, 1, 1, 2];
	var timerCirclesSize:Float;
	function declOfNum(number:Int, titles:Array<String>):String
	{  
		return titles[ (number%100>4 && number%100<20)? 2 : cases[(number%10<5)?number%10:5] ];  
	}
}