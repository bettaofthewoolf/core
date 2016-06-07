package chatManagment;
/**
 * ...
 * @author ...
 */
class ChatEventMessage
{
	public var time:Float;
	public var name:String;
	public var message:String;

	public function new(time:Float, name:String, message:String) 
	{
		this.message = message;
		this.name = name;
		this.time = time;
		
	}
	public function toString():String 
	{
		return "[ChatEventMessage time=" + time + " name=" + name + " message=" + message + "]";
	}
}