package;

import events.DataEvent;
import external.DataLoader;

class EntryPoint 
{
	static function main() 
	{
		trace(main, main);
		onStart();
	}
	
	static public function onStart() 
	{
		correctBy(untyped  __js__('getTimeCorrectURL()'));
	}
	
	public static function correctBy(path:String)
	{
		var dataLoader:DataLoader = new DataLoader();
		dataLoader.addEventListener(DataEvent.ON_LOAD, onDataLoad);
		dataLoader.load(path);
	}
	
	static private function onDataLoad(e:DataEvent):Void 
	{
		var dataParts:Array<String>;
		
		if (e.data.indexOf("\r\n") != -1)
			dataParts = e.data.split("\r\n");
		else
			dataParts = e.data.split("\n");
			
		var correction:Float = Std.parseFloat(dataParts[0]);
		StableDate.correct(correction);
		
		Settings.getInstance().TODAY_MONTH = Std.parseInt(dataParts[2]);
		Settings.getInstance().TODAY_DAY = Std.parseInt(dataParts[3]);
		Settings.getInstance().TODAY = Std.parseInt(dataParts[1]);
		
		trace(dataParts[0]);
		trace(Settings.getInstance().TODAY_MONTH);
		trace(Settings.getInstance().TODAY_DAY);
		trace(Settings.getInstance().TODAY);
		new Main();
	}
}