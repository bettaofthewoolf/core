package view.events;

import events.Event;

class UserListEvent extends Event
{
	static public inline var USER_LIST_CHANGE:String = "userListChange";
	
	public function new(type:String) 
	{
		super(type);
	}	
}