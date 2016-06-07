package passkey;

import events.Event;

class PassKeyCheckerEvents extends Event
{
	static public inline var EVENT_END:String = "eventEnd";
	static public inline var KEY_CORRUPTED:String = "keyCorrupted";
	static public inline var CHECK_IS_OK:String = "checkIsOk";
	static public inline var WAIING_FOR_KEY:String = "waiingForKey";
	
	public function new(type:String) 
	{
		super(type);
	}
	
}