package view;
import js.html.Element;

class TimerUnitViewController
{
	var circleView:TimerCircle;
	var canvas:ConvasSimple;
	
	var maxValue:Float;
	var cases:Array<Int> = [2, 0, 1, 1, 1, 2];
	var timerCirclesSize:Float;
	
	var element:Element;
	var textCases:Array<String>;
	var textPattern:String;
	
	var lastValue:Float = -1;
	var textValue:Element;
	

	public function new(element:Element, textCases:Array<String>, maxValue:Float) 
	{
		this.element = element;
		this.textCases = textCases;
		this.maxValue = maxValue;
		
		textValue = element.getElementsByClassName("textValue")[0];
		textPattern = textValue.innerHTML;
		
		canvas = new ConvasSimple();
		canvas.initByClass(element, "timerCircle");
		circleView = new TimerCircle();
		canvas.addChild(circleView);
		
		timerCirclesSize = untyped __js__("getTimerCircleSizeRatio()");
	}
	
	public function update(value:Float):Void
	{
		var newFlooredValue:Float = Math.ffloor(value);
		if (lastValue != newFlooredValue)
		{
			textValue.innerHTML = StringTools.replace(StringTools.replace(textPattern, "{0}", Std.string(newFlooredValue)), "{1}", declOfNum(Std.int(value), textCases));
			lastValue = newFlooredValue;
		}
		
		circleView.size = Math.max(canvas.width, canvas.height) / 2;// element.offsetHeight * timerCirclesSize;
		circleView.value = value / maxValue;
		canvas.render();
	}
	
	
	function declOfNum(number:Int, titles:Array<String>):String
	{  
		return titles[ (number%100>4 && number%100<20)? 2 : cases[(number%10<5)?number%10:5] ];  
	}
}