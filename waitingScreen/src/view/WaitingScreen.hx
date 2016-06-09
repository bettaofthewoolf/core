package view;

import events.ConvasEvents;
import events.Observer;
import haxe.Timer;
import js.Browser;
import view.events.WaitingScreenEvent;

class WaitingScreen extends Observer
{
	var timerViewD:TimerUnitViewController;
	var timerViewH:TimerUnitViewController;
	var timerViewM:TimerUnitViewController;
	var timerViewS:TimerUnitViewController;
	
	var timer:Timer;
	
	var dayTittles:Array<String> = ["День", "Дня", "Дней"];
	var hoursTittles:Array<String> = ["Час", "Часа", "Часов"];
	var minuteTittles:Array<String> = ["Минута", "Минуты", "Минут"];
	var secondTittles:Array<String> = ["Секунда", "Секунды", "Секунд"];

	var convas:ConvasSimple;
	
	public function new() 
	{
		super();
		
		buildUI();
	}
	
	public function show():Void
	{
		var waitingDelay:Int = Std.int(Settings.getInstance().START_TIME - StableDate.currentTime - (60 * 2 * 60 * 1000));
		
		trace('waiting delay', waitingDelay);
		
		timer = new Timer(waitingDelay);
		timer.run = onTimerIsEnd;
		
		convas.init("timerCanvas");
	}
	
	private function onPreRender(e:ConvasEvents):Void 
	{
		tick();
	}
	
	function tick() 
	{
		StableDate.advanceTime();
		var seconds:Float = (Settings.getInstance().START_TIME - StableDate.currentTime) / 1000;
		var minutes:Float = seconds / 60;
		var hours:Float = minutes / 60;
		
		var days:Float = hours / 24;
		
		seconds = seconds % 60;
		minutes = minutes % 60;
		
		if (days > 0)
		{
			hours = hours % 24;
		}
		
		updateUi(days, hours, minutes, seconds);
	}
	
	function formatToTime(value:Float):String
	{
		var valueAsString:String = Std.string(value);
		
		if (valueAsString.length == 1)
			valueAsString = "0" + valueAsString;
			
		return valueAsString;
	}
	
	function onTimerIsEnd():Void
	{
		timer.stop();
		dispatchEvent(new WaitingScreenEvent(WaitingScreenEvent.WAITING_END));
	}
	
	function updateUi(days:Float, hours:Float, minutes:Float, seconds:Float):Void
	{
		timerViewD.update(days);
		timerViewH.update(hours);
		timerViewM.update(minutes);
		timerViewS.update(seconds);
	}
	
	function buildUI():Void
	{
		convas = new ConvasSimple();
		convas.addEventListener(ConvasEvents.PRE_RENDER, onPreRender);
		
		timerViewD = new TimerUnitViewController(Browser.document.getElementById("timeD"), dayTittles, 30);
		timerViewH = new TimerUnitViewController(Browser.document.getElementById("timeH"), hoursTittles, 24);
		timerViewM = new TimerUnitViewController(Browser.document.getElementById("timeM"), minuteTittles, 60);
		timerViewS = new TimerUnitViewController(Browser.document.getElementById("timeS"), secondTittles, 60);
		
		updateUi(0, 0, 0, 0);
		
		convas.addChild(timerViewD.bgView);
		convas.addChild(timerViewH.bgView);
		convas.addChild(timerViewM.bgView);
		convas.addChild(timerViewS.bgView);
	}
}