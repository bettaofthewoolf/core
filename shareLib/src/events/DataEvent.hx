package events;

class DataEvent extends Event
{
	static public inline var ON_LOAD:String = "onLoad";
	
	public var data:String;

	public function new(type:String, data:String) 
	{
		super(type);
		this.data = data;
	}
}