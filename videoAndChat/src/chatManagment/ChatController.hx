package chatManagment;

import events.DataEvent;
import external.DataLoader;
import haxe.Timer;
import view.data.MainViewModel;
import view.events.ChatEvent;

class ChatController
{
	var chatEvents:Array<ChatEventMessage> = new Array<ChatEventMessage>();
	var viewModel:MainViewModel;

	public function new(viewModel:MainViewModel) 
	{
		this.viewModel = viewModel;
		initialize();
	}
	
	function initialize() 
	{
		var dataLoader:DataLoader = new DataLoader();
		dataLoader.addEventListener(DataEvent.ON_LOAD, onDataLoaded);
		dataLoader.load("chat.txt");
		
		var timer:Timer = new Timer(250);
		timer.run = onUpdate;
	}
	
	function onUpdate() 
	{
		if (chatEvents.length > 0)
		{
			var currentMessage:ChatEventMessage = chatEvents[0];
			
			if (currentMessage.time < StableDate.currentTime)
			{
				viewModel.addMessage(currentMessage.name, currentMessage.message);
				chatEvents.shift();
			}
		}
	}
	
	private function onDataLoaded(e:DataEvent):Void 
	{
		var chatData:String = e.data;
		
		var chatMessages:Array<String>;
		
		if (chatData.indexOf("\r\n") != -1)
			chatMessages = chatData.split("\r\n");
		else
			chatMessages = chatData.split("\n");
			
		var toShow:Array<ChatEventMessage> = new Array<ChatEventMessage>();
		
		chatMessages.reverse();
		
		var messagesPadding:Int = untyped __js__('getMessagesPadding()') * 1000;
			
		var count:Int = 10;
		for (chatMessage in chatMessages)
		{
			var chatMessageParts:Array<String> = chatMessage.split("|");
			
			var time:String = chatMessageParts[0];
			
			var sign:Int = 1;
			
			if (time.charAt(0) == "-")
			{
				time = time.substr(1, time.length);
				sign = -1;
			}
			
			var timeParts:Array<String> = time.split(":");
			var dateParts:Array<String> = new Array<String>();
			
			var hours:Int = Std.parseInt(timeParts[0]);
			var minutes:Int = Std.parseInt(timeParts[1]);
			var seconds:Int = 0;
			
			if (timeParts.length == 3)
				seconds = Std.parseInt(timeParts[3]);
				
			var name:String = chatMessageParts[1];
			var message:String = chatMessageParts[2];
			var messageTime:Float = Settings.getInstance().START_TIME + (((hours * 60 + minutes) * 60 + seconds) * 1000) * sign + messagesPadding;
			
			if (messageTime < StableDate.currentTime && count > 0)
			{
				count--;
				toShow.unshift(new ChatEventMessage(messageTime, name, message));
			}
			else if(messageTime > StableDate.currentTime)
				chatEvents.unshift(new ChatEventMessage(messageTime, name, message));
		}
		
		//toShow.reverse();
		
		for (chatMessage in toShow)
		{
			viewModel.addMessage(chatMessage.name, chatMessage.message, true);
		}
		
		viewModel.dispatchEvent(new ChatEvent(ChatEvent.MESSAGE_ADD));
	}

	function formatToTime(value:Float):String
	{
		var valueAsString:String = Std.string(value);
		
		if (valueAsString.length == 1)
			valueAsString = "0" + valueAsString;
			
		return valueAsString;
	}
	
	function sortOnTime(x:ChatEventMessage, y:ChatEventMessage):Int 
	{
		if (x.time > y.time)
			return 1;
		else if (x.time < y.time)
			return -1;
		else
			return 0;
	}
	
}