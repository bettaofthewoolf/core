package passkey;
import haxe.crypto.Base64;
import haxe.io.Bytes;

class PassKey
{
	static public inline var STATUS_WRONG_INPUT:Int = 0;
	static public inline var STATUS_WRONG_DATA_LENGTH:Int = 1;
	
	static private inline var EVRYDAY_SIZE:Int = 11;
	static private inline var COMMON_SIZE:Int = 15;
	
	
	public var encodedValue:String;
	
	public var isKey:Bool = true;
	
	public var isTest:Bool;
	public var isEveryday:Bool;
	public var startMonth:Int;
	public var startDay:Int;
	public var startTime:Float;
	public var videoLength:Int;
	
	public var status:Int = -1;
	
	public function new(startTime:Float = 0, videoLength:Int = 0, isEveryday:Bool = true, startMonth:Int = 0, startDay:Int = 0, isTest:Bool = false) 
	{
		this.videoLength = videoLength;
		this.isTest = isTest;
		this.startDay = startDay;
		this.startMonth = startMonth;
		this.isEveryday = isEveryday;
		this.startTime = startTime;
	}
	
	public function encode():String
	{
		var bytes:Bytes = Bytes.alloc(isEveryday? EVRYDAY_SIZE:COMMON_SIZE);
		
		bytes.set(0, Math.floor(Math.random() * 255));
		
		bytes.set(1, 1);
		bytes.setInt32(2, Std.int(startTime));
		bytes.setInt32(6, videoLength);
			
		if(isEveryday)
		{	
			bytes.set(10, isTest? 1:0);
		}
		else
		{
			bytes.setUInt16(10, startMonth);
			bytes.set(12, isTest? 1:0);
			bytes.setUInt16(13, startDay);
		}
		
		return Base64.encode(bytes);
	}
	
	public function decode(encodedValue:String):Void
	{
		this.encodedValue = encodedValue;
		
		if (encodedValue == null || encodedValue.length == 0)
		{
			status = STATUS_WRONG_INPUT;
			return;
		}
		
		var bytes:Bytes = Base64.decode(encodedValue);
		
		
		if (bytes.length != COMMON_SIZE && bytes.length != EVRYDAY_SIZE)
		{
			status = STATUS_WRONG_DATA_LENGTH;
			return;
		}
		
		isKey = bytes.get(1) == 1;
		
		startTime = cast(bytes.getInt32(2), Float);
		videoLength = bytes.getInt32(6);
		
		isEveryday = bytes.length == EVRYDAY_SIZE;
		
		if (isEveryday)
		{
			isTest = bytes.get(10) == 1;
		}
		else
		{
			startMonth = bytes.getUInt16(10);
			isTest = bytes.get(12) == 1;
			startDay = bytes.getUInt16(13);
		}
	}
}