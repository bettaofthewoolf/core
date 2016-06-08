package;
import events.DataEvent;
import events.Event;
import events.Observer;
import external.DataLoader;
import js.Browser;

class DateCorrectionTool extends Observer
{

	public function new() 
	{
		super();
	}
	
	public function correct():Void
	{
		correctBy(getPath());
	}
	
	function getPath():String
	{
		var currentLocation:String = Browser.window.location.href;
		if (currentLocation.indexOf("bettaofthewoolf") != -1 || currentLocation.indexOf("localhost") != -1)
			return "http://murigin.ru/auto/utc_time.php";
		else
			return "utc_time.php";
		
		//return "";
	}
	
	private function correctBy(path:String)
	{
		var dataLoader:DataLoader = new DataLoader();
		dataLoader.addEventListener(DataEvent.ON_LOAD, onDataLoad);
		dataLoader.load(path);
	}
	
	private function onDataLoad(e:DataEvent):Void 
	{
		var dataParts:Array<String>;
		
		if (e.data.indexOf("\r\n") != -1)
			dataParts = e.data.split("\r\n");
		else
			dataParts = e.data.split("\n");
			
		var correction:Float = Std.parseFloat(dataParts[0]) * 1000;
		StableDate.correct(correction);
		
		Settings.getInstance().TODAY_MONTH = Std.parseInt(dataParts[2]);
		Settings.getInstance().TODAY_DAY = Std.parseInt(dataParts[3]);
		Settings.getInstance().TODAY = Std.parseFloat(dataParts[1]) * 1000;
		
		trace(dataParts[0]);
		trace(Settings.getInstance().TODAY_MONTH);
		trace(Settings.getInstance().TODAY_DAY);
		trace(Settings.getInstance().TODAY);
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
}