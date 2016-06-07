package events;

class Event
{
	static public inline var COMPLETE:String = "complete";
	
	public var type:String;
	
	public function new(type:String) 
	{
		this.type = type;
	}
}