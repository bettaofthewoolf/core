package view.events;

import events.Event;

class WaitingScreenEvent extends Event
{
	static public inline var WAITING_END:String = "waitingEnd";
	
	public function new(type:String) 
	{
		super(type);
		
	}
	
}