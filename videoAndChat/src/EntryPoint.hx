package;

import events.Event;

class EntryPoint 
{
	static function main() 
	{
		trace(main, main);
		onStart();
	}
	
	static public function onStart() 
	{
		var dateCorrectionTool:DateCorrectionTool = new DateCorrectionTool();
		dateCorrectionTool.addEventListener(Event.COMPLETE, onCorrectionComplete);
		dateCorrectionTool.correct();
	}
	
	static private function onCorrectionComplete(e:Event):Void 
	{
		new Main();
	}
}