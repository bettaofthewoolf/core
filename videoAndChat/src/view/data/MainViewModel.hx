package view.data;

import events.Observer;
import view.events.ChatEvent;
import view.events.UserListEvent;

class MainViewModel extends Observer
{
	public var usersList:Array<String> = new Array<String>();
	
	public var messages:Array<Dynamic> = new Array<Dynamic>();
	public var inputText:String = "";
	public var userNamesList:Array<String>;
	
	public function new() 
	{
		super();
	}	
	
	public function addUsers(users:Array<String>):Void
	{
		for (user in users)
			usersList.push(user);
		
		dispatchEvent(new UserListEvent(UserListEvent.USER_LIST_CHANGE));
	}
	
	public function addUser(user:String, silent:Bool = false):Void
	{
		usersList.push(user);
		
		if(silent == false)
			dispatchEvent(new UserListEvent(UserListEvent.USER_LIST_CHANGE));
	}
	
	public function addMessage(name:String, message:String, silent:Bool = false) 
	{
		messages.push({name:name, message:message});
		
		if(!silent)
			dispatchEvent(new ChatEvent(ChatEvent.MESSAGE_ADD));
	}
	
	function formatMinutes(minutes:Int):String
	{
		var minutesAsString:String = Std.string(minutes);
		
		if (minutesAsString.length == 1)
			minutesAsString = "0" + minutesAsString;
			
		return minutesAsString;
	}
}