package;

import haxe.crypto.Base64;
import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import js.Browser;
import js.html.Element;
import js.html.InputElement;
import js.html.Storage;
import js.Lib;
import passkey.PassKey;

class Main 
{
	static private var baseURL:InputElement;
	static private var output:InputElement;
	static private var datePicker:InputElement;
	static private var timePicker:InputElement;
	static private var videoLength:InputElement;
	static private var isEveryday:InputElement;
	static private var isTestControll:InputElement;
	
	static private var storage:Storage;
	static private var traceOutput:Element;
	
	
	static function main() 
	{
		trace(main, main);
		storage = Browser.getLocalStorage();
		
		traceOutput = Browser.document.getElementById("haxe:trace");
		output = cast(Browser.document.getElementById("out"), InputElement);
		baseURL = cast(Browser.document.getElementById("baseURL"), InputElement);
		datePicker = cast(Browser.document.getElementById("datepicker"), InputElement);
		videoLength = cast(Browser.document.getElementById("videoLength"), InputElement);
		timePicker = cast(Browser.document.getElementById("timepicker"), InputElement);
		isEveryday = cast(Browser.document.getElementById("isEveryday"), InputElement);
		isTestControll = cast(Browser.document.getElementById("isTest"), InputElement);
		
		if(storage.getItem('baseURL') != null)
			baseURL.value =	storage.getItem('baseURL');
		
		Browser.document.getElementById("generate").onclick = onClick;
	}
	
	private static function validateTimeInput(input:String):Bool
	{
		return (input == null || input.length == 0 || input.indexOf(":") == -1 || input.split(":").length < 2);
	}
	
	static private function onClick():Void 
	{
		traceOutput.innerText = "";
		
		var baseDateString:String = datePicker.value;
		var baseDateParts:Array<String> = baseDateString.split("/");
		
		var timeString:String;
		var lengthString:String;
		var videoLengthValue:Int;
		
		var startMonth:Int = 0;
		var startDay:Int = 0;
		
		var isEverydayChecked:Bool = isEveryday.checked;
		
		if (!isEverydayChecked)
		{
			if (baseDateParts.length != 3)
			{				
				output.value = "wrong date format";
				return;
			}
			
			startMonth = Std.parseInt(baseDateParts[0]);
			startDay = Std.parseInt(baseDateParts[1]);
		}
		
		timeString = timePicker.value;
		
		if (validateTimeInput(timeString))
		{
			output.value = "wrong time format";
			return;
		}
		
		lengthString = videoLength.value;
		if (validateTimeInput(lengthString))
		{
			output.value = "wrong videl length format";
			return;
		}
		else
		{
			var tHours:Int = 0;
			var tMinutes:Int = 0;
			var tSeconds:Int = 0;
			
			var lengthParts:Array<String> = lengthString.split(":");
			
			if (lengthParts.length == 1)
			{
				lengthParts.unshift("00");
			}
			
			if (lengthParts.length == 2)
			{
				lengthParts.unshift("00");
			}
			
			tHours = Std.parseInt(lengthParts[0]);
			tMinutes = Std.parseInt(lengthParts[1]);
			tSeconds = Std.parseInt(lengthParts[2]);
			
			videoLengthValue = (((tHours * 60 + tMinutes) * 60) + tSeconds) * 1000;
		}
		
		storage.setItem('baseURL', baseURL.value);
		
		timeString += ":00";
		
		var tempDate:Date = Date.now();
		
		var startTime:Float = Date.fromString(timeString).getTime();
		
		var isTest:Bool = isTestControll.checked;
		
		var key:PassKey = new PassKey(startTime, videoLengthValue, isEverydayChecked, startMonth, startDay, isTest);
		
		var encoded:String = key.encode();
		trace(encoded);
		
		trace('report');
		trace("start time: " + Date.fromTime(key.startTime));
		
		key = new PassKey();
		key.decode(encoded);
		
		if (key.isKey == true)
			trace('isKey - pass');
		else
			trace('Error: wrong key pass data, value=' + key.isKey);
			
		if (key.isTest == isTest)
			trace('isTest - pass, value=' + key.isTest);
		else
			trace('Error: wrong test data, value=' + key.isTest);
			
		if (key.isEveryday == isEveryday.checked)
			trace('isEveryday - pass, value=' + key.isEveryday);
		else
			trace('Error: wrong isEveryday data, value=' + key.isEveryday);
			
		if (key.startTime == startTime)
			trace('timeString - pass, value=' + key.startTime);
		else
			trace('Error: wrong timeString data, value=' + key.startTime);
			
		if (key.videoLength == videoLengthValue)
			trace('videoLength - pass, value=' + key.videoLength);
		else
			trace('Error: wrong videoLength data, value=' + key.videoLength);
		
		if(!isEverydayChecked)
		{
			if (key.startMonth == startMonth)
				trace('startMonth - pass, value=' + key.startMonth);
			else
				trace('Error: wrong startMonth data, value=' + key.startMonth);
				
			if (key.startDay == startDay)
				trace('startDay - pass, value=' + startDay);
			else
				trace('Error: wrong startDay data, value=' + key.startDay);
		}
		
		output.value = baseURL.value + "?passKey=" + encoded;
	}
	
	static function formatToTime(value:Float):String
	{
		var valueAsString:String = Std.string(value);
		
		if (valueAsString.length == 1)
			valueAsString = "0" + valueAsString;
			
		return valueAsString;
	}
}