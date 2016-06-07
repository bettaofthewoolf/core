package;

import events.DataEvent;
import external.DataLoader;
import haxe.Timer;

class StableDate
{
	private static var isInit:Bool = false;
	private static var updateTimer:Timer = new Timer(500);
	public static var currentTime:Float = 0;
	private static var lastTime:Float = -1;
	private static var internalDate:Date;
	
	public static function correctBy(path:String)
	{
		var dataLoader:DataLoader = new DataLoader();
		dataLoader.addEventListener(DataEvent.ON_LOAD, onDataLoad);
		dataLoader.load(path);
	}
	
	static private function onDataLoad(e:DataEvent):Void 
	{
		var correction:Float = Std.parseFloat(e.data);
		correct(correction);
	}
	
	public static function advanceTime():Void
	{
		if (lastTime == -1)
		{
			lastTime = Date.now().getTime();
			currentTime += 500;
		}
		else
		{
			var newTime:Float = Date.now().getTime();
			var delta:Float = newTime - lastTime;
			
			if (delta > 2000)
			{
				trace('time error too much', delta);
				delta = 500;
			}
			else if (delta < 0)
			{
				trace('time error too low', delta);
				delta = 500;
			}
				
			currentTime += delta;
			lastTime = newTime;
		}
		
		internalDate = Date.fromTime(currentTime);
	}
	
	public static function correct(time:Float):Void
	{
		if (!isInit)
		{
			updateTimer.run = advanceTime;
		}
		
		currentTime = time;
		internalDate = Date.fromTime(currentTime);
	}
	
	public function new() 
	{
		if (!isInit)
		{
			updateTimer.run = advanceTime;
		}
	}
	
	public function getDate():Int 
	{
		return internalDate.getDate();
	}
	
	public function getDay():Int 
	{
		return internalDate.getDay();
	}
	
	public function getFullYear():Int 
	{
		return internalDate.getFullYear();
	}
	
	public function getHours():Int 
	{
		return internalDate.getHours();
	}
	
	public function getMinutes():Int 
	{
		return internalDate.getMinutes();
	}
	
	public function getMonth():Int 
	{
		return internalDate.getMonth();
	}
	
	public function getSeconds():Int 
	{
		return internalDate.getSeconds();
	}
	
	public function getTime():Float 
	{
		return internalDate.getTime();
	}
	
	public function toString():String 
	{
		return internalDate.toString();
	}
}