package view;

import events.Observer;
import haxe.Timer;
import js.Browser;
import js.html.Element;
import view.events.WaitingScreenEvent;

class WaitingScreen extends Observer
{
	var container:Element;
	var waitingTimerD:Element;
	var waitingTimerH:Element;
	var waitingTimerM:Element;
	var waitingTimerS:Element;
	var timer:Timer;

	public function new() 
	{
		super();
		
		buildUi();
		initialize();
	}
	
	function initialize() 
	{
		timer = new Timer(1000);
		timer.run = onTick;
	}
	
	function onTick() 
	{
		var currentTime:Float = StableDate.currentTime;
		var startTime:Float = Settings.getInstance().START_TIME;
		
		if (startTime - currentTime <= 0)
		{
			timer.stop();
			dispatchEvent(new WaitingScreenEvent(WaitingScreenEvent.WAITING_END));
		}
		else
		{
			var seconds:Float = (startTime - currentTime) / 1000;
			var minutes:Float = Math.ffloor(seconds / 60);
			var hours:Float = Math.ffloor(minutes / 60);
			
			var days:Float = Math.ffloor(hours / 24);
			
			seconds = Math.ffloor(seconds % 60);
			minutes = Math.ffloor(minutes % 60);
			
			if (days > 0)
			{
				hours = hours % 24;
			}
			
			//waitingTimer.innerText = (days > 0? (formatToTime(days) + ":"):"") + formatToTime(hours) + ":" + formatToTime(minutes) + ":" + formatToTime(seconds);
			
			if (waitingTimerD != null)
			{
				waitingTimerD.innerText = formatToTime(days);
			}
			
			if (waitingTimerH != null)
			{
				waitingTimerH.innerText = formatToTime(hours);
			}
			
			if (waitingTimerM != null)
			{
				waitingTimerM.innerText = formatToTime(minutes);
			}
			
			if (waitingTimerS != null)
			{
				waitingTimerS.innerText = formatToTime(seconds);
			}
		}
	}
	
	function formatToTime(value:Float):String
	{
		var valueAsString:String = Std.string(value);
		
		if (valueAsString.length == 1)
			valueAsString = "0" + valueAsString;
			
		return valueAsString;
	}
	
	function buildUi() 
	{
		container = Browser.document.getElementById("waitingScreen");
		
		waitingTimerD = Browser.document.getElementById("timerD");
		waitingTimerH = Browser.document.getElementById("timerH");
		waitingTimerM = Browser.document.getElementById("timerM");
		waitingTimerS = Browser.document.getElementById("timerS");
	}
	
	public function hide():Void
	{
		container.hidden = true;
	}
	
	public function show():Void
	{
		container.hidden = false;
	}
}