package passkey;

import events.Observer;
import js.Browser;
import passkey.PassKey;
import passkey.PassKeyCheckerEvents;

class PassKeyChecker extends Observer
{
	public var passKey:PassKey;

	public function new() 
	{
		super();
	}
	
	public function check():Void
	{
		passKey = getPassKey();
		
		if (passKey.status != -1)
		{
			endWithError();
			return;
		}
		
		var startTime:Float = passKey.startTime;
		
		var startMonth:Int = 0;
		var startDay:Int = 0;
		if (passKey.isEveryday)
		{
			startMonth = Settings.getInstance().TODAY_MONTH;
			startDay = Settings.getInstance().TODAY_DAY;
		}
		else
		{
			startMonth = passKey.startMonth;
			startDay = passKey.startDay;
		}
		
		startTime += Settings.getInstance().TODAY;
		var currentTime:Float = StableDate.currentTime;
		
		if (currentTime - startTime < -31622400000)
		{
			endWithError();
			return;
		}
		
		if (startTime > currentTime + 31622400000)
		{
			endWithError();
			return;
		}
		
		var date1:Int = 0;
		var date2:Int = 0;
		
		if (passKey.isTest)
		{
			Settings.getInstance().START_TIME = currentTime - 30000;
		}
		else
		{
			var month1:Int = Settings.getInstance().TODAY_MONTH;
			var month2:Int = startMonth;
			
			var date1:Int = month1 * 30 + Settings.getInstance().TODAY_DAY;
			var date2:Int = month2 * 30 + startDay;
			
			trace('dates match', date1, date2);
			trace(month2, startDay);
			
			if (date1 > date2)
			{
				dispatchEvent(new PassKeyCheckerEvents(PassKeyCheckerEvents.EVENT_END));
				//showEndState();
				return;
			}
			else
			{
				trace('event will start at', startTime, Date.fromTime(startTime));
				Settings.getInstance().START_TIME = startTime;
			}
		}
		
		var startTimeDelta:Float = Settings.getInstance().START_TIME - currentTime;
		
		trace("videLength", Math.abs(startTimeDelta), passKey.videoLength);
		if (startTimeDelta < 0 && Math.abs(startTimeDelta) > passKey.videoLength)
		{
			dispatchEvent(new PassKeyCheckerEvents(PassKeyCheckerEvents.EVENT_END));
			trace("### EVEND END DETECT BY PASS KEY VIDEO LENGTH");
			return;
		}
		
		trace(Date.fromTime(Settings.getInstance().START_TIME), Date.fromTime(currentTime));
		trace('check start time', Math.floor((startTimeDelta) / 1000 / 60), startTimeDelta);
		
		if (startTimeDelta <= 0)
		{
			trace('init video');
			dispatchEvent(new PassKeyCheckerEvents(PassKeyCheckerEvents.CHECK_IS_OK));
		}
		else
		{
			trace('show waiting');
			dispatchEvent(new PassKeyCheckerEvents(PassKeyCheckerEvents.WAIING_FOR_KEY));
		}
	}
	
	private function endWithError():Void
	{
		dispatchEvent(new PassKeyCheckerEvents(PassKeyCheckerEvents.KEY_CORRUPTED));
	}
	
	private function getPassKey():PassKey
	{
		var location:String = Browser.location.href;
		location = location.substr(location.indexOf("?") + 1, location.length);
		
		var vars:Map<String, String> = parseVariables(location);
		var passKeyInput:String = vars.get("passKey");
		
		var passKey:PassKey = new PassKey();
		passKey.decode(passKeyInput);
		
		return passKey;
	}
	
	function parseVariables(baseString:String)
	{
		var map:Map<String, String> = new Map<String, String>();
		var urlVars:Array<String> = baseString.split("&");
		
		for (urlVar in urlVars)
		{
			var paramName:String = urlVar.substr(0, urlVar.indexOf("="));
			var paramValue:String = urlVar.substr(urlVar.indexOf("=") + 1, urlVar.length);
			
			map.set(paramName, paramValue);
		}
		
		return map;
	}
	
	function formatToTime(value:Float):String
	{
		var valueAsString:String = Std.string(value);
		
		if (valueAsString.length == 1)
			valueAsString = "0" + valueAsString;
			
		return valueAsString;
	}
	
}