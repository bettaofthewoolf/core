package view;

import events.Observer;
import haxe.Timer;
import js.Browser;
import js.html.Element;
import view.events.WaitingScreenEvent;

class WaitingScreen extends Observer
{
	var timerView:Element;
	var timer:Timer;

	public function new() 
	{
		super();
		
		buildUI();
	}
	
	public function show():Void
	{
		var waitingDelay:Int = Std.int(Settings.getInstance().START_TIME - StableDate.currentTime);
		
		trace('waiting delay', waitingDelay);
		
		untyped __js__('resetTimer({0})', Settings.getInstance().START_TIME);
		
		timer = new Timer(waitingDelay);
		timer.run = onTimerIsEnd;
	}
	
	function onTimerIsEnd() 
	{
		timer.stop();
		dispatchEvent(new WaitingScreenEvent(WaitingScreenEvent.WAITING_END));
	}
	
	function buildUI() 
	{
		timerView = Browser.document.getElementById("timerView");
	}
}