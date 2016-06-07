package view.events;

import events.Event;

class ChatEvent extends Event
{
	static public inline var MESSAGE_ADD:String = "messageAdd";
	
	public function new(type:String) 
	{
		super(type);
	}	
}